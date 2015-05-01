module LibBEL
  module NodeTraversal
    include Enumerable

    def each(traversal = :depth_first, callable = nil, &block)
      func = if block_given?
               block
             else
               callable
             end
      if !func
        if traversal == :depth_first
          enum_for(:each_depth_first)
        elsif traversal == :breadth_first
          enum_for(:each_breadth_first)
        end
      else
        if traversal == :depth_first
          each_depth_first(callable, &block)
        elsif traversal == :breadth_first
          each_breadth_first(callable, &block)
        end
      end
    end

    def each_depth_first(callable = nil, &block)
      func = if block_given?
               block
             else
               callable
             end
      if !func
        enum_for(:each_depth_first)
      else
        typed_node = self.to_typed_node

        pre_method =
          (func.respond_to?(:pre_order) && :pre_order) ||
          (func.respond_to?(:call) && :call)
        if pre_method
          func.send(pre_method, typed_node)
        end

        if typed_node.is_a? (LibBEL::BelAstNodeToken)
          if !typed_node.left.pointer.null?
            typed_node.left.each_depth_first(func)
          end
          if func.respond_to?(:in_order)
            func.in_order(typed_node)
          end
          if !typed_node.right.pointer.null?
            typed_node.right.each_depth_first(func)
          end
        end

        if func.respond_to?(:post_order)
          func.post_order(typed_node)
        end
      end
    end

    def each_breadth_first(callable = nil, queue = [], &block)
      func = if block_given?
               block
             else
               callable
             end
      if !func
        enum_for(:each_breadth_first)
      else
        typed_node = (queue.shift || self).to_typed_node
        func.call(typed_node)

        if typed_node.is_a? (LibBEL::BelAstNodeToken)
          if !typed_node.left.pointer.null?
            queue << typed_node.left
          end
          if func.respond_to?(:between)
            func.between(typed_node)
          end
          if !typed_node.right.pointer.null?
            queue << typed_node.right
          end
        end

        if func.respond_to?(:after)
          func.after(typed_node)
        end

        if !queue.empty?
          queue.first.each_breadth_first(queue, &block)
        end
      end
    end

    def traversal_method(obj, traversal)
      if traversal == :breadth_first
        obj.method(:each_breadth_first)
      else
        obj.method(:each_depth_first)
      end
    end
  end
end
