module BEL

  # The {Extension} module defines specific areas of customization within the
  # *bel* gem:
  #
  # - Document formats: see {BEL::Extension::Format}
  module Extension

    # Loads BEL extensions from the +$LOAD_PATH+ under the path
    # +bel/extensions/{extension}+. These extensions are merely ruby scripts
    # meant to extend functionality within the *bel* gem.
    #
    # For example, let's say we created the foo.rb file containing a Foo
    # extension. We must do the following to load it:
    #
    # - Locate foo.rb at +bel/extensions/foo.rb+ anywhere on the +$LOAD_PATH+.
    # - Instantiate and register our extension.
    # - Call +BEL.extension :foo+ to load the extension.
    #
    # @param [Array<#to_s>] extensions the extensions to load
    def self.load_extension(*extensions)
      extensions.each do |ext|
        Kernel.require "bel/extensions/#{ext}"
      end
    end

    class ExtensionRegistrationError < StandardError

      attr_reader :extension

      def initialize(extension, msg = "Extension error for #{extension}")
        super(msg)
        @extension = extension
      end
    end
  end
end
