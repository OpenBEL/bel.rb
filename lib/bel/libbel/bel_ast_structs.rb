require_relative 'node_traversal'
require_relative 'node_transformation'

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
    include NodeTransformation

    layout(
      :type_info, BelAstNodeTypeInfo.ptr,
      :token,     :pointer,
      :value,     :pointer
    )

    def type_info
      self[:type_info]
    end

    def type_info=(type_info)
      self[:type_info] = type_info
    end

    def token
      self[:token]
    end

    def token=(token)
      self[:token] = token
    end

    def value
      self[:value]
    end

    def value=(value)
      self[:value] = value
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

    def left=(left)
      self[:left] = left
    end

    def right
      self[:right]
    end

    def right=(right)
      self[:right] = right
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
    include NodeTraversal
    include NodeTransformation

    layout(
      :root,      BelAstNode.ptr
    )

    def root
      self[:root]
    end

    def root=(root)
      self[:root] = root
    end

    # overrides {NodeTraversal#each_depth_first}
    def each_depth_first(&block)
      if block_given?
        root.each_depth_first(&block)
      else
        root.enum_for(:each_depth_first)
      end
    end

    # overrides {NodeTraversal#each_breadth_first}
    def each_breadth_first(queue = [], &block)
      if block_given?
        root.each_breadth_first(&block)
      else
        root.enum_for(:each_breadth_first)
      end
    end

    def transform(transforms, options = {})
      transform_tree(transforms, :depth_first, options)
    end

    def transform_tree(transforms, traversal = :depth_first, options = {})
      copy_ast = LibBEL::copy_ast(self)
      options = {
        :mutate => true
      }.merge(options)

      copy_ast.root.transform_tree(transforms, traversal, options)
      copy_ast
    end

    def self.release(ptr)
      if !ptr.null?
        LibBEL::bel_free_ast(ptr)
      end
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
