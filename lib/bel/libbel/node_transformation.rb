module LibBEL
  module NodeTransformation

    def transform(transforms, options = {})
      if options[:mutate] == true
        ast_node = self
      else
        ast_node = LibBEL::copy_ast_node(self)
      end

      transforms.each do |transform|
        transform.call(ast_node)
      end
      ast_node
    end

    def transform_tree(transforms, traversal = :depth_first, options = {})
      if options[:mutate] == true
        ast_node = self
      else
        ast_node = LibBEL::copy_ast_node(self)
      end

      transforms.each do |transform|
        NodeTransformation.traversal_method(ast_node, traversal).call(transform)
      end

      # NodeTransformation.traversal_method(ast_node, traversal).call do |bel_ast_node|
      #   transforms.each do |transform|
      #     transform.call(bel_ast_node)
      #   end
      # end
      ast_node
    end

    private

    def self.traversal_method(obj, traversal)
      if traversal == :breadth_first
        obj.method(:each_breadth_first)
      else
        obj.method(:each_depth_first)
      end
    end
  end
end
