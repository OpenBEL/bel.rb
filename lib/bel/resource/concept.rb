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

      def in_scheme
        solution =
          @rdf_repository
          .query([:subject => @uri, :predicate => SKOS.inScheme])
          .map do |solution|
            solution.object.to_s
          end
      end

      def type
        solution =
          @rdf_repository
          .query([:subject => @uri, :predicate => RDF.type])
          .map do |solution|
            solution.object.to_s
          end
      end

      def pref_label
        solution =
          @rdf_repository
          .query([:subject => @uri, :predicate => SKOS.prefLabel])
          .map do |solution|
            solution.object.to_s
          end
      end

      def identifier
        solution =
          @rdf_repository
          .query([:subject => @uri, :predicate => DC.identifier])
          .map do |solution|
            solution.object.to_s
          end
      end

      def title
        solution =
          @rdf_repository
          .query([:subject => @uri, :predicate => DC.title])
          .map do |solution|
            solution.object.to_s
          end
      end

      def alt_label
        solution =
          @rdf_repository
          .query([:subject => @uri, :predicate => SKOS.altLabel])
          .map do |solution|
            solution.object.to_s
          end
      end

      def from_species
        solution =
          @rdf_repository
          .query([:subject => @uri, :predicate => BELV.fromSpecies])
          .map do |solution|
            solution.object.to_s
          end
      end
    end
  end
end
