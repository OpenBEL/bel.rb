module LibBEL
  module NodeTransformation

    def transform(transforms, options = {})
      ast_node = LibBEL::copy_ast_node(self)

      transforms.each do |transform|
        transform.call(ast_node)
      end
      ast_node
    end

    def transform!(transforms)
      transforms.each do |transform|
        transform.call(self)
      end
      self
    end

    def transform_tree(transforms, traversal = :depth_first, options = {})
      ast_node = LibBEL::copy_ast_node(self)

      transforms.each do |transform|
        self.traversal_method(ast_node, traversal).call(transform)
      end
      ast_node
    end

    def transform_tree!(transforms, traversal = :depth_first)
      transforms.each do |transform|
        self.traversal_method(self, traversal).call(transform)
      end
      self
    end
  end
end
