module BEL::Translator::Plugins

  module Rdf::Writer

    class RDFYielder
      attr_reader :writer

      def initialize(io, format)
        rdf_writer = find_writer(format)
        @writer = rdf_writer.new(io, { :stream => true })
      end

      def <<(evidence)
        triples = evidence.bel_statement.to_rdf[1]
        triples.each do |triple|
          @writer.write_statement(::RDF::Statement(*triple))
        end
      end

      def done
        @writer.write_epilogue
      end

      private

      def find_writer(format)
        case format.to_s.to_sym
        when :nquads
          BEL::RDF::RDF::NQuads::Writer
        when :turtle
          begin
            require 'rdf/turtle'
            BEL::RDF::RDF::Turtle::Writer
          rescue LoadError
            $stderr.puts """Turtle format not supported.
    Install the 'rdf-turtle' gem."""
            raise
          end
        when :ntriples
          BEL::RDF::RDF::NTriples::Writer
        end
      end
    end
  end
end
