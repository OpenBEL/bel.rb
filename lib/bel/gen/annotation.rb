require_relative '../gen'
BEL::Gen.soft_require('rantly')

module BEL
  module Gen

    # The {Annotation} module defines methods that generate random annotations
    # to be used in a nanopub's {BEL::Nanopub::ExperimentContext}.
    module Annotation

      # Array of the latest OpenBEL {BEL::Annotation::AnnotationDefinition}.
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

      # Returns a random annotation as a hash of +:name+ and +:value+. These
      # can be added directly to a nanopub's {BEL::Nanopub::ExperimentContext}.
      #
      # @return [Hash] random annotation; hash of +:name+ and +:value+
      def annotation
        # pick annotation definition
        anno = Rantly {
          choose(*ANNOTATIONS)
        }

        # track annotation definitions
        referenced_annotations[anno.keyword] = anno

        {
          :name  => anno.keyword,
          :value => Rantly {
            sized(range(5, 20)) {
              string(/[[:alnum:]]|[[:blank:]]|[[:punct:]]/)
            }
          }
        }
      end
    end
  end
end
