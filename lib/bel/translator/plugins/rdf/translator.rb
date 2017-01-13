require 'rdf'
require 'pathname'
require 'yaml'

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
      Reader::UnbufferedNanopubYielder.new(data, @format)
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

      # read remap file
      if options[:remap_file]
        remap = YAML::load_file(options[:remap_file])
      end

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

          nanopub_uri, statements = nanopub.to_rdf(remap)
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

      io.set_encoding(Encoding::UTF_8.to_s) if io.respond_to?(:set_encoding)
      rdf_writer = RDF::Writer.for(@format.to_s.to_sym).new(
        io,
        :stream => true
      )

      # load RDF prefixes
      prefixes = load_prefixes(options)
      prefixes.each do |prefix, uri|
        rdf_writer.prefix prefix.to_sym, RDF::URI(uri)
      end

      rdf_writer.write_prologue
      rdf_statement_enum.each do |statement|
        rdf_writer << statement
      end
      rdf_writer.write_epilogue
      rdf_writer.flush

      io
    end

    def load_prefixes(options)
      prefix_file = options[:rdf_prefix_file] || default_prefix_file
      YAML::load_file(prefix_file)
    end

    def default_prefix_file
      File.join(
        File.expand_path(File.dirname(__FILE__)),
        'config',
        'default_prefixes.yml'
      )
    end
  end
end
