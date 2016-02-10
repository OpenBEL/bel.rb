require 'rdf'

require_relative 'uuid'
require_relative 'bel_schema'
require_relative 'monkey_patch'
require_relative 'reader'

module BELRDF

  class Translator

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
      Reader::UnbufferedEvidenceYielder.new(data, @format)
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
      if options[:void_dataset_uri]
        void_dataset_uri = options.delete(:void_dataset_uri)
        void_dataset_uri = RDF::URI(void_dataset_uri)
        unless void_dataset_uri.valid?
          raise ArgumentError.new 'void_dataset_uri is not a valid URI'
        end
      else
        void_dataset_uri = nil
      end

      wrote_dataset = false

      rdf_statement_enum = Enumerator.new do |yielder|
        # enumerate BEL schema
        @rdf_schema.each do |schema_statement|
          yielder << RDF::Statement.new(*schema_statement)
        end

        # enumerate BEL evidence
        objects.each do |evidence|
          if void_dataset_uri && !wrote_dataset
            void_dataset_triples = evidence.to_void_dataset(@void_dataset_uri)
            if void_dataset_triples && void_dataset_triples.respond_to?(:each)
              void_dataset_triples.each do |void_triple|
                yielder << void_triple
              end
            end
            wrote_dataset = true
          end

          evidence_uri, statements = evidence.to_rdf
          statements.each do |statement|
            yielder << statement
          end

          if @void_dataset_uri
            yielder << RDF::Statement.new(@void_dataset_uri, RDF::DC.hasPart, evidence_uri)
          end
        end
      end

      io.set_encoding(Encoding::UTF_8.to_s) if io.respond_to?(:set_encoding)
      rdf_writer = RDF::Writer.for(@format.to_s.to_sym).new(
        io,
        :stream => true
      )

      rdf_writer.write_prologue
      rdf_statement_enum.each do |statement|
        rdf_writer << statement
      end
      rdf_writer.write_epilogue
      rdf_writer.flush

      io
    end
  end
end
