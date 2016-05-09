module BEL

  # Translate module defines translation capabilities in the library. This
  # module provides the API to use translator plugins.
  #
  # @see ::BEL::Translator::Plugins
  module Translate

    # Defines the translate API that is provided under the {BEL} module as a
    # mixin.
    module ClassMethods

      # Return a stream of {::BEL::Nanopub::Nanopub} objects for the input.
      #
      # @param  [IO]                     input        the IO to read from
      # @param  [Symbol]                 input_format the symbol that can be
      #         used to identify the translator plugin that can read the
      #         +input+
      # @param  [Hash{Symbol => Object}] options
      # @return [#each]                  an object that responds to +each+ and
      #         provides {::BEL::Nanopub::Nanopub} objects
      def nanopub(input, input_format, options = {})
        prepared_input = process_input(input)

        in_translator  = self.translator(input_format) or
          raise TranslateError.new(input_format)

        in_translator.read(prepared_input)
      end

      # Translate from one file format to another using
      # {::BEL::Nanopub::Nanopub} as a shared model. The translation is written
      # to the IO +writer+ directly.
      #
      # @param  [IO]                     input         the IO to read from
      # @param  [#to_sym]                input_format  the identifier for the
      #         translator plugin that will read the +input+
      # @param  [#to_sym]                output_format the identifier for the
      #         translator plugin that will write to +writer+
      # @param  [Hash{Symbol => Object}] options
      # @return [IO   ]                  the IO +writer+ that the translation
      #         was written to
      def translate(input, input_format, output_format, writer = StringIO.new, options = {})
        prepared_input = process_input(input)

        in_translator  = self.translator(input_format, options) or
          raise TranslateError.new(input_format)

        out_translator = self.translator(output_format, options) or
          raise TranslateError.new(output_format)

        nanopub = in_translator.read(prepared_input)
        out_translator.write(nanopub, writer, options)
        writer
      end

      # Return the {::BEL::Translator} plugin given an identifier.
      #
      # @param  [#to_sym]                input_format the identifier for the
      #         translator plugin
      # @param  [Hash{Symbol => Object}] options
      # @return [::BEL::Translator]      the translator instance that is
      #         responds to {::BEL::Translator#read} and
      #         {::BEL::Translator#write}
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

    # TranslateError represents an error when the specified format is not
    # supported by any translator plugin.
    class TranslateError < StandardError

      FORMAT_ERROR = %Q{Format "%s" is not supported.}

      def initialize(format)
        super(FORMAT_ERROR % format)
      end
    end
  end
end
