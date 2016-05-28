require 'rdf'

module BEL
  module BELRDF
    module RDFConverter
      # Convenience function to create an {RDF::Statement} given a triple
      # of subject, predicate, and object.
      def s(subject, predicate, object)
        RDF::Statement.new(subject, predicate, object)
      end
    end
  end
end
