module BEL
  module Nanopub

    class MapReferencesCombiner < BufferingNanopubCombiner

      def initialize(nanopub_collection, map_references)
        @nanopub_collection = nanopub_collection
        @map_references     = map_references
      end

      def annotation_references
        @map_references.annotation_references
      end

      def namespace_references
        @map_references.namespace_references
      end

      def each
        if block_given?
          @nanopub_collection.each do |nanopub|
            yield rewrite_nanopub!(nanopub, @map_references)
          end
        else
          to_enum(:each)
        end
      end
    end
  end
end
