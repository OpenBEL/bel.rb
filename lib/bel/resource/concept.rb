require 'rdf'
require 'rdf/vocab'

module BEL
  module Resource
    # Concept captures the properties available on an RDF Annotation or
    # Namespace Concept.
    module Concept
      DC   = RDF::Vocab::DC
      SKOS = RDF::Vocab::SKOS
      BELV = RDF::Vocabulary.new('http://www.openbel.org/vocabulary/')

      def type
        @rdf_repository
        .query([:subject => @uri, :predicate => RDF.type])
        .map do |solution|
          solution.object.to_s
        end
      end

      def pref_label
        @rdf_repository
        .query([:subject => @uri, :predicate => SKOS.prefLabel])
        .map do |solution|
          solution.object.to_s
        end
      end

      def identifier
        @rdf_repository
        .query([:subject => @uri, :predicate => DC.identifier])
        .map do |solution|
          solution.object.to_s
        end
      end

      def title
        @rdf_repository
        .query([:subject => @uri, :predicate => DC.title])
        .map do |solution|
          solution.object.to_s
        end
      end

      def alt_label
        @rdf_repository
        .query([:subject => @uri, :predicate => SKOS.altLabel])
        .map do |solution|
          solution.object.to_s
        end
      end

      def from_species
        @rdf_repository
        .query([:subject => @uri, :predicate => BELV.fromSpecies])
        .map do |solution|
          solution.object.to_s
        end
      end
    end
  end
end
