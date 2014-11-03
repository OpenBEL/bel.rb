require_relative '../lib_bel'
require_relative 'language'
require_relative 'namespace'

module BEL
  module Completion

    SORTED_FUNCTIONS  = BEL::Language::FUNCTIONS.keys.sort.map(&:to_s)
    SORTED_NAMESPACES = BEL::Namespace::NAMESPACE_LATEST.keys.sort.map(&:to_s)

    def self.complete(term)
      term_str = term.to_s
      tokens = LibBEL::tokenize_term(term_str).to_a
      token_size = tokens.size

      if tokens.empty?
        [Option.new(0, '', :function, SORTED_FUNCTIONS)]
      else
        unbalanced_parens = tokens.count { |tk| tk.type == :O_PAREN } - tokens.count { |tk| tk.type == :C_PAREN }
        last_token = tokens.last
        case last_token.type
        when :IDENT
          # match ident
          previous_token = token_size > 1 ? tokens[token_size - 2] : nil
          ident_result   = complete_ident(last_token, previous_token)
          first_match    = ident_result.find_all { |r| r.is_a?(Match) }.first
          if first_match
            case first_match.value_type
            when :function
              [
                ident_result,
                Insert.new(last_token.pos_end, :o_paren   , ['('])
              ].flatten
            when :namespace_prefix
              [
                ident_result,
                Insert.new(last_token.pos_end, :colon     , [':'])
              ].flatten
            when :namespace_value
              [
                Option.new(last_token.pos_end, last_token.value, :delimiter, [')', ','])
              ]
            end
          else
            [ident_result].flatten
          end
        when :O_PAREN, :COMMA
          # TODO Function signature will inform this completion tremendously
          [
            Option.new(last_token.pos_end, last_token.value, :namespace_prefix,   SORTED_NAMESPACES),
            Option.new(last_token.pos_end, last_token.value, :function,           SORTED_FUNCTIONS)
          ]
        when :C_PAREN
          if unbalanced_parens > 0
            [Insert.new(last_token.pos_end, :comma, [','])]
          else
            [Terminal.new(last_token.pos_start, last_token.value, :c_paren)]
          end
        when :STRING
          results = []
          if unbalanced_parens > 0
            results << Insert.new(last_token.pos_end, :c_paren , [')'])
          end
          results << Insert.new(last_token.pos_end, :comma   , [','])
          results
        when :COLON
          [Insert.new(last_token.pos_end, :value   , [''])]
        when :SPACES
          [Replace.new(last_token.pos_start, last_token.value, :spaces, [''])]
        end
      end
    end

    def self.inspect(term)
      term_str = term.to_s
      tokens = LibBEL::tokenize_term(term_str).to_a
      result = []

      if tokens.empty?
        result << Insert.new(0, :function, SORTED_FUNCTIONS)
      end

      index = 0; size = tokens.size
      while index < size do
        tk = tokens[index]

        # match function
        if index == 0
          self.handle_function(tokens, index, size, tk, result)
        end

        if tk.type == :O_PAREN

          result << Insert.new(tk.pos_end, :function, SORTED_FUNCTIONS)
          result << Insert.new(tk.pos_end, :prefix  , SORTED_NAMESPACES)
        end

        index += 1
      end

      result.compact!
      result
    end

    Insert  =  Struct.new(:position, :value_type, :values)

    Replace =  Struct.new(:position, :match, :value_type, :values)

    Error   =  Struct.new(:position, :match, :value_type, :error, :values)

    NoMatch =  Struct.new(:position, :value, :value_type)

    Match   =  Struct.new(:position, :value, :value_type)

    Option  =  Struct.new(:position, :value, :value_type, :options)

    Terminal = Struct.new(:position, :value, :value_type)

    private

    def self.handle_function(tokens, index, size, tk, result)
      if tk.type == :IDENT
        functions = self.match_bel_function(tk.value)
        if functions.empty?
          result << Error.new(
            tk.pos_start, tk.value, :IDENT, %Q{"#{tk.value}" is not a BEL function},
            SORTED_FUNCTIONS
          )
        else
          fx_strings = functions.map(&:to_s)
          if fx_strings.include?(tk.value)
            fx_strings.delete(tk.value)

            next_index = index + 1
            if next_index >= size || tokens[next_index].type != :O_PAREN
              result << Insert.new(tk.pos_end, :O_PAREN, ['('])
            end
          end
          if not fx_strings.empty?
            result << Replace.new(tk.pos_start, tk.value, :IDENT, fx_strings)
          end
        end
      else
        # error - not a function
        result << Error.new(
          tk.pos_start, tk.value, :IDENT, %Q{"#{tk.value}" is not a BEL function},
          SORTED_FUNCTIONS
        )
      end
    end

    def self.complete_ident(tk, previous_tk)
      if not previous_tk
        [self.complete_function(tk)]
      else
        case previous_tk.type
        when :COLON
          [self.complete_namespace_value(tk)]
        else
          [
            self.complete_namespace_prefix(tk),
            self.complete_function(tk)
          ]
        end
      end
    end

    def self.complete_function(tk)
      self.complete_from_catalog(tk, :function, SORTED_FUNCTIONS)
    end

    def self.complete_namespace_prefix(tk)
      self.complete_from_catalog(tk, :namespace_prefix, SORTED_NAMESPACES)
    end

    def self.complete_namespace_value(tk)
      nil
    end

    def self.complete_from_catalog(tk, type, catalog)
      str = tk.value.downcase
      matches = catalog.find_all { |v| v.to_s.downcase.include? str }
      if matches.empty?
        NoMatch.new(tk.pos_start, tk.value, type)
      else
        if matches.include?(tk.value)
          Match.new(tk.pos_start, tk.value, type)
        else
          Option.new(tk.pos_start, tk.value, type, matches)
        end
      end
    end

    def self.match_bel_function(str)
      str = str.downcase
      BEL::Language::FUNCTIONS.keys.find_all { |k| k.to_s.downcase.include? str }
    end
  end
end

