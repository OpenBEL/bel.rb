require_relative 'evidence_yielder'
require_relative 'xbel_yielder'

module BEL::Translator::Plugins

  module Xbel

    class XbelTranslator

      include ::BEL::Translator

      ID          = :xbel
      NAME        = 'XBEL Translator'
      DESCRIPTION = 'A translator that can read and write evidence to XBEL (version 1.0). XBEL is an XML dialect. XML Schema for version 1.0 is published here (http://resource.belframework.org/belframework/1.0/schema/xbel.xsd).'
      MEDIA_TYPES = %i(application/xml)
      EXTENSIONS  = %i(xml xbel)

      def id
        ID
      end

      def name
        NAME
      end

      def description
        DESCRIPTION
      end

      def media_types
        MEDIA_TYPES
      end

      def file_extensions
        EXTENSIONS
      end

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
