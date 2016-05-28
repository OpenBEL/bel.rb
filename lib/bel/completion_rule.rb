require_relative 'namespace'
require_relative 'quoting'

module BEL
  module Completion
    SORTED_NAMESPACES = BEL::Namespace::NAMESPACE_LATEST.keys.sort.map(&:to_s)
    EMPTY_MATCH       = []

    # Run all defined {Rule rules}.
    def self.run_rules(tokens, active_index, active_token, options = {})
      self.rules.reduce([]) { |completion_results, rule|
        completion_results.concat(
          rule.apply(tokens, active_token, active_index, options)
        )
        completion_results
      }
    end

    # Retrieve all completion {Rule rules}.
    def self.rules
      constants.map do |const|
        obj = const_get(const)
        obj.new if obj.include?(Rule)
      end.compact
    end

    # Rule defines the {#apply} API contract and additional helpers to convey
    # completion actions.
    module Rule

      def apply(token_list, active_token, active_token_index, options = {})
        matches = _apply(token_list, active_token, active_token_index, options)

        matches.map { |match|
          match = map_highlight(match, active_token)
          match = map_actions(match, active_token)
          match.delete(:offset)
          match
        }
      end

      protected

      def _apply(token_list, active_token, active_token_index, options = {})
        raise NotImplementedError
      end

      def map_highlight(match, active_token)
        if active_token and not [:O_PAREN, :COMMA].include?(active_token.type)
          value_start = match[:value].downcase.index(active_token.value.downcase)
          if value_start
            value_end = value_start + active_token.value.length
            highlight = {
              :start_position => value_start,
              :end_position   => value_end,
              :range_type     => :inclusive
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
              :range_type     => :inclusive
            }
          })
        end

        # add the active_token length if we do not need to delete it
        if active_token and actions.empty?
          position_start += active_token.value.length
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

    # MatchFunctionRule defines a function completion rule. This rule relies on
    # a {BELParser::Language::Specification} for the available functions.
    class MatchFunctionRule
      include Rule

      def _apply(token_list, active_token, active_token_index, options = {})
        if token_list.empty? or active_token.type == :O_PAREN
          return spec_functions(options[:specification]).map(&method(:map_function))
        end

        if active_token.type == :IDENT
          value   = active_token.value.downcase
          matches = spec_functions(options[:specification]).select do |func|
            func.short.to_s.include?(value) || func.long.to_s.include?(value)
          end
          return matches.map(&method(:map_function))
        end

        return EMPTY_MATCH
      end

      protected

      def spec_functions(spec)
        spec.functions.sort_by(&:long)
      end

      def map_function(function)
        if function
          {
            :id     => function.short,
            :type   => :function,
            :label  => function.long,
            :value  => "#{function.short}()",
            :offset => -1
          }
        else
          nil
        end
      end
    end

    # MatchNamespacePrefixRule defines a namespace completion rule.
    # TODO Namespces should be passed as state, not hardcoded.
    class MatchNamespacePrefixRule
      include Rule

      def _apply(token_list, active_token, active_token_index, options = {})
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
          :id     => ns_prefix,
          :type   => :namespace_prefix,
          :label  => ns_prefix,
          :value  => "#{ns_prefix}:",
          :offset => 0
        }
      end
    end

    # MatchNamespaceValueRule defines a namespace value completion rule.
    class MatchNamespaceValueRule
      include Rule
      include BEL::Quoting

      def _apply(token_list, active_token, active_token_index, options = {})
        search     = options.delete(:search)
        namespaces = options.delete(:namespaces)
        return EMPTY_MATCH if !search || !namespaces || token_list.empty?

        if active_token.type == :IDENT && active_token.value.length > 1
          previous_token = token_list[active_token_index - 1]
          if previous_token and previous_token.type == :COLON
            # search within a namespace
            prefix_token = token_list[active_token_index - 2]
            if prefix_token and prefix_token.type == :IDENT
              namespace = namespaces.find(prefix_token.value.downcase).first
              if namespace
                return search.search(
                  "#{active_token.value}*",
                  :namespace_concept,
                  namespace.uri.to_s,
                  nil,
                  :start => 0,
                  :size  => 10,
                  :exclude_identifier_schemes => false
                ).
                  map { |search_result|
                    map_namespace_value(search_result.pref_label)
                  }.to_a
              end
            end
          else
            return search.search(
              "#{active_token.value}*",
              :namespace_concept,
              nil,
              nil,
              :start => 0,
              :size  => 10,
              :exclude_identifier_schemes => true
            ).
              map { |search_result|
                ns = namespaces.find(search_result.scheme_uri).first
                map_namespace_value_with_prefix(ns, search_result.pref_label)
              }.to_a
          end
        end

        return EMPTY_MATCH
      end

      protected

      def map_namespace_value(ns_value)
        {
          :id     => ns_value,
          :type   => :namespace_value,
          :label  => ns_value,
          :value  => quote_if_needed(ns_value),
          :offset => 0
        }
      end

      def map_namespace_value_with_prefix(ns, ns_value)
        quoted_value = quote_if_needed(ns_value)

        if ns
          ns_prefix    = ns.prefix.to_s.upcase
          ns_value     = "#{ns_prefix}:#{ns_value}"
          quoted_value = "#{ns_prefix}:#{quoted_value}"
        end

        {
          :id     => ns_value,
          :type   => :namespace_value,
          :label  => ns_value,
          :value  => quoted_value,
          :offset => 0
        }
      end
    end
  end
end
