require 'forwardable'

module BEL
  module Nanopub
    class Support
      extend Forwardable

      attr_accessor :value

      def initialize(value = nil)
        @value = value
      end

      def ==(other)
        return false if other.nil?
        @value == other.value
      end
      alias eql? ==

      def_delegators :@value, :to_s
    end
  end
end
