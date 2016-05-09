module BEL::Translator::Plugins

  module Rj

    ID          = :rj
    NAME        = 'RDF/JSON RDF Translator'
    DESCRIPTION = 'A translator that can read/write BEL nanopubs to RDF/JSON (https://dvcs.w3.org/hg/rdf/raw-file/default/rdf-json/index.html).'
    MEDIA_TYPES = %i(application/rdf+json)
    EXTENSIONS  = %i(rj)

    def self.create_translator(options = {})
      require 'rdf'
      require 'rdf/json'
      require_relative 'rdf/translator'
      BELRDF::Translator.new(
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
