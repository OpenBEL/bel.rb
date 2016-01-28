module BEL::Translator::Plugins

  module Rdfxml

    ID          = :rdfxml
    NAME        = 'RDF/XML RDF Translator'
    DESCRIPTION = 'A translator that can read and write RDF/XML for BEL evidence.'
    MEDIA_TYPES = %i(application/rdf+xml)
    EXTENSIONS  = %i(rdf)

    def self.create_translator(options = {})
      require 'rdf'
      require 'rdf/rdfxml'
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
