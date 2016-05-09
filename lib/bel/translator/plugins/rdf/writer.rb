require_relative 'uuid'

module BELRDF
  module Writer

    class RDFYielder
      attr_reader :writer

      Rdf = ::BEL::Translator::Plugins::Rdf

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
        @wrote_dataset    = false
      end

      def <<(nanopub)
        if !@wrote_dataset && @void_dataset_uri
          void_dataset_triples = nanopub.to_void_dataset(@void_dataset_uri)
          if void_dataset_triples && void_dataset_triples.respond_to?(:each)
            void_dataset_triples.each do |void_triple|
              @writer.write_statement(void_triple)
            end
          end
        end
        nanopub_uri, statements = nanopub.to_rdf
        statements.each do |statement|
          @writer.write_statement(statement)
        end

        if @void_dataset_uri
          @writer.write_statement(RDF::Statement.new(@void_dataset_uri, RDF::DC.hasPart, nanopub_uri))
        end
      end

      def done
        @writer.write_epilogue
      end
    end
  end
end
