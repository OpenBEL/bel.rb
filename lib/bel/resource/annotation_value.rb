require          'rdf'
require_relative 'annotation'
require_relative 'annotations'

module BEL
  module Resource

    # TODO Document
    class AnnotationValue

      attr_reader :uri

      # TODO Document
      def initialize(rdf_repository, uri)
        @rdf_repository = rdf_repository
        @uri            = RDF::URI(uri.to_s)
        @uri_hash       = @uri.hash
        @eq_query       = [
          :subject   => @uri,
          :predicate => RDF::SKOS.exactMatch
        ]
        @ortho_query    = [
          :subject   => @uri,
          :predicate => BELV.orthologousMatch
        ]
        @predicates     = @rdf_repository.query(:subject => @uri).
                            each.map(&:predicate).uniq
      end

      def annotation
        Annotation.new(@rdf_repository, self.inScheme)
      end

      def equivalents(target_annotations = :all)
        return to_enum(:equivalents, target_annotations) unless block_given?
        if target_annotations == :all
          @rdf_repository.
            query(@eq_query) { |solution|
              yield AnnotationValue.new(@rdf_repository, solution.object)
            }
        else
          target_annotations = Annotations.new(@rdf_repository).
            find([target_annotations].flatten).to_a
          target_annotations.compact!
          target_annotations.map! { |ns| ns.uri }

          @rdf_repository.
            query(@eq_query).map { |solution|
              AnnotationValue.new(@rdf_repository, solution.object)
            }.select { |value|
              scheme_uri = value.inScheme
              target_annotations.include?(scheme_uri)
            }.each { |value|
              yield value
            }
        end
			end

      def hash
        @uri_hash
      end

      def ==(other)
        return false if other == nil
        @uri == other.uri
      end
      alias_method :eql?, :'=='

      protected

      def method_missing(method)
        method_predicate = @predicates.find { |p|
          p.qname[1].to_sym == method.to_sym
        }
        return nil unless method_predicate
        objects = @rdf_repository.query(
          :subject   => @uri,
          :predicate => method_predicate
        ).each.map(&:object)
        objects.size == 1 ? objects.first : objects.to_a
      end
    end
  end
end
