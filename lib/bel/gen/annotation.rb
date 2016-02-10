module BEL
  module Gen
    module Annotation
      include BEL::Quoting

      ANNOTATIONS =
        BEL::Annotation::ANNOTATION_LATEST.map { |keyword, (url, rdf_uri)|
          BEL::Annotation::AnnotationDefinition.new(keyword, url, rdf_uri)
        }

      # Retrieve the annotations chosen during use of {#annotation}.
      # @return [Hash] hash of keyword to {BEL::Annotation::AnnotationDefinition}
      def referenced_annotations
        @referenced_annotations ||= Hash[
          ANNOTATIONS.map { |anno| [anno.keyword, anno] }
        ]
      end

      def annotation(*annotations)
        # pick annotation definition
        anno = Rantly {
          choose(*ANNOTATIONS)
        }

        # track annotation definitions
        referenced_annotations[anno.keyword] = anno

        {
          :name  => anno.keyword,
          :value => anno.values.keys.sample
        }
      end
    end
  end
end
