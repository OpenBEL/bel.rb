module BEL
  module LibBEL

    class BelToken < FFI::Struct

      layout :type,      :bel_token_type,
             :pos_start, :int,
             :pos_end,   :int,
             :value,     :pointer

      def type
        self[:type]
      end

      def pos_start
        self[:pos_start]
      end

      def pos_end
        self[:pos_end]
      end

      def value
        self[:value].read_string
      end

      def hash
        [self.type, self.value, self.pos_start, self.pos_end].hash
      end

      def ==(other)
        return false if other == nil
        self.type == other.type && self.value == other.value &&
          self.pos_start == other.pos_start && self.pos_end == other.pos_end
      end

      alias_method :eql?, :'=='
    end
  end
end
