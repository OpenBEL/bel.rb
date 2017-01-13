require 'bel'
require_relative '../gen'
BEL::Gen.soft_require('rantly')

module BEL
  module Gen

    # The {Parameter} module defines methods that generate random BEL
    # {BEL::Nanopub::Parameter parameters}.
    module Parameter
      include BEL::Gen::Namespace

      # Returns a BEL parameter from a random namespace. The value will be
      # a random string and not necessarily part of the namespace.
      #
      # @return [BEL::Nanopub::Parameter] a randomly generated parameter with
      #         a namespace
      def bel_parameter_with_namespace
        ns    = namespace
        value = Rantly.value {
          sized(range(3,10)) {
            string(/[[:alnum:]]|[[:blank:]]|[[:punct:]]/)
          }
        }
        BEL::Nanopub::Parameter.new(
          ns,
          value,
          :A
        )
      end

      # Returns a BEL parameter without a namespace. The value will be
      # a random string.
      #
      # @return [BEL::Nanopub::Parameter] a randomly generated parameter
      #         without a namespace
      def bel_parameter_without_namespace
        value = Rantly.value {
          sized(range(3,10)) {
            string(/[[:alnum:]]|[[:blank:]]|[[:punct:]]/)
          }
        }
        BEL::Nanopub::Parameter.new(
          nil,
          value,
          :A
        )
      end

      # Returns a BEL parameter that may or may not have a namespace.
      #
      # Note: This method has a better chance of selecting a BEL parameter
      # with a namespace.
      #
      # @see #bel_parameter_with_namespace
      # @see #bel_parameter_without_namespace
      # @return [BEL::Nanopub::Parameter] a parameter that may or may not have
      #         a namespace
      def bel_parameter
        with_namespace    = bel_parameter_with_namespace
        without_namespace = bel_parameter_without_namespace
        Rantly {
          freq(
            [5, :literal, with_namespace],
            [1, :literal, without_namespace],
          )
        }
      end
    end
  end
end
