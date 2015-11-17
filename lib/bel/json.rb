# TODO Document.
#
# What does this abstraction provide?
# Why is it here?
# 
module BEL::JSON

  # TODO Document.
  #
  # Reads JSON data. Leverages JSON adapters which implement the same signature.
  def self.read(data, options = {})
    @adapter ||= self.adapter
    instance = @adapter.new

    if block_given?
      instance.read(data, options) { |obj|
        yield obj
      }
    else
      instance.read(data, options)
    end
  end

  # TODO Document.
  #
  # Writes JSON data. Leverages JSON adapters which implement the same signature.
  def self.write(data, output_io, options = {})
    @adapter ||= self.adapter
    instance = @adapter.new
    instance.write(data, output_io, options)
  end

  # Load the most suitable JSON implementation available within ruby.
  # The load order attempted is:
  # - oj              (provides stream parsing utilizing event callbacks)
  # - multi_json      (simple buffering abstraction over multiple ruby libraries)
  # - json            (stock ruby implementation)
  def self.adapter
    implementations = [
      'json/adapter/oj',
      'json/adapter/multi_json',
      'json/adapter/ruby_json'
    ]

    load_success = implementations.any? { |impl|
      begin
        require_relative impl
        true
      rescue LoadError
        # Could not load +impl_module+; try the next one
        false
      end
    }

    if load_success
      BEL::JSON::Implementation
    else
      mod_s = impl_modules.join(', ')
      msg   = "Could not load any JSON implementation (tried: #{mod_s})."
      raise LoadError.new(msg)
    end
  end
end
