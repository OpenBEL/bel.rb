require_relative 'hash_map_references'

module BEL
  module Model

    # EvidenceReferenceCombiner is responsible for disambiguating evidence
    # with overlapping sets of annotation/namespace references. This can occur
    # when documents use the same keyword to refer to more than one reference.
    #
    # For example, evidence A may be annotated with:
    #
    #    {
    #      :keyword => :Species,
    #      :type    => :uri,
    #      :domain  => 'file:///20131211/annotation/species-taxonomy-id.belanno'
    #    }
    #
    # while evidence B may be annotated with:
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
    class BufferingEvidenceCombiner

      attr_reader :annotation_references, :namespace_references

      def initialize(evidence_collection)
        @evidence_collection = evidence_collection
      end

      def each
        if block_given?
          evidence_array, map_references =
            combine_references(@evidence_collection)
          @annotation_references = map_references.annotation_references
          @namespace_references  = map_references.namespace_references

          evidence_array.each do |evidence|
            if evidence.bel_statement.is_a?(String)
              evidence.bel_statement = BEL::Model::Evidence.parse_statement(evidence)
            end
            yield rewrite_evidence!(evidence, map_references)
          end
        else
          to_enum(:each)
        end
      end

      protected

      def combine_references(evidence_collection)
        annotation_reference_map = {}
        namespace_reference_map  = {}
        annotations = []
        namespaces  = []
        buffered_evidence = evidence_collection.each.map { |evidence|
          annotations, remap =
            BEL::Model.union_annotation_references(
              annotations,
              evidence.references.annotations,
              'incr'
            )
          annotation_reference_map.merge!(remap)

          namespaces, remap =
            BEL::Model.union_namespace_references(
              namespaces,
              evidence.references.namespaces,
              'incr'
            )
          namespace_reference_map.merge!(remap)

          evidence
        }.to_a

        [
          buffered_evidence,
          HashMapReferences.new(
            annotation_reference_map,
            namespace_reference_map
          )
        ]
      end

      def rewrite_evidence!(evidence, map_references)
        rewrite_experiment_context!(
          evidence.experiment_context,
          evidence.references.annotations,
          map_references
        )

        rewrite_statement!(
          evidence.bel_statement,
          evidence.references.namespaces,
          map_references
        )

        evidence
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
          when ::BEL::Model::Statement
            rewrite_statement!(obj, namespace_references, map_references)
          when ::BEL::Model::Term
            rewrite_term!(obj, keyword_to_reference, map_references)
          end
        end
      end

      def rewrite_term!(term, keyword_to_reference, map_references)
        return unless term

        term.arguments.each do |arg|
          case arg
          when ::BEL::Model::Parameter
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
                arg.ns = map_references.map_namespace_reference(reference)
              end
            end
          when ::BEL::Model::Term
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
