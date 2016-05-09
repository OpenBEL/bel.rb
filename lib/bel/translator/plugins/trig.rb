module BEL::Translator::Plugins

  module Trig

    ID          = :trig
    NAME        = 'TriG RDF Translator'
    DESCRIPTION = 'A translator that can read/write BEL nanopubs to TriG.'
    MEDIA_TYPES = %i(application/trig)
    EXTENSIONS  = %i(trig)

    def self.create_translator(options = {})
      require 'rdf'
      require 'rdf/trig'
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
