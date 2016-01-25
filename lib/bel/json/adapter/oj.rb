require 'oj'

require_relative '../reader'
require_relative '../writer'

module BEL::JSON

  # Implementation of JSON reading/writing using stream-based approaches in Oj.
  class Implementation

    include Reader
    include Writer

    # Reads JSON from an IO using a streaming mechanism in Oj. Yields to the
    # block, or returns {Enumerator}, of Hash (JSON objects) and
    # Array (JSON arrays).
    #
    # @param      [IO]   data                             an IO-like object
    # @param      [Hash] options supplemental options to Oj; default is to
    #             set the +:symbol_keys+ option to +true+
    # @yield each completed Hash (JSON object) or completed Array (JSON array)
    # @return     [Enumerator] contains an enumeration of Hash (JSON object)
    #             and Array (JSON array)
    def read(data, options = {}, &block)
      if block_given?
        options = { :symbol_keys => true }.merge!(options)
        Oj.sc_parse(StreamHandler.new(block), data, options)
      else
        to_enum(:read, data, options)
      end
    end

    # Writes objects to JSON using a streaming mechanism in Oj.
    #
    # If an IO is provided as +output_io+ then the encoded JSON will be written
    # directly to it and returned from the method.
    #
    # If an IO is not provided (i.e. `nil`) then the encoded JSON {String} will
    # be returned.
    #
    # @param  [Hash, Array, Object] data      the objects to encode as JSON
    # @param  [IO]                  output_io the IO to write the encoded JSON
    #         to
    # @param  [Hash]                options supplemental options to Oj; default
    #         is to set the +:mode+ option to +:compat+
    # @return [IO, String]          an {IO} of encoded JSON is returned if it
    # was provided as an argument, otherwise a JSON-encoded {String} is
    # returned
    def write(data, output_io, options = {})
      options = {
        :mode => :compat
      }.merge!(options)

      if output_io
        # write json and return IO
        Oj.to_stream(output_io, data, options)
        output_io
      else
        # return json string
        string_io = StringIO.new
        Oj.to_stream(string_io, data, options)
        string_io.string
      end
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
