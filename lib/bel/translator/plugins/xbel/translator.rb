require_relative 'evidence_yielder'
require_relative 'xbel_yielder'

module BEL::Translator::Plugins

  module Xbel

    class XbelTranslator

      include ::BEL::Translator

      def read(data)
        EvidenceYielder.new(data)
      end

      def write(objects, writer = StringIO.new, options = {})
        XBELYielder.new(objects).each { |xml_data|
          writer << xml_data
          writer.flush
        }
      end
    end
  end
end
