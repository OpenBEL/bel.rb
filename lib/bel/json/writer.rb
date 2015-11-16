module BEL::JSON

  module Writer

    def write(data, output, options = {})
      raise NotImplementedError.new("#{__method__} is not implemented.")
    end
  end
end
