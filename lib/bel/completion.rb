require_relative '../lib_bel'
require_relative 'completion_rule'
require_relative 'language'
require_relative 'namespace'

module BEL
  module Completion

    SORTED_FUNCTIONS  = BEL::Language::FUNCTIONS.keys.sort.map(&:to_s)
    SORTED_NAMESPACES = BEL::Namespace::NAMESPACE_LATEST.keys.sort.map(&:to_s)

    def self.complete(term, position)
      term = (term || '').to_s
      if not position or position.class != Fixnum
        position = term.length
      end

      token_list = LibBEL::tokenize_term(term)
      active_tok, active_index = token_list.token_at(position)

      tokens = token_list.to_a
      BEL::Completion::rules.reduce([]) { |completions, rule|
        completions.concat(rule.apply(tokens, active_tok, active_index))
      }
    end
  end
end

