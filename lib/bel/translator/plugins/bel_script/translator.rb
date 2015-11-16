require_relative 'evidence_yielder'
require_relative 'bel_yielder'

module BEL::Translator::Plugins

  module BelScript

    class BelScriptTranslator

      include ::BEL::Translator

      def read(data, options = {})
        EvidenceYielder.new(data)
      end

      def write(objects, writer = StringIO.new, options = {})
        BelYielder.new(objects).each { |bel_part|
          writer << "#{bel_part}"
          writer.flush
        }
      end
    end
  end
end
