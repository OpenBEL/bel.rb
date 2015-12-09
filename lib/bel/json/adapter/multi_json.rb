require 'multi_json'

require_relative '../reader'
require_relative '../writer'

module BEL::JSON

  class Implementation

    include Reader
    include Writer

    def read(data, options = {})
      if block_given?
        options = { :symbolize_keys => true }.merge!(options)
        parsed  = MultiJson.load(data, options)
        if parsed.respond_to?(:each_pair)
          yield parsed
        else
          parsed.each do |obj|
            yield obj
          end
        end
      else
        to_enum(:read, data, options)
      end
    end

    def write(data, output_io, options = {})
      json = MultiJson.dump(data)
      if output_io
        # write json and return IO
        output_io.write json
        output_io
      else
        # return json string
        json
      end
    end
  end
end
