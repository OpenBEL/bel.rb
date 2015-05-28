module BEL
  module Extension

    # The {Format} module defines a framework for adding new document formats.
    # This is useful when reading, writing, and {BEL::Translation translating}
    # BEL data.
    #
    # A {Format} extension is defined and registered in the following steps:
    #
    # - Create a ruby source file located under +bel/extensions/+ on the
    #   +$LOAD_PATH+.
    # - Within the file, create a class that implements the protocol specified
    #   by {Format::Formatter}.
    # - Instantiate and register your format extension by calling
    #   {Format.register_formatter}.
    #
    # @example Create a YAML format for BEL.
    #   class FormatYAML
    #     include BEL::Extension::Format::Formatter
    #
    #     ID = :yaml
    #
    #     def id
    #       ID
    #     end
    #
    #     def deserialize(data)
    #       YAML.load(data)
    #     end
    #
    #     def serialize(data)
    #       YAML.dump(data)
    #     end
    #   end
    module Format

      FORMATTER_MUTEX = Mutex.new
      private_constant :FORMATTER_MUTEX

      def self.register_formatter(formatter)
        FORMATTER_MUTEX.synchronize {
          formatters = @@formatters ||= {}
          formatters[symbolize(formatter.id)] = formatter
        }
      end

      def self.formatters_for(*name_or_extension)
        FORMATTER_MUTEX.synchronize {
          formatters = @@formatters ||= {}
          matches = name_or_extension.map { |value|
            formatters[symbolize(value)]
          }
          matches.size == 1 ? matches.first : matches
        }
      end

      def self.symbolize(key)
        key.to_s.to_sym
      end
      private_class_method :symbolize

      module Formatter
        def id
          raise NotImplementedError.new("#{__method__} is not implemented.")
        end

        def evidence_hash(object)
          raise NotImplementedError.new("#{__method__} is not implemented.")
        end

        def deserialize(data)
          raise NotImplementedError.new("#{__method__} is not implemented.")
        end

        def serialize(data, writer = nil)
          raise NotImplementedError.new("#{__method__} is not implemented.")
        end
      end

      class FormatError < StandardError

        FORMAT_ERROR = %Q{Format "%s" is not supported.}

        def initialize(format)
          super(FORMAT_ERROR % format)
        end
      end
    end
  end
end
