module BEL
  module BELRDF

    unless self.methods.include?(:generate_uuid)

      # Dynamically defines an efficient UUID method for the current ruby.
      if RUBY_ENGINE =~ /^jruby/i
        java_import 'java.util.UUID'
        define_singleton_method(:generate_uuid) do
          Java::JavaUtil::UUID.random_uuid.to_s
        end
      else
        require 'uuid'
        define_singleton_method(:generate_uuid) do
          UUID.generate
        end
      end
    end
  end
end
