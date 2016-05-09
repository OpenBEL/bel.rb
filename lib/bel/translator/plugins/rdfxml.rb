module BEL::Translator::Plugins

  module Rdfxml

    ID          = :rdfxml
    NAME        = 'RDF/XML RDF Translator'
    DESCRIPTION = 'A translator that can read/write BEL nanopubs to RDF/XML.'
    MEDIA_TYPES = %i(application/rdf+xml)
    EXTENSIONS  = %i(rdf)

    def self.create_translator(options = {})
      require 'rdf'
      require 'rdf/rdfxml'
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
