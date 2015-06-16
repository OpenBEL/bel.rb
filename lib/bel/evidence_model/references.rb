require 'forwardable'

module BEL
  module Model
    class References

      attr_reader :values

      extend Forwardable
      include Enumerable

      ANNOTATION_DEFINITIONS = :annotation_definitions
      NAMESPACE_DEFINITIONS  = :namespace_definitions

      def initialize(values = {})
        @values = values
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

      def_delegators :@values, :[],    :"[]=", :delete_if,   :each, :each_pair,
                               :fetch, :keys,  :size,        :sort, :store
    end
  end
end
