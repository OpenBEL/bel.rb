require_relative 'map_references'

module BEL
  module Nanopub
    class HashMapReferences
      include MapReferences

      def initialize(annotation_reference_map, namespace_reference_map)
        @annotation_reference_map = annotation_reference_map
        @namespace_reference_map  = namespace_reference_map

        @annotation_references = annotation_reference_map.values.uniq
        @namespace_references  = namespace_reference_map.values.uniq
      end

      def annotation_references
        @annotation_references
      end

      def namespace_references
        @namespace_references
      end

      def map_annotation_reference(reference)
        @annotation_reference_map[reference]
      end

      def map_namespace_reference(reference)
        @namespace_reference_map[reference]
      end
    end
  end
end
