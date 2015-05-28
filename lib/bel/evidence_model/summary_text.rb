require 'forwardable'

module BEL
  module Model
    class SummaryText
      extend Forwardable

      attr_accessor :value

      def initialize(value = nil)
        @value = value
      end

      def_delegators :@value, :to_s
    end
  end
end
