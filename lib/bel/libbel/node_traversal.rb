module LibBEL
  module NodeTraversal
    include Enumerable

    def each(traversal = :depth_first, &block)
      if block_given?
        if traversal == :depth_first
          each_depth_first(&block)
        elsif traversal == :breadth_first
          each_breadth_first(&block)
        end
      else
        if traversal == :depth_first
          enum_for(:each_depth_first)
        elsif traversal == :breadth_first
          enum_for(:each_breadth_first)
        end
      end
    end

    def each_depth_first(&block)
      if block_given?
        typed_node = self.to_typed_node
        block.call(typed_node)

        if typed_node.is_a? (LibBEL::BelAstNodeToken)
          if !typed_node.left.pointer.null?
            typed_node.left.each_depth_first(&block)
          end
          if !typed_node.right.pointer.null?
            typed_node.right.each_depth_first(&block)
          end
        end
      else
        enum_for(:each_depth_first)
      end
    end

    def each_breadth_first(queue = [], &block)
      if block_given?
        typed_node = (queue.shift || self).to_typed_node
        block.call(typed_node)

        if typed_node.is_a? (LibBEL::BelAstNodeToken)
          if !typed_node.left.pointer.null?
            queue << typed_node.left
          end
          if !typed_node.right.pointer.null?
            queue << typed_node.right
          end
        end

        if !queue.empty?
          queue.first.each_breadth_first(queue, &block)
        end
      else
        enum_for(:each_depth_first)
      end
    end
  end
end
