require_relative 'evidence_yielder'
require_relative 'bel_yielder'

module BEL::Translator::Plugins

  module BelScript

    class BelScriptTranslator

      include ::BEL::Translator

      def read(data, options = {})
        EvidenceYielder.new(data, options)
      end

      def write(objects, writer = StringIO.new, options = {})
        if block_given?
          BelYielder.new(objects, options).each { |bel_part|
            yield bel_part
          }
        else
          if writer
            BelYielder.new(objects, options).each { |bel_part|
              writer << "#{bel_part}"
              writer.flush
            }
            writer
          else
            BelYielder.new(objects, options)
          end
        end
      end
    end
  end
end
