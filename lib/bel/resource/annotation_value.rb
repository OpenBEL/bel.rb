require          'rdf'
require          'rdf/vocab'
require_relative 'concept'
require_relative 'annotation'
require_relative 'annotations'

module BEL
  module Resource

    # AnnotationValue represents a AnnotationConcept RDF Resource and
    # associated properties.
    class AnnotationValue
      include Concept

      DC   = RDF::Vocab::DC
      SKOS = RDF::Vocab::SKOS
      BELV = RDF::Vocabulary.new('http://www.openbel.org/vocabulary/')

      attr_reader :uri

      def initialize(rdf_repository, uri)
        @rdf_repository = rdf_repository
        @uri            = RDF::URI(uri.to_s)
        @uri_hash       = @uri.hash
        @eq_query       = [
          :subject   => @uri,
          :predicate => SKOS.exactMatch
        ]
        @ortho_query    = [
          :subject   => @uri,
          :predicate => BELV.orthologousMatch
        ]
      end

      def annotation
        Annotation.new(@rdf_repository, self.in_scheme)
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
    end
  end
end
