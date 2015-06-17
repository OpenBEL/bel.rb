require 'forwardable'

module BEL
  module Model
    class Metadata

      attr_reader :values

      extend Forwardable
      include Enumerable

      DOCUMENT_HEADER        = :document_header

      def initialize(values = {})
        @values = values
      end

      def document_header
        @values[DOCUMENT_HEADER] ||= {}
      end

      def document_header=(document_header)
        @values[DOCUMENT_HEADER] = document_header
      end

      def_delegators :@values, :[],    :"[]=", :delete_if, :each, :each_pair,
                               :fetch, :keys,  :size,      :sort, :store
    end
  end
end
