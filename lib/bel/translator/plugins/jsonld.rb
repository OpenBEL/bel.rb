module BEL::Translator::Plugins

  module Jsonld

    ID          = :jsonld
    NAME        = 'JSON-LD RDF Translator'
    DESCRIPTION = 'A translator that can read/write BEL nanopubs to JSON-LD.'
    MEDIA_TYPES = %i(application/ld+json)
    EXTENSIONS  = %i(jsonld)

    def self.create_translator(options = {})
      require 'rdf'
      require 'json/ld'
      require_relative 'rdf/graph_translator'
      BELRDF::GraphTranslator.new(
        ID,
        options[:write_schema]
      )
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
