require_relative 'nanopub_yielder'
require_relative 'xbel_yielder'

module BEL::Translator::Plugins

  module Xbel

    class XbelTranslator

      include ::BEL::Translator

      def read(data, options = {})
        NanopubYielder.new(data, options)
      end

      def write(objects, writer = StringIO.new, options = {})
        if block_given?
          XBELYielder.new(objects, options).each { |xml_data|
            yield xml_data
          }
        else
          if writer
            XBELYielder.new(objects, options).each { |xml_data|
              writer << xml_data
              writer.flush
            }
            writer
          else
            XBELYielder.new(objects, options)
          end
        end
      end
    end
  end
end
