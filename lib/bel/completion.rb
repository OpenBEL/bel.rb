require_relative '../lib_bel'
require_relative 'completion_rule'
require_relative 'language'
require_relative 'namespace'

module BEL
  module Completion

    def self.complete(term, position = nil)
      term = (term || '').to_s
      if not position or position.class != Fixnum
        position = term.length
      end

      token_list = LibBEL::tokenize_term(term)
      active_tok, active_index = token_list.token_at(position)

      # no active token indicates the position is out of
      # range of all tokens in the list.
      return [] unless active_tok

      tokens = token_list.to_a
      BEL::Completion::rules.reduce([]) { |completions, rule|
        completions.concat(rule.apply(tokens, active_tok, active_index))
      }
    end
  end
end

