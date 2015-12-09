require 'rdf'

require_relative 'uuid'
require_relative 'bel_schema'
require_relative 'monkey_patch'
require_relative 'reader'
require_relative 'writer'

module BEL::Translator::Plugins

  module Rdf

    class RdfTranslator

      include ::BEL::Translator

      def read(data, options = {})
        Reader::UnbufferedEvidenceYielder.new(data)
      end

      def write(objects, writer = StringIO.new, options = {})
        # format = options[:format] || :ntriples
        rdf_writer = Writer::RDFYielder.new(writer, :nquads)

        objects.each do |evidence|
          rdf_writer << evidence
        end
        rdf_writer.done
        writer
      end
    end
  end
end
