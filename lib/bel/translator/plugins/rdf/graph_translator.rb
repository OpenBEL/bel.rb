require 'rdf'

require_relative 'uuid'
require_relative 'bel_schema'
require_relative 'monkey_patch'
require_relative 'reader'

module BELRDF

  class GraphTranslator

    include ::BEL::Translator

    def initialize(format, write_schema = true)
      @format     = format

      write_schema = true if write_schema.nil?
      @rdf_schema =
        if write_schema
          BELRDF::RDFS_SCHEMA
        else
          []
        end
    end

    def read(data, options = {})
      Reader::BufferedNanopubYielder.new(data, @format)
    end

    def write(objects, io = StringIO.new, options = {})
      write_rdf_to_io(@format, objects, io, options)

      case io
      when StringIO
        io.string
      else
        io
      end
    end

    private

    def write_rdf_to_io(format, objects, io, options = {})
      void_dataset_uri =
        if options[:void_dataset_uri]
          void_dataset_uri = options.delete(:void_dataset_uri)
          void_dataset_uri = RDF::URI(void_dataset_uri)
          unless void_dataset_uri.valid?
            raise ArgumentError.new 'void_dataset_uri is not a valid URI'
          end
          void_dataset_uri
        else
          nil
        end

      wrote_dataset = false

      rdf_statement_enum = Enumerator.new do |yielder|
        # enumerate BEL schema
        @rdf_schema.each do |schema_statement|
          yielder << RDF::Statement.new(*schema_statement)
        end

        # enumerate BEL nanopubs
        objects.each do |nanopub|
          if void_dataset_uri && !wrote_dataset
            void_dataset_triples = nanopub.to_void_dataset(void_dataset_uri)
            if void_dataset_triples && void_dataset_triples.respond_to?(:each)
              void_dataset_triples.each do |void_triple|
                yielder << void_triple
              end
            end
            wrote_dataset = true
          end

          nanopub_uri, statements = nanopub.to_rdf
          statements.each do |statement|
            yielder << statement
          end

          if void_dataset_uri
            yielder << RDF::Statement.new(
              void_dataset_uri,
              RDF::DC.hasPart,
              nanopub_uri
            )
          end
        end
      end

      graph = RDF::Graph.new(void_dataset_uri)
      rdf_statement_enum.each do |rdf_statement|
        graph << rdf_statement
      end
      io.set_encoding(Encoding::UTF_8.to_s) if io.respond_to?(:set_encoding)

      RDF::Writer.for(@format.to_s.to_sym).new(io) { |writer|
        writer << graph
      }

      io
    end
  end
end
