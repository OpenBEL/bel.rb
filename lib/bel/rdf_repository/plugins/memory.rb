# Load RDF library dependencies
require 'rdf'
require 'rdf/mongo'
require 'addressable/uri'
require 'uuid'

module BEL::RdfRepository::Plugins

  module Memory

    extend ::BEL::RdfRepository::ClassMethods

    NAME        = 'In-memory RDF Repository'
    DESCRIPTION = 'An in-memory repository provided by default in RDF.rb.'

    def self.create_repository(options = {})
      RDF::Repository.new(options)
    end

    def self.name
      NAME
    end

    def self.description
      DESCRIPTION
    end
  end
end
