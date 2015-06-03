module BEL
  module Format
    Format      = BEL::Extension::Format
    FormatError = BEL::Extension::Format::FormatError

    def self.evidence(input, input_format)
      prepared_input = process_input(input)

      in_formatter  = BEL::Extension::Format.formatters(input_format) or
        raise FormatError.new(input_format)

      EvidenceIterable.new(prepared_input, in_formatter)
    end

    def self.translate(input, input_format, output_format, writer = nil)
      prepared_input = process_input(input)

      in_formatter  = BEL::Extension::Format.formatters(input_format) or
        raise FormatError.new(input_format)

      out_formatter = BEL::Extension::Format.formatters(output_format) or
        raise FormatError.new(output_format)

      objects = in_formatter.deserialize(prepared_input)
      output = out_formatter.serialize(objects, writer)
    end

    def self.process_input(input)
      if input.respond_to? :read
        input
      elsif File.exist?(input)
        File.open(input, :ext_enc => Encoding::UTF_8)
      elsif input.respond_to? :to_s
        input.to_s
      end
    end
    private_class_method :process_input

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
  end
end
