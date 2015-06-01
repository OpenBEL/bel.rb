require 'forwardable'

module BEL
  module Model
    class Metadata

      attr_reader :values

      extend Forwardable
      include Enumerable

      DOCUMENT_HEADER        = :document_header
      ANNOTATION_DEFINITIONS = :annotation_definitions
      NAMESPACE_DEFINITIONS  = :namespace_definitions

      def initialize(values = {})
        @values = values
      end

      def document_header
        @values[DOCUMENT_HEADER] ||= {}
      end

      def document_header=(document_header)
        @values[DOCUMENT_HEADER] = document_header
      end

      def annotation_definitions
        @values[ANNOTATION_DEFINITIONS] ||= {}
      end

      def annotation_definitions=(annotation_definitions)
        @values[ANNOTATION_DEFINITIONS] = annotation_definitions
      end

      def namespace_definitions
        @values[NAMESPACE_DEFINITIONS] ||= {}
      end

      def namespace_definitions=(namespace_definitions)
        @values[NAMESPACE_DEFINITIONS] = namespace_definitions
      end

      def_delegators :@values, :[],    :"[]=", :each, :each_pair,
                               :fetch, :size,  :sort, :store
    end
  end
end
