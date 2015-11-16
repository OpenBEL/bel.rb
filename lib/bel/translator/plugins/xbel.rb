module BEL::Translator::Plugins

  module Xbel

    ID          = :xbel
    NAME        = 'XBEL Translator'
    DESCRIPTION = 'A translator that can read and write evidence to XBEL (version 1.0). XBEL is an XML dialect. XML Schema for version 1.0 is published here (http://resource.belframework.org/belframework/1.0/schema/xbel.xsd).'
    MEDIA_TYPES = %i(application/xml)
    EXTENSIONS  = %i(xml xbel)

    def self.create_translator(options = {})
      require_relative 'xbel/translator'
      XbelTranslator.new
    end

    def self.id
      ID
    end

    def self.name
      NAME
    end

    def self.description
      DESCRIPTION
    end

    def self.media_types
      MEDIA_TYPES
    end

    def self.file_extensions
      EXTENSIONS
    end
  end
end
