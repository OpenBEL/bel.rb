module BEL
  module Model

    module ParameterValidation

      def valid?
        return false unless value
        return true unless @ns
        @ns.respond_to?(:values) && ns.values.include?(value.to_sym)
      end
    end

    class Parameter
      include BEL::Quoting
      include Comparable
      include ParameterValidation
      attr_accessor :ns, :value, :enc

      def initialize(ns, value, enc=nil)
        @ns = ns
        @value = value
        @enc = enc || ''
      end

      def <=>(other)
        ns_compare = @ns <=> other.ns
        if ns_compare == 0
          @value <=> other.value
        else
          ns_compare
        end
      end

      def hash
        [@ns, @value].hash
      end

      def ==(other)
        return false if other == nil
        @ns == other.ns && @value == other.value
      end
      alias_method :eql?, :'=='

      def to_bel
        if @ns
          prefix = @ns.respond_to?(:prefix) ? @ns.prefix : @ns[:prefix]
          prefix = prefix ? (prefix.to_s + ':') : ''
        else
          prefix = ''
        end
        %Q{#{prefix}#{ensure_quotes(@value)}}
      end
      alias_method :to_s, :to_bel
    end
  end
end
