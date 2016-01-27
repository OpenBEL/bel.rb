require_relative 'uuid'

module BEL::Translator::Plugins

  module Rdf::Writer

    class RDFYielder
      attr_reader :writer

      Rdf = ::BEL::Translator::Plugins::Rdf

      def initialize(io, format, options = {})
        rdf_writer = find_writer(format)
        @writer    = rdf_writer.new(io, { :stream => true })

        if options[:void_dataset_uri]
          void_dataset_uri = options.delete(:void_dataset_uri)
          void_dataset_uri = RDF::URI(void_dataset_uri)
          unless void_dataset_uri.valid?
            raise ArgumentError.new 'void_dataset_uri is not a valid URI'
          end
          @void_dataset_uri = void_dataset_uri
        else
          @void_dataset_uri = nil
        end
        @wrote_dataset    = false
      end

      def <<(evidence)
        if !@wrote_dataset && @void_dataset_uri
          void_dataset_triples = evidence.to_void_dataset(@void_dataset_uri)
          if void_dataset_triples && void_dataset_triples.respond_to?(:each)
            void_dataset_triples.each do |void_triple|
              @writer.write_statement(void_triple)
            end
          end
        end
        evidence_uri, statements = evidence.to_rdf
        statements.each do |statement|
          @writer.write_statement(statement)
        end

        if @void_dataset_uri
          @writer.write_statement(RDF::Statement.new(@void_dataset_uri, RDF::DC.hasPart, evidence_uri))
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
            $stderr.puts 'Turtle format is not supported. Install the "rdf-turtle" gem.'
            raise
          end
        when :ntriples
          RDF::NTriples::Writer
        when :rdfxml
          begin
            require 'rdf/rdfxml'
            RDF::RDFXML::Writer
          rescue LoadError
            $stderr.puts 'RDF/XML format is not supported. Install the "rdf-rdfxml" gem.'
            raise
          end
        end
      end
    end
  end
end
