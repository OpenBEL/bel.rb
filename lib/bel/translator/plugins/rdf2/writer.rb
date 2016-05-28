require_relative 'statement_converter'
require_relative 'nanopub_converter'

module BEL
  module BELRDF
    module Writer
      class RDFWriter
        attr_reader :writer

        def initialize(io, format, options = {})
          rdf_writer = RDF::Writer.for(format)
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

          @writer.write_prologue
          @wrote_dataset = false
          @nanopub_converter = NanopubConverter.new(StatementConverter.new))
        end

        def <<(nanopub)
          if !@wrote_dataset && @void_dataset_uri
            # TODO Write VoID dataset for document.
          end

          @writer << @nanopub_converter.nanopub(nanopub)

          # @nanopub_converter.nanopub(nanopub).each do |statement|
          #   @writer.write_statement(statement)
          # end

          if @void_dataset_uri
            # TODO Include this nanopub in the VoID dataset.
            # @writer.write_statement(RDF::Statement.new(@void_dataset_uri, RDF::DC.hasPart, nanopub_uri))
          end
        end

        def done
          @writer.write_epilogue
        end
      end
    end
  end
end
