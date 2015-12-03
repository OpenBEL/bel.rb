require 'json'

require_relative '../reader'
require_relative '../writer'

module BEL::JSON

  class Implementation

    include Reader
    include Writer

    def read(data, options = {})
      if block_given?
        options = { :symbolize_names => true }.merge!(options)
        parsed  = JSON.load(data, nil, options)
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
      JSON.dump(data, output_io)
    end
  end
end
