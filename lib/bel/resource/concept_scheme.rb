require 'rdf'
require 'rdf/vocab'

module BEL
  module Resource
    # ConceptScheme captures the properties available on an RDF Annotation or
    # Namespace ConceptScheme.
    module ConceptScheme
      SKOS = RDF::Vocab::SKOS
      BELV = RDF::Vocabulary.new('http://www.openbel.org/vocabulary/')

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

      def domain
        solution =
          @rdf_repository
          .query([:subject => @uri, :predicate => BELV.domain])
          .map do |solution|
            solution.object.to_s
          end
      end

      def prefix
        solution =
          @rdf_repository
          .query([:subject => @uri, :predicate => BELV.prefix])
          .map do |solution|
            solution.object.to_s
          end
      end
    end
  end
end
