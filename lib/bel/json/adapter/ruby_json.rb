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
        JSON.load(data, nil, options).each do |obj|
          yield obj
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
