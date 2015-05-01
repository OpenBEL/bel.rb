module LibBEL
  class BELSerializationTransform

    attr_reader :bel_string

    def initialize
      @bel_string = ""
    end

    def post_order(ast_node)
      if ast_node.is_a?(BelAstNodeToken)
        case ast_node.token_type
        when :BEL_TOKEN_TERM
          @bel_string.chomp!(', ')
          @bel_string.concat(')')
        when :BEL_TOKEN_NV
          @bel_string.concat(', ')
        end
      else
        value = ast_node.value
        case ast_node.value_type
        when :BEL_VALUE_FX
          @bel_string.concat(value).concat('(')
        when :BEL_VALUE_REL
          @bel_string.concat(" #{value} ")
        when :BEL_VALUE_PFX
          if value
            @bel_string.concat(value).concat(':')
          end
        when :BEL_VALUE_VAL
          @bel_string.concat(value)
        end
      end
    end
  end
end
