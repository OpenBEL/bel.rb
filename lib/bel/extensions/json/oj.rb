require 'oj'

module BEL::Extension::Format
  module JSONImplementation

    class JSONReader
      def initialize(data)
        @data = data
      end

      def each(&block)
        if block_given?
          Oj.sc_parse(EvidenceHandler.new(block), @data, :symbol_keys => true)
        else
          to_enum(:each)
        end
      end
    end

    class JSONWriter

      def write_json_object(json_object)
        Oj.dump(json_object, :mode => :compat)
      end
    end

    private

    class EvidenceHandler < Oj::ScHandler

      def initialize(callable)
        @callable = callable
      end

      def hash_start
        {}
      end

      def hash_end
        @callable.call @hash 
      end

      def hash_set(hash, key, value)
        hash[key]  = value
        @hash = hash
      end

      def array_start
        @array = []
        @array
      end

      def array_append(array, value)
        array << value
        @array = array
      end

      def array_end()
        @callable.call @array
      end

      def error(message, line, column)
        msg = "Parse error at line #{line}, column #{column}: #{message}"
        raise Oj::ParseError.new(msg)
      end
    end
  end
end
