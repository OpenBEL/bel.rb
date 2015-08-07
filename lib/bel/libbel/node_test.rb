module BEL
  module LibBEL
    module NodeTest

      def any?(predicates)
        predicates.each do |predicate|
          if predicate.call(self)
            return true
          end
        end
        return false
      end

      def any_in_tree?(predicates)
        predicates.each do |predicate|
          self.traversal_method(self, :depth_first).call do |ast_node|
            if predicate.call(ast_node)
              return true
            end
          end
        end
        return false
      end

      def all?(predicates)
        predicates.each do |predicate|
          if !predicate.call(self)
            return false
          end
        end
        return true
      end

      def all_in_tree?(predicates)
        predicates.each do |predicate|
          self.traversal_method(self, :depth_first).call do |ast_node|
            if !predicate.call(ast_node)
              return false
            end
          end
        end
        return true
      end
    end
  end
end
