require 'forwardable'

module BEL
  module Model
    class ExperimentContext

      attr_reader :values

      extend Forwardable
      include Enumerable

      def initialize(values = [])
        @values = values
      end

      def_delegators :@values, :<<,    :[],    :"[]=",
                               :each,  :size,  :sort
    end
  end
end
