module LibBEL

  class BelTokenIterator < FFI::ManagedStruct
    include Enumerable

    layout :index,         :int,
           :list,          :pointer,
           :current_token, :pointer

    def each
      if self.null? or not LibBEL::bel_token_iterator_end(self).zero?
        fail StopIteration, "bel_token_iterator reached end"
      end

      if block_given?
        while LibBEL::bel_token_iterator_end(self.pointer).zero?
          current_token = LibBEL::bel_token_iterator_get(self.pointer)
          yield LibBEL::BelToken.new(current_token)
          LibBEL::bel_token_iterator_next(self.pointer)
        end
      else
        enum_for(:each)
      end
    end

    def self.release(ptr)
      LibBEL::free_bel_token_iterator(ptr)
    end
  end
end
