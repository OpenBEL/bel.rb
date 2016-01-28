module BEL::Translator::Plugins

  module Jsonld

    ID          = :jsonld
    NAME        = 'JSON-LD RDF Translator'
    DESCRIPTION = 'A translator that can read and write JSON-LD (http://json-ld.org/) for BEL evidence.'
    MEDIA_TYPES = %i(application/ld+json)
    EXTENSIONS  = %i(jsonld)

    def self.create_translator(options = {})
      require 'rdf'
      require 'json/ld'
      require_relative 'rdf/translator'

      BEL::Translator::Plugins::Rdf::RdfTranslator.new(ID)
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
