require_relative 'libbel'

module BEL
  module Parser

    # Parses BEL expressions to a {BelAST}.
    #
    # If +bel_expression+ is +nil+ then +nil+ is returned.
    #
    # @param bel_expression   [responds to #to_s] the bel expression parse
    # @param                  [Hash]              options
    # @option options         [responds to #each] :statement_transforms
    #   - statement transform items must respond to #call
    # @option options         [responds to #each] :term_transforms
    #   - term transform items must respond to #call
    # @return [BelAST]
    def self.parse(bel_expression, options = {})
      bel_ast = LibBEL.parse_statement(bel_expression)
      bel_ast.root
    end
  end
end
