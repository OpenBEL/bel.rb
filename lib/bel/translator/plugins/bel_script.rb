module BEL::Translator::Plugins

  module BelScript

    ID          = :bel
    NAME        = 'BEL Script Translator'
    DESCRIPTION = 'A translator that can read and write evidence to BEL Script (version 1.0).'
    MEDIA_TYPES = %i(application/bel)
    EXTENSIONS  = %i(bel)

    def self.create_translator(options = {})
      require_relative 'bel_script/translator'
      BelScriptTranslator.new
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
