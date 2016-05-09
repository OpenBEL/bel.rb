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
        @fx = case fx
        when String
          Function.new(FUNCTIONS[fx.to_sym])
        when Symbol
          Function.new(FUNCTIONS[fx.to_sym])
        when Function
          fx
        when nil
          raise ArgumentError, 'fx must not be nil'
        end
        @arguments = (arguments ||= []).flatten
        @signature = Signature.new(
          @fx[:short_form],
          *@arguments.map { |arg|
            case arg
            when Term
              F.new(arg.fx.return_type)
            when Parameter
              E.new(arg.enc)
            when nil
              NullE.new
            end
          })
      end

      def <<(item)
        @arguments << item
      end

      def valid?
        invalid_signatures = @arguments.find_all { |arg|
          arg.is_a? Term
        }.find_all { |term|
          not term.valid?
        }
        return false if not invalid_signatures.empty?

        sigs = @fx.signatures
        sigs.any? do |sig| (@signature <=> sig) >= 0 end
      end

      def valid_signatures
        @fx.signatures.find_all { |sig| (@signature <=> sig) >= 0 }
      end

      def invalid_signatures
        @fx.signatures.find_all { |sig| (@signature <=> sig) < 0 }
      end

      def hash
        [@fx, @arguments].hash
      end

      def ==(other)
        return false if other == nil
        @fx == other.fx && @arguments == other.arguments
      end
      alias_method :eql?, :'=='

      def to_bel
        arguments = [@arguments].flatten.map(&:to_bel).join(',') 
        "#{@fx.short_form}(#{arguments})"
      end
      alias_method :to_s, :to_bel

      def to_bel_long_form
        arguments = [@arguments].flatten.map(&:to_bel).join(',') 
        "#{@fx.long_form}(#{arguments})"
      end
    end
  end
end

