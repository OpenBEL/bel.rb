require 'bel'

describe LibBEL::BelAstNode do

  describe "#transform" do

    it "supports parameter replacement" do
      replacements = {
        ['EGID', '207'] => ['HGNC', 'AKT1']
      }
      bel_ast = BEL::Parser.parse('p(EGID:207, pmod(P, S, 300))')
      original_ast_string = LibBEL::bel_ast_as_string(bel_ast)
      expect(original_ast_string).to include('pfx(EGID)', 'val(207)')

      transformed_ast = bel_ast.transform_tree([
        Transforms::ParameterReplacementTransform.new(replacements)
      ])
      transformed_ast_string = LibBEL::bel_ast_as_string(transformed_ast)
      expect(transformed_ast_string).to include('pfx(HGNC)', 'val(AKT1)')
    end
  end
end

module Transforms
  class ParameterReplacementTransform
    include LibBEL

    def initialize(replacements)
      @replacements = replacements
    end

    def call(ast_node)
      if ast_node.is_a?(BelAstNodeToken) &&
          ast_node.token_type == :BEL_TOKEN_NV

        new_parameter = @replacements[
          [
            ast_node.left.to_typed_node.value,
            ast_node.right.to_typed_node.value
          ]
        ]
        if new_parameter
          LibBEL::bel_free_ast_node(ast_node.left.pointer)
          ast_node.left  = BelAstNode.new(
            bel_new_ast_node_value(:BEL_VALUE_PFX, new_parameter[0])
          )

          LibBEL::bel_free_ast_node(ast_node.right.pointer)
          ast_node.right = BelAstNode.new(
            bel_new_ast_node_value(:BEL_VALUE_VAL, new_parameter[1])
          )
        end
      end
    end
  end
end
