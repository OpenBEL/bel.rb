require          'rdf'
require          'rdf/vocab'
require_relative 'concept_scheme'
require_relative 'annotation_value'

module BEL
  module Resource
    # Annotation represents a AnnotationConceptScheme RDF Resource and
    # associated properties.
    class Annotation
      include ConceptScheme

      DC   = RDF::Vocab::DC
      SKOS = RDF::Vocab::SKOS
      BELV = RDF::Vocabulary.new('http://www.openbel.org/vocabulary/')

      attr_reader :uri

      def initialize(rdf_repository, uri)
        @rdf_repository = rdf_repository
        @uri            = RDF::URI(uri.to_s)
        @uri_hash       = @uri.hash
        @concept_query  = [
          :predicate => SKOS.inScheme,
          :object    => @uri
        ]
      end

      def each
        return to_enum(:each) unless block_given?
				@rdf_repository.
					query(@concept_query) { |solution|
						yield AnnotationValue.new(@rdf_repository, solution.subject)
					}
      end

      def find(*values)
        return to_enum(:find, *values) unless block_given?

        values.flatten.each do |v|
          yield find_value(v)
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

      def find_value(value)
        # nil input always yield nil
        return nil if value == nil

        # RDF::URI input handled as a special case
        return find_annotation_value_uri(value) if value.is_a?(RDF::URI)

        # input handled as literal identifier; empty literals match in a
        # pattern as if it was nil so return nil if empty string
        vstr  = value.to_s
        return nil if vstr.empty?

        # match input as annotation value prefLabel
				vlit  = RDF::Literal(vstr)
				label = value_query(
					:predicate => SKOS.prefLabel,
					:object    => vlit
				)
			  return AnnotationValue.new(@rdf_repository, label.subject) if label

        # match input as annotation value identifier
				ident = value_query(
					:predicate => DC.identifier,
					:object    => vlit
				)
				return AnnotationValue.new(@rdf_repository, ident.subject) if ident

        # match input as annotation value title
				title = value_query(
					:predicate => DC.title,
					:object    => vlit
				)
				return AnnotationValue.new(@rdf_repository, title.subject) if title
      end

      def find_annotation_value_uri(uri)
        in_annotation_check = @rdf_repository.has_statement?(
          RDF::Statement(uri, SKOS.inScheme, @uri)
        )
        return nil if !in_annotation_check

        type_check = RDF::Statement(uri, RDF.type, BELV.AnnotationConcept)
				if @rdf_repository.has_statement?(type_check)
          return AnnotationValue.new(@rdf_repository, uri)
        end
			end

      def value_query(pattern)
				@rdf_repository.query(pattern).find { |solution|
				  @rdf_repository.has_statement?(
						RDF::Statement(solution.subject, SKOS.inScheme, @uri)
					)
				}
      end
    end
  end
end
