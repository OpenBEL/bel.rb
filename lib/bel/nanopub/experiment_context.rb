require 'forwardable'

module BEL
  module Nanopub
    class ExperimentContext

      attr_accessor :values

      extend Forwardable
      include Enumerable

      def initialize(values = [])
        @values = values.map { |item|
          name  = item[:name]  || item['name']
          value = item[:value] || item['value']
          {
            :name  => name.to_sym,
            :value => value
          }
        }
        @values.sort_by! { |item| item[:name] }
      end

      def ==(other)
        return false if other.nil?
        @values == other.values
      end
      alias eql? ==

      def_delegators :@values, :<<,    :[],    :"[]=",
                               :each,  :size,  :sort
    end
  end
end
