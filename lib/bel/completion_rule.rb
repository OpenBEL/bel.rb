require_relative 'language'
require_relative 'namespace'
require_relative 'quoting'

module BEL
  module Completion

    SORTED_FUNCTIONS  = BEL::Language::FUNCTIONS.keys.sort.map(&:to_s)
    SORTED_NAMESPACES = BEL::Namespace::NAMESPACE_LATEST.keys.sort.map(&:to_s)
    EMPTY_MATCH       = []

    def self.rules
      [
        MatchFunctionRule.new,
        MatchNamespacePrefixRule.new,
        MatchNamespaceValueRule.new
      ]
    end

    module Rule

      def apply(token_list, active_token, active_token_index)
        matches = _apply(token_list, active_token, active_token_index)

        matches.map { |match|
          match = map_highlight(match, active_token)
          match = map_actions(match, active_token)
          match.delete(:offset)
          match
        }
      end

      protected

      def _apply(token_list, active_token, active_token_index)
        raise NotImplementedError
      end

      def map_highlight(match, active_token)
        if active_token and not [:O_PAREN, :COMMA].include?(active_token.type)
          value_start = match[:value].downcase.index(active_token.value.downcase)
          if value_start
            value_end = value_start + active_token.value.length
            highlight = {
              :position_start => value_start,
              :position_end   => value_end
            }
          else
            highlight = nil
          end
        else
          highlight = nil
        end
        match.merge!({:highlight => highlight})
      end

      def map_actions(match, active_token)
        position_start = active_token ? active_token.pos_start : 0
        actions = []

        if active_token and not [:O_PAREN, :COLON].include?(active_token.type)
          # delete from start of active token to end of a
          actions.push({
            :delete => {
              :start_position => position_start,
              :end_position   => active_token.pos_end - 1,
              :range_type     => 'inclusive'
            }
          })
        end

        actions.concat([
          {
            :insert => {
              :position => position_start,
              :value    => match[:value]
            }
          },
          {
            :move_cursor => {
              :position => position_start + match[:value].length + match[:offset]
            }
          }
        ])
        match.merge!({:actions => actions})
      end
    end

    class MatchFunctionRule
      include Rule

      def _apply(token_list, active_token, active_token_index)
        if token_list.empty? or active_token.type == :O_PAREN
          return SORTED_FUNCTIONS.map { |fx| map_function(fx) }.uniq.sort_by { |fx|
            fx[:label]
          }
        end

        if active_token.type == :IDENT
          value = active_token.value.downcase
          return SORTED_FUNCTIONS.find_all { |x|
            x.downcase.include? value
          }.map { |fx| map_function(fx) }.uniq.sort_by { |fx| fx[:label] }
        end

        return EMPTY_MATCH
      end

      protected

      def map_function(fx_name)
        fx = Function.new(FUNCTIONS[fx_name.to_sym])
        if fx
          {
            :type   => 'function',
            :label  => fx.long_form,
            :value  => "#{fx.short_form}()",
            :offset => -1
          }
        else
          nil
        end
      end
    end

    class MatchNamespacePrefixRule
      include Rule

      def _apply(token_list, active_token, active_token_index)
        if token_list.empty? or active_token.type == :O_PAREN
          return SORTED_NAMESPACES.map { |ns_prefix|
            map_namespace_prefix(ns_prefix)
          }
        end

        # first token is always function
        return [] if active_token == token_list[0]

        if active_token.type == :IDENT
          value = active_token.value.downcase
          return SORTED_NAMESPACES.find_all { |x|
            x.downcase.include? value
          }.map { |ns_prefix|
            map_namespace_prefix(ns_prefix)
          }
        end

        return EMPTY_MATCH
      end

      private

      def map_namespace_prefix(ns_prefix)
        {
          :type   => 'namespace_prefix',
          :label  => ns_prefix,
          :value  => "#{ns_prefix}:",
          :offset => 0
        }
      end
    end

    class MatchNamespaceValueRule
      include Rule
      include BEL::Quoting

      def _apply(token_list, active_token, active_token_index)
        return [] if token_list.empty?

        stub_values = [
          'AKT1', 'AKT1S1', 'AKT2', 'AKT3', 'AKT3-IT1',
          'AKTIP', 'ALAD', 'ALAS1', 'ALAS2', 'ALB'
        ]

        if active_token.type == :COLON
          return stub_values.map { |ns_value|
            map_namespace_value(ns_value)
          }
        end

        if active_token.type == :IDENT
          return stub_values.find_all { |value|
            value.include? active_token.value
          }.map { |ns_value|
            map_namespace_value(ns_value)
          }
        end

        return EMPTY_MATCH
      end

      protected

      def map_namespace_value(ns_value)
        {
          :type   => 'namespace_value',
          :label  => ns_value,
          :value  => ensure_quotes(ns_value),
          :offset => 0
        }
      end
    end
  end
end
