module LibBEL
  module NodeComposition

    def namespace_values
      self.each.select { |bel_ast_node|
        bel_ast_node.is_a?(LibBEL::BelAstNodeToken) &&
          bel_ast_node.token_type == :BEL_TOKEN_NV
      }
    end

    def arguments
      self.each.select { |bel_ast_node|
        bel_ast_node.is_a?(LibBEL::BelAstNodeToken) &&
          bel_ast_node.token_type == :BEL_TOKEN_ARG
      }
    end

    def terms
      self.each.select { |bel_ast_node|
        bel_ast_node.is_a?(LibBEL::BelAstNodeToken) &&
          bel_ast_node.token_type == :BEL_TOKEN_TERM
      }
    end

    def relationships
      self.each.select { |bel_ast_node|
        bel_ast_node.is_a?(LibBEL::BelAstNodeToken) &&
          bel_ast_node.token_type == :BEL_TOKEN_REL
      }
    end

    def statements
      self.each.select { |bel_ast_node|
        bel_ast_node.is_a?(LibBEL::BelAstNodeToken) &&
          bel_ast_node.token_type == :BEL_TOKEN_STATEMENT
      }
    end

    def statement_subjects
      self.each.select { |bel_ast_node|
        bel_ast_node.is_a?(LibBEL::BelAstNodeToken) &&
          bel_ast_node.token_type == :BEL_TOKEN_SUBJECT
      }
    end

    def statement_objects
      self.each.select { |bel_ast_node|
        bel_ast_node.is_a?(LibBEL::BelAstNodeToken) &&
          bel_ast_node.token_type == :BEL_TOKEN_OBJECT
      }
    end
  end
end
