require 'rexml/document'
require_relative 'evidence_handler'

module BEL::Translator::Plugins

  module Xbel

    class EvidenceYielder

      def initialize(io, options = {})
        @io = io
      end

      def each(&block)
        if block_given?
          handler = EvidenceHandler.new(block)
          REXML::Document.parse_stream(@io, handler)
        else
          to_enum(:each)
        end
      end
    end
  end
end
