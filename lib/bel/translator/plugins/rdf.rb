module BEL::Translator::Plugins

  module Rdf

    ID          = :rdf
    NAME        = 'BEL RDF Translator'
    MEDIA_TYPES = %i(
      application/n-quads
      application/n-triples
      application/rdf+xml
      application/turtle
      application/x-turtle
      text/turtle
    )
    EXTENSIONS  = %i(
      nq
      nt
      rdf
      ttl
    )

    def self.create_translator(options = {})
      require_relative 'rdf/translator'
      RdfTranslator.new
    end

    def self.id
      ID
    end

    def self.name
      NAME
    end

    def self.media_types
      MEDIA_TYPES
    end 

    def self.file_extensions
      EXTENSIONS
    end
  end
end
