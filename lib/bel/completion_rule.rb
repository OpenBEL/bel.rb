require_relative 'language'
require_relative 'namespace'

module BEL
  module Completion

    SORTED_FUNCTIONS  = BEL::Language::FUNCTIONS.keys.sort.map(&:to_s)
    SORTED_NAMESPACES = BEL::Namespace::NAMESPACE_LATEST.keys.sort.map(&:to_s)

    def self.rules
      [
        MatchFunctionRule.new,
        MatchNamespaceRule.new,
        TermFunctionRule.new
      ]
    end

    module Rule

      def apply(context, token_list, active_token, active_token_index)
        raise NotImplementedError
      end
    end

    class TermFunctionRule
      include Rule

      def apply(context, token_list, active_token, active_token_index)
        return if token_list.empty?

        fx = token_list.first.value.to_sym
        if FUNCTIONS[fx]
          context[:term_function] = FUNCTIONS[fx]
        end
      end
    end

    class MatchFunctionRule
      include Rule

      def apply(context, token_list, active_token, active_token_index)
        return if token_list.empty?

        if active_token.type == :IDENT
          value = active_token.value.downcase
          matches = SORTED_FUNCTIONS.find_all { |x|
            x.downcase.include? value
          }.map { |x|
            BEL::Language::FUNCTIONS[x.to_sym]
          }.uniq

          if not matches.empty?
            context[:match_function] = matches
          end
        elsif active_token.type == :O_PAREN
          context[:match_function] = SORTED_FUNCTIONS.map { |x|
            BEL::Language::FUNCTIONS[x.to_sym]
          }
        end
      end
    end

    class MatchNamespaceRule
      include Rule

      def apply(context, token_list, active_token, active_token_index)
        return if token_list.empty?
        return if active_token == token_list[0] # first token is always function

        if active_token.type == :IDENT
          value = active_token.value.downcase
          matches = SORTED_NAMESPACES.find_all { |x|
            x.downcase.include? value
          }.uniq

          if not matches.empty?
            context[:match_namespace_prefix] = matches
          end
        elsif active_token.type == :O_PAREN
          context[:match_namespace_prefix] = SORTED_NAMESPACES
        end
      end
    end
  end
end
