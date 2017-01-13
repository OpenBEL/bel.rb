module BEL
  module Nanopub

    class StreamingNanopubCombiner

      attr_reader :annotation_references, :namespace_references

      def initialize(nanopub_collection)
        @nanopub_collection = nanopub_collection
      end

      def each
        if block_given?
          @nanopub_collection.each do |nanopub|
            once {
              @annotation_references = nanopub.references.annotations
              @namespace_references  = nanopub.references.namespaces
            }

            yield nanopub
          end
        else
          to_enum(:each)
        end
      end

      private

      def once(*block_args, &block)
        unless @_once_switch
          block.call(*block_args)
          @_once_switch = 1
        end
      end
    end
  end
end
