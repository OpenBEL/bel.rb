module BEL::Translator::Plugins

  module Bnj

    ID            = :bnj
    NAME          = 'BEL Nanopub JSON Translator'
    DESCRIPTION   = 'A translator that can read/write BEL nanopubs to BNJ.'
    MEDIA_TYPES   = %i(application/json)
    EXTENSIONS    = %i(json)
    NANOPUB_ROOT  = :nanopub

    def self.create_translator(options = {})
      require_relative 'bnj/translator'
      BnjTranslator.new
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
