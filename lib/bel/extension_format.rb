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
    # To see how to define a new format extension have a look at the
    # {Format::Formatter} module.
    #
    module Format

      FORMATTER_MUTEX = Mutex.new
      private_constant :FORMATTER_MUTEX

      # Registers the +formatter+ object as available to callers. The
      # +formatter+ should respond to the methods defined in the
      # {Format::Formatter} module.
      #
      # @param  [Format::Formatter] formatter the formatter to register
      # @return [Format::Formatter] the +formatter+ parameter is returned
      #         for convenience
      def self.register_formatter(formatter)
        FORMATTER_MUTEX.synchronize {
          @@formatters ||= []
          # vivified hash, like: { :foo => { :bar => [] } }
          @@index ||= (
            Hash.new do |h0, k0|
              h0[k0] = Hash.new do |h1, k1|
                h1[k1] = []
              end
            end
          )
          
          if _formatters(formatter.id)
            raise ExtensionRegistrationError.new(formatter.id)
          end

          # track registered formatters
          @@formatters << formatter

          # index formatter by its id
          @@index[:id][symbolize(formatter.id)] << formatter

          # index formatter by one or more file extensions
          [formatter.file_extensions].flatten.compact.to_a.each do |file_ext|
            @@index[:file_extension][symbolize(file_ext)] << formatter
          end

          # index formatter by one or more media types
          [formatter.media_types].flatten.compact.to_a.each do |media_type|
            @@index[:media_type][symbolize(media_type)] << formatter
          end

          formatter
        }
      end

      # Returns the {Format::Formatter formatters} found for the +values+
      # splat. The returned matches have the same cardinality as the +values+
      # splat to allow destructuring.
      #
      # @example Retrieve a single formatter by id.
      #   bel_formatter  = Format.formatters(:bel)
      # @example Retrieve a single formatter by file extension.
      #   xbel_formatter = Format.formatters(:xml)
      # @example Retrieve a single formatter by media type.
      #   json_formatter = Format.formatters(%s(application/json))
      # @example Retrieve multiple formatters using mixed values.
      #   belf, xbelf, jsonf = Format.formatters(:bel, :xml, "application/json")
      #
      # @param  [Array<#to_s>] values the splat that identifies formatters
      # @return [Format::Formatter Array<Format::Formatter>] for each
      #         consecutive value in the +values+ splat; if the +values+ splat
      #         contains one value then a single formatter reference is returned
      #         (e.g. not an Array)
      def self.formatters(*values)
        FORMATTER_MUTEX.synchronize {
          _formatters(*values)
        }
      end

      def self._formatters(*values)
        if values.empty?
          Array.new @@formatters
        else
          index = (@@index ||= {})
          matches = values.map { |value|
            value = symbolize(value)
            @@index.values_at(:id, :file_extension, :media_type).
              compact.
              inject([]) { |result, coll|
                if coll.has_key?(value)
                  result.concat(coll[value])
                end
                result
              }.uniq.first
          }
          matches.size == 1 ? matches.first : matches
        end
      end
      private_class_method :_formatters

      def self.symbolize(key)
        key.to_s.to_sym
      end
      private_class_method :symbolize

      # The Formatter module defines methods to be implemented by a format
      # extension +Class+. It is broken up into three parts:
      #
      # - Metadata
      #   - {#id}:              the runtime-wide unique extension id
      #   - {#media_types}:     the media types this format supports
      #   - {#file_extensions}: the file extensions this format supports
      # - Deserialize
      #   - {#deserialize}:     read the implemented document format and return
      #     {::BEL::Model::Evidence} objects
      # - Serialize
      #   - {#serialize}:       write {::BEL::Model::Evidence} objects to the
      #     implemented document format
      #
      # @example Typical creation of a {Formatter} class.
      #   class FormatYAML
      #     include BEL::Extension::Format::Formatter
      #     # override methods
      #   end
      #
      # @example Create a YAML format extension.
      #   class FormatYAML
      #     include BEL::Extension::Format::Formatter
      #
      #     ID          = :yaml
      #     MEDIA_TYPES = %i(text/yaml)
      #     EXTENSIONS  = %i(yaml)
      #
      #     def id
      #       ID
      #     end
      #
      #     def media_types
      #       MEDIA_TYPES
      #     end
      #
      #     def file_extensions
      #       EXTENSIONS
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
      module Formatter

        def id
          raise NotImplementedError.new("#{__method__} is not implemented.")
        end

        def media_types
          # optional
          nil
        end

        def file_extensions
          # optional
          nil
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

      # FormatError represents an error when the specified format is not
      # supported by the {Format} extension framework.
      class FormatError < StandardError

        FORMAT_ERROR = %Q{Format "%s" is not supported.}

        def initialize(format)
          super(FORMAT_ERROR % format)
        end
      end
    end
  end
end
