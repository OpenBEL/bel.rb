require 'bel'

describe LibBEL::BelAstNode do

  describe "#transform" do

    it "supports parameter replacement" do
      replacements = {
        ['EGID', '207'] => ['HGNC', 'AKT1']
      }
      bel_ast = BEL::Parser.parse('p(EGID:207, pmod(P, S, 300))')
      puts "Before: #{LibBEL::bel_ast_as_string(bel_ast)}"

      transformed_ast = bel_ast.transform_tree([
        Transforms::ParameterReplacementTransform.new(replacements)
      ])
     puts "After: #{LibBEL::bel_ast_as_string(transformed_ast)}"
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
          ast_node.left  = BelAstNode.new(
            bel_new_ast_node_value(:BEL_VALUE_PFX, new_parameter[0])
          )
          ast_node.right = BelAstNode.new(
            bel_new_ast_node_value(:BEL_VALUE_VAL, new_parameter[1])
          )
        end
      end
    end
  end
end
