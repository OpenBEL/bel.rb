require 'bel'
require_relative '../gen'
BEL::Gen.soft_require('rantly')

module BEL
  module Gen

    # The {Term} module defines methods that generate random BEL
    # {BEL::Nanopub::Term terms}.
    module Term
      include BEL::Gen::Parameter

      # Array of all BEL 1.0 functions including both short and long form.
      FUNCTIONS     = BEL::Language::FUNCTIONS.map { |_, fx|
        [ fx[:short_form], fx[:long_form] ]
      }.flatten.sort.uniq

      # Returns a randomly chosen function.
      # @return [Symbol] the function label (short or long form)
      def function
        Rantly {
          choose(*FUNCTIONS)
        }
      end

      # Returns a randomly constructed BEL term.
      # @return [String] the term label
      def bel_term
        "#{function}(#{bel_parameter})"
      end
    end
  end
end
