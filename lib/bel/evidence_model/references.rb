require 'forwardable'

module BEL
  module Model
    class References

      attr_reader :values

      extend Forwardable
      include Enumerable

      ANNOTATIONS = :annotations
      NAMESPACES  = :namespaces

      def initialize(values = {})
        @values = values
      end

      def annotations
        @values[ANNOTATIONS] ||= {}
      end

      def annotations=(annotations)
        @values[ANNOTATIONS] = annotations
      end

      def namespaces
        @values[NAMESPACES] ||= {}
      end

      def namespaces=(namespaces)
        @values[NAMESPACES] = namespaces
      end

      def_delegators :@values, :[],    :"[]=", :delete_if,   :each, :each_pair,
                               :fetch, :keys,  :size,        :sort, :store
    end
  end
end
