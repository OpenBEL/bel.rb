require 'forwardable'

module BEL
  module Nanopub
    class Support
      extend Forwardable

      attr_accessor :value

      def initialize(value = nil)
        @value = value
      end

      def_delegators :@value, :to_s
    end
  end
end
