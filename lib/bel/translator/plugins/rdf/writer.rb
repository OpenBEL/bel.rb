require_relative 'uuid'

module BEL::Translator::Plugins

  module Rdf::Writer

    class RDFYielder
      attr_reader :writer

      Rdf = ::BEL::Translator::Plugins::Rdf

      def initialize(io, format)
        rdf_writer = find_writer(format)
        @writer = rdf_writer.new(io, { :stream => true })
      end

      def <<(evidence)
        graph = RDF::URI("http://www.openbel.org/evidence-graphs/#{Rdf.generate_uuid}")
        triples = evidence.bel_statement.to_rdf[1]
        triples.each do |triple|
          @writer.write_statement(::RDF::Statement(*triple, :graph_name => graph))
        end
      end

      def done
        @writer.write_epilogue
      end

      private

      def find_writer(format)
        case format.to_s.to_sym
        when :nquads
          RDF::NQuads::Writer
        when :turtle
          begin
            require 'rdf/turtle'
            RDF::Turtle::Writer
          rescue LoadError
            $stderr.puts """Turtle format not supported.
    Install the 'rdf-turtle' gem."""
            raise
          end
        when :ntriples
          RDF::NTriples::Writer
        end
      end
    end
  end
end
