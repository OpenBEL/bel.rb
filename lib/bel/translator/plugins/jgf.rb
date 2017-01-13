module BEL::Translator::Plugins

  module Jgf

    ID          = :jgf
    NAME        = 'JSON Graph Format Translator'
    DESCRIPTION = 'A translator that can read/write BEL nanopubs to JGF.'
    MEDIA_TYPES   = %i(application/vnd.jgf+json)
    EXTENSIONS    = %i(jgf.json)

    def self.create_translator(options = {})
      require_relative 'jgf/translator'

      JgfTranslator.new
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
