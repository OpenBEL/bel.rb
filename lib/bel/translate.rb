module BEL
  module Translate

    module ClassMethods

      def evidence(input, input_format)
        prepared_input = process_input(input)

        in_translator  = self.translator(input_format) or
          raise TranslateError.new(input_format)

        EvidenceIterable.new(prepared_input, in_translator)
      end

      def translate(input, input_format, output_format, writer = nil)
        prepared_input = process_input(input)

        in_translator  = self.translator(input_format) or
          raise TranslateError.new(input_format)

        out_translator = self.translator(output_format) or
          raise TranslateError.new(output_format)

        evidence = in_translator.read(prepared_input)
        output   = out_translator.write(evidence, writer)
      end

      def translator(input_format, options = {})
        return nil unless input_format

        id      = input_format.to_sym
        plugins = BEL::Translator.plugins

        plugin = plugins[id]
        if plugin
          plugin.create_translator(options)
        else
          match = BEL::Translator.plugins.values.find { |t|
            match  = false
            match |= (id == t.name.to_sym)
            match |= (t.media_types.include?(id))
            match |= (t.file_extensions.include?(id))
            match
          }
          match.create_translator(options) if match
        end
      end

      def process_input(input)
        if input.respond_to? :read
          input
        elsif File.exist?(input)
          File.open(input, :ext_enc => Encoding::UTF_8)
        elsif input.respond_to? :to_s
          input.to_s
        end
      end
    end

    class EvidenceIterable
      include Enumerable

      def initialize(input, format)
        @input  = input
        @format = format
      end

      def each
        if block_given?
          @format.deserialize(@input).each do |evidence|
            yield evidence
          end
        else
          to_enum(:each)
        end
      end
    end

    # TranslateError represents an error when the specified format is not
    # supported by the {Format} extension framework.
    class TranslateError < StandardError

      FORMAT_ERROR = %Q{Format "%s" is not supported.}

      def initialize(format)
        super(FORMAT_ERROR % format)
      end
    end
  end
end
