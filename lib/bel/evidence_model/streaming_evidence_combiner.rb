module BEL
  module Model

    class StreamingEvidenceCombiner < BufferingEvidenceCombiner

      def initialize(evidence_collection, map_references)
        @evidence_collection   = evidence_collection
        @map_references        = map_references
      end

      def annotation_references
        @map_references.annotation_references
      end

      def namespace_references
        @map_references.namespace_references
      end

      def each
        if block_given?
          @evidence_collection.each do |evidence|
            yield rewrite_evidence!(evidence, @map_references)
          end
        else
          to_enum(:each)
        end
      end
    end
  end
end
