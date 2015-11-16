module BEL::JSON

  module Reader

    def read(input, options = {})
      raise NotImplementedError.new("#{__method__} is not implemented.")
    end
  end
end
