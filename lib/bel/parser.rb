require_relative 'libbel'

module BEL
  module Parser

    # Parses BEL expressions to a {BelAst}.
    #
    # If +bel_expression+ is +nil+ then +nil+ is returned.
    #
    # @param bel_expression [responds to #to_s] the bel expression to parse
    # @return [BelAst]
    def self.parse(bel_expression, options = {})
      if !bel_expression
        return nil
      end

      LibBEL.parse_term(
        ensure_newline(bel_expression.to_s)
      )
    end

    private

    # Ensures a newline (e.g. +\n+) is the last character in +string+.
    #
    # +Pure function+ but returns the +string+ reference if it already ends
    # with a newline.
    #
    # @param string [String] the string which must have a newline
    # @return [String]
    def self.ensure_newline(string)
      if string[-1] != "\n"
        string + "\n"
      else
        string
      end
    end
  end
end
