require_relative 'node_traversal'

module LibBEL
  class AstNodeTypeUnion < FFI::Union
    layout(
      :ttype,     :bel_ast_token_type,
      :vtype,     :bel_ast_value_type
    )

    def token_type
      self[:ttype]
    end

    def value_type
      self[:vtype]
    end
  end

  class BelAstNodeTypeInfo < FFI::Struct
    layout(
      :type,      :bel_ast_node_type,
      :union,     AstNodeTypeUnion
    )

    def type
      self[:type]
    end

    def union
      self[:union]
    end
  end

  class BelAstNode < FFI::Union
    include NodeTraversal

    layout(
      :type_info, BelAstNodeTypeInfo.ptr,
      :token,     :pointer,
      :value,     :pointer
    )

    def type_info
      self[:type_info]
    end

    def token
      self[:token]
    end

    def value
      self[:value]
    end

    def to_typed_node
      LibBEL.typed_node(self)
    end
  end

  class BelAstNodeToken < FFI::Struct
    layout(
      :type,      :bel_ast_node_type,
      :ttype,     :bel_ast_token_type,
      :left,      BelAstNode.ptr,
      :right,     BelAstNode.ptr
    )

    def type
      self[:type]
    end

    def token_type
      self[:ttype]
    end

    def left
      self[:left]
    end

    def right
      self[:right]
    end
  end

  class BelAstNodeValue < FFI::Struct
    layout(
      :type,      :bel_ast_node_type,
      :vtype,     :bel_ast_value_type,
      :value,     :string
    )

    def type
      self[:type]
    end

    def value_type
      self[:vtype]
    end

    def value
      self[:value]
    end
  end

  class BelAst < FFI::ManagedStruct
    layout(
      :root,      BelAstNode.ptr
    )

    def root
      self[:root]
    end

    def self.release(ptr)
      LibBEL::bel_free_ast(ptr)
    end
  end

  private

  def self.typed_node(bel_ast_node)
    if bel_ast_node.type_info.type == :BEL_TOKEN
      BelAstNodeToken.new(bel_ast_node.token)
    else
      BelAstNodeValue.new(bel_ast_node.value)
    end
  end
end
