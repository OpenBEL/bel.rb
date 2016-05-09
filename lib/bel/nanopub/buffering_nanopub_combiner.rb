require_relative 'hash_map_references'

module BEL
  module Nanopub

    # NanopubReferenceCombiner is responsible for disambiguating nanopubs
    # with overlapping sets of annotation/namespace references. This can occur
    # when documents use the same keyword to refer to more than one reference.
    #
    # For example, nanopub A may be annotated with:
    #
    #    {
    #      :keyword => :Species,
    #      :type    => :uri,
    #      :domain  => 'file:///20131211/annotation/species-taxonomy-id.belanno'
    #    }
    #
    # while nanopub B may be annotated with:
    #
    #    {
    #      :keyword => :Species,
    #      :type    => :uri,
    #      :domain  => 'file:///20150611/annotation/species-taxonomy-id.belanno'
    #    }
    #
    # It is the job of this class to remap references to disambiguate the
    # keywords.
    #
    # @abstract Subclass and override {#map_namespace_reference} to implement
    # mapping of namespaces.
    class BufferingNanopubCombiner

      attr_reader :annotation_references, :namespace_references

      def initialize(nanopub_collection)
        @nanopub_collection = nanopub_collection
      end

      def each
        if block_given?
          nanopub_array, map_references =
            combine_references(@nanopub_collection)
          @annotation_references = map_references.annotation_references
          @namespace_references  = map_references.namespace_references

          nanopub_array.each do |nanopub|
            if nanopub.bel_statement.is_a?(String)
              nanopub.bel_statement = BEL::Nanopub::Nanopub.parse_statement(nanopub)
            end
            yield rewrite_nanopub!(nanopub, map_references)
          end
        else
          to_enum(:each)
        end
      end

      protected

      def combine_references(nanopub_collection)
        annotation_reference_map = {}
        namespace_reference_map  = {}
        annotations = []
        namespaces  = []
        buffered_nanopub = nanopub_collection.each.map { |nanopub|
          annotations, remap =
            BEL::Nanopub.union_annotation_references(
              annotations,
              nanopub.references.annotations,
              'incr'
            )
          annotation_reference_map.merge!(remap)

          namespaces, remap =
            BEL::Nanopub.union_namespace_references(
              namespaces,
              nanopub.references.namespaces,
              'incr'
            )
          namespace_reference_map.merge!(remap)

          nanopub
        }.to_a

        [
          buffered_nanopub,
          HashMapReferences.new(
            annotation_reference_map,
            namespace_reference_map
          )
        ]
      end

      def rewrite_nanopub!(nanopub, map_references)
        rewrite_experiment_context!(
          nanopub.experiment_context,
          nanopub.references.annotations,
          map_references
        )

        rewrite_statement!(
          nanopub.bel_statement,
          nanopub.references.namespaces,
          map_references
        )

        nanopub
      end

      def rewrite_statement!(statement, namespace_references, map_references)
        keyword_to_reference = Hash[
          namespace_references.map { |reference|
            [reference[:keyword], reference]
          }
        ]

        sub = statement.subject
        if sub
          rewrite_term!(sub, keyword_to_reference, map_references)
        end

        obj = statement.object
        if obj
          case obj
          when ::BEL::Nanopub::Statement
            rewrite_statement!(obj, namespace_references, map_references)
          when ::BEL::Nanopub::Term
            rewrite_term!(obj, keyword_to_reference, map_references)
          end
        end
      end

      def rewrite_term!(term, keyword_to_reference, map_references)
        return unless term

        term.arguments.each do |arg|
          case arg
          when ::BEL::Nanopub::Parameter
            if arg.ns
              prefix =
                if arg.ns.respond_to?(:prefix)
                  arg.ns.prefix
                else
                  arg.ns[:prefix]
                end
              reference     = keyword_to_reference[prefix.to_sym]
              new_reference = map_references.map_namespace_reference(reference)
              if new_reference
                arg.ns = BEL::Namespace::NamespaceDefinition.new(
                  new_reference[:keyword],
                  new_reference[:uri]
                )
              end
            end
          when ::BEL::Nanopub::Term
            rewrite_term!(arg, keyword_to_reference, map_references)
          end
        end
      end

      def rewrite_experiment_context!(
        experiment_context,
        annotation_references,
        map_references
      )
        references = Hash[
          annotation_references.map { |reference|
            [reference[:keyword], reference]
          }
        ]
        experiment_context.values.each do |annotation|
          new_reference = map_references.map_annotation_reference(
            references[annotation[:name].to_sym]
          )

          if new_reference
            annotation[:name] = new_reference[:keyword]
          end
        end
      end
    end
  end
end
