module BEL
  module Model
    class Parameter
      include BEL::Quoting
      include Comparable
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
    end
  end
end
