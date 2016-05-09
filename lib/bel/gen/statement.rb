require 'bel'
require_relative '../gen'
BEL::Gen.soft_require('rantly')

module BEL
  module Gen

    # The {Statement} module defines methods that generate random BEL
    # {BEL::Nanopub::Statement statements}.
    module Statement
      include BEL::Gen::Term

      # Array of all BEL 1.0 relationships including both short and long form.
      RELATIONSHIPS = BEL::Language::RELATIONSHIPS.each.to_a.flatten.sort.uniq

      # Returns a randomly chosen relationship.
      # @return [Symbol] the relationship label (short or long form)
      def relationship
        Rantly {
          choose(*RELATIONSHIPS)
        }
      end

      # Returns a randomly constructed BEL statement.
      # @return [String] the statement label
      def bel_statement
        sub = bel_term
        obj = bel_term
        "#{sub} #{relationship} #{obj}"
      end
    end
  end
end
