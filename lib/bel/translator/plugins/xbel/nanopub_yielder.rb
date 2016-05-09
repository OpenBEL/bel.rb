require 'rexml/document'
require_relative 'nanopub_handler'

module BEL::Translator::Plugins

  module Xbel

    class NanopubYielder

      def initialize(io, options = {})
        @io = io
      end

      def each(&block)
        if block_given?
          handler = NanopubHandler.new(block)
          REXML::Document.parse_stream(@io, handler)
        else
          to_enum(:each)
        end
      end
    end
  end
end
