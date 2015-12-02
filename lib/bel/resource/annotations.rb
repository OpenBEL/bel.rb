require_relative 'annotation'

module BEL
  module Resource

    # TODO Document
    class Annotations

      # TODO Document
      QUERY_ANNOTATIONS = RDF::Query.new do
        pattern [:uri, RDF.type, BELV.AnnotationConceptScheme]
      end

      # TODO Document
      def initialize(rdf_repository)
        @rdf_repository = rdf_repository
      end

      # TODO Document
      def each
        return to_enum(:each) unless block_given?
				@rdf_repository.
					query(QUERY_ANNOTATIONS) { |solution|
						yield Annotation.new(@rdf_repository, solution.uri)
					}
      end

      def find(*annotations)
        return to_enum(:find, *annotations) unless block_given?

        annotations.flatten.each do |an|
          yield find_annotation(an)
				end
			end

      protected

      def find_annotation(annotation)
        # nil input always yield nil
        return nil if annotation == nil

        # RDF::URI input handled as a special case
        return find_annotation_uri(annotation) if annotation.is_a?(RDF::URI)

        # input handled as literal identifier; empty literals will match
        # in a pattern as if it was nil so return nil if empty string
        nstr  = annotation.to_s
        return nil if nstr.empty?

        # match input as annotation prefix
				nlit   = RDF::Literal(nstr)
				prefix = annotation_query(
					:predicate => BELV.prefix,
					:object    => nlit
				)
			  return Annotation.new(@rdf_repository, prefix.subject) if prefix

        # match input as annotation prefLabel
				label  = annotation_query(
					:predicate => RDF::SKOS.prefLabel,
					:object    => nlit
				)
				return Annotation.new(@rdf_repository, label.subject) if label
      end

      def find_annotation_uri(uri)
        type_check = RDF::Statement(uri, RDF.type, BELV.AnnotationConceptScheme)
				if @rdf_repository.has_statement?(type_check)
          return Annotation.new(@rdf_repository, uri)
        end
			end

      def annotation_query(pattern)
				@rdf_repository.query(pattern).find { |solution|
				  @rdf_repository.has_statement?(
						RDF::Statement(solution.subject, RDF.type, BELV.AnnotationConceptScheme)
					)
				}
      end
    end
  end
end
