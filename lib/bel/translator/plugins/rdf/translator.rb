# Load RDF library dependencies
begin
  require 'rdf'
  require 'addressable/uri'
  require 'uuid'
rescue LoadError => e
  # Raise LoadError if the requirements were not met.
  raise
end

require_relative 'bel_schema'
require_relative 'monkey_patch'
require_relative 'reader'
require_relative 'writer'

module BEL::Translator::Plugins

  module Rdf

    class RdfTranslator

      include ::BEL::Translator

      ID          = :rdf
      MEDIA_TYPES = %i(
        application/n-quads
        application/n-triples
        application/rdf+xml
        application/turtle
        application/x-turtle
        text/turtle
      )
      EXTENSIONS  = %i(
        nq
        nt
        rdf
        ttl
      )

      def id
        ID
      end

      def media_types
        MEDIA_TYPES
      end 

      def file_extensions
        EXTENSIONS
      end

      def read(data, options = {})
        Reader::UnbufferedEvidenceYielder.new(data)
      end

      def write(objects, writer = StringIO.new, options = {})
        format = options[:format] || :ntriples
        rdf_writer = Writer::RDFYielder.new(writer, format)

        objects.each do |evidence|
          rdf_writer << evidence
        end
        rdf_writer.done
        writer
      end
    end
  end
end
