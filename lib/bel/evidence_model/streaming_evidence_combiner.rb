module BEL
  module Model

    class StreamingEvidenceCombiner

      attr_reader :annotation_references, :namespace_references

      def initialize(evidence_collection)
        @evidence_collection   = evidence_collection
      end

      def each
        if block_given?
          @evidence_collection.each do |evidence|
            once {
              @annotation_references = evidence.references.annotations
              @namespace_references  = evidence.references.namespaces
            }

            yield evidence
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
