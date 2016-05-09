require_relative '../language'
module BEL
  module Nanopub
    class Term
      include BEL::Language
      include Comparable
      attr_accessor :fx, :arguments, :signature

      def initialize(fx, *arguments)
        @fx = fx
        @arguments = (arguments ||= []).flatten
      end

      def initialize(fx, *arguments)
        @fx        = fx
        @arguments = (arguments ||= []).flatten
      end

      def <<(item)
        @arguments << item
      end

      def valid?
        # TODO Use expression validator.
      end

      def hash
        [@fx, @arguments].hash
      end

      def ==(other)
        return false if other == nil
        @fx == other.fx && @arguments == other.arguments
      end
      alias_method :eql?, :'=='

      def to_s(form = :short)
        args = [@arguments].flatten.map { |arg| arg.to_s(form) }.join(',')
        case form
        when :short
          "#{@fx.short}(#{args})"
        when :long
          "#{@fx.long}(#{args})"
        else
          nil
        end
      end
    end
  end
end

