require 'oj'

require_relative '../reader'
require_relative '../writer'

module BEL::JSON

  class Implementation

    include Reader
    include Writer

    def read(data, options = {}, &block)
      if block_given?
        options = { :symbol_keys => true }.merge!(options)
        Oj.sc_parse(StreamHandler.new(block), data, options)
      else
        to_enum(:read, data, options)
      end
    end

    def write(data, output_io, options = {})
      Oj.to_stream(output_io, data)
    end
  end

  class StreamHandler < Oj::ScHandler

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
