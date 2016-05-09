module BEL
  module Nanopub
    module MapReferences

      def annotation_references
        raise NotImplementedError.new(
          "#{__method__} is not implemented for class #{self.class}"
        )
      end

      def namespace_references
        raise NotImplementedError.new(
          "#{__method__} is not implemented for class #{self.class}"
        )
      end

      def map_annotation_reference(reference)
        raise NotImplementedError.new(
          "#{__method__} is not implemented for class #{self.class}"
        )
      end

      def map_namespace_reference(reference)
        raise NotImplementedError.new(
          "#{__method__} is not implemented for class #{self.class}"
        )
      end
    end
  end
end
