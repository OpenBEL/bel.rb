module BEL
  module Model
    class Term
      include Comparable
      attr_accessor :fx, :arguments, :signature

      def initialize(fx, *arguments)
        @fx = fx
        @arguments = (arguments ||= []).flatten
      end

      def <<(item)
        @arguments << item
      end

      def hash
        [@fx, @arguments].hash
      end

      def ==(other)
        return false if other == nil
        @fx == other.fx && @arguments == other.arguments
      end

      alias_method :eql?, :'=='
    end
  end
end
