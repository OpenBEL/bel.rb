module BEL::Translator::Plugins

  module Xbel

    ID          = :xbel
    NAME        = 'XBEL Translator'
    DESCRIPTION = 'A translator that can read/write BEL nanopubs to XBEL.'
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
