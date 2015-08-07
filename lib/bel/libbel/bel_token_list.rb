module BEL
  module LibBEL

    class BelTokenList < FFI::ManagedStruct
      include Enumerable

      layout :length,    :int,
             :tokens,    BelToken.ptr

      def each
        if block_given?
          iterator = LibBEL::bel_new_token_iterator(self.pointer)
          while LibBEL::bel_token_iterator_end(iterator).zero?
            current_token = LibBEL::bel_token_iterator_get(iterator)
            yield LibBEL::BelToken.new(current_token)
            LibBEL::bel_token_iterator_next(iterator)
          end
          LibBEL::free_bel_token_iterator(iterator)
        else
          enum_for(:each)
        end
      end

      def token_at(position)
        self.each_with_index { |tk, index|
          if (tk.pos_start..tk.pos_end).include? position
            return [tk, index]
          end
        }
        nil
      end

      def self.release(ptr)
        LibBEL::free_bel_token_list(ptr)
      end
    end
  end
end
