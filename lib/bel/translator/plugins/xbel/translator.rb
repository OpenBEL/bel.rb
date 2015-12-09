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
        if block_given?
          XBELYielder.new(objects).each { |xml_data|
            yield xml_data
          }
        else
          if writer
            XBELYielder.new(objects).each { |xml_data|
              writer << xml_data
              writer.flush
            }
          else
            XBELYielder.new(objects)
          end
        end
      end
    end
  end
end
