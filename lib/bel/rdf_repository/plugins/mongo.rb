# Load RDF library dependencies
require 'rdf'
require 'rdf/mongo'
require 'addressable/uri'
require 'uuid'

module BEL::RdfRepository::Plugins

  module Mongo

    extend ::BEL::RdfRepository::ClassMethods

    NAME        = 'Mongo RDF Repository'
    DESCRIPTION = 'A repository of RDF data on MongoDB.'

    def self.create_repository(options = {})
      RDF::Mongo::Repository.new(options)
    end

    def self.name
      NAME
    end

    def self.description
      DESCRIPTION
    end
  end
end
