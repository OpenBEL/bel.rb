module BEL::Translator::Plugins

  module Turtle

    ID          = :turtle
    NAME        = 'Turtle RDF Translator'
    DESCRIPTION = 'A translator that can read/write BEL nanopubs to RDF Turtle.'
    MEDIA_TYPES = %i(application/turtle application/x-turtle)
    EXTENSIONS  = %i(ttl)

    def self.create_translator(options = {})
      require 'rdf'
      require 'rdf/turtle'
      require_relative 'rdf2/translator'
      BEL::BELRDF::Translator.new(ID, options[:write_schema])
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
