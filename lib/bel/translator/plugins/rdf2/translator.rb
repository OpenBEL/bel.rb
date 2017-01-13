require 'rdf'
require 'yaml'

require_relative 'belv2_0'
require_relative 'reader'
require_relative 'rdf_writer'

module BEL
  module BELRDF
    class Translator
      include ::BEL::Translator

      def initialize(format, write_schema = true)
        @format      = format
        write_schema = true if write_schema.nil?
        @rdf_schema  =
          if write_schema
            BELV2_0
          else
            []
          end
      end

      def read(data, options = {})
        Reader::UnbufferedNanopubYielder.new(data, @format)
      end

      def write(objects, io = StringIO.new, options = {})
        rdfw = Writer::RDFWriter.new(io, @format, options)
        objects.each do |nanopub|
          rdfw << nanopub
        end

        io.is_a?(StringIO) ? io.string : io
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
end
