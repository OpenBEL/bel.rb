module BEL
  # Captures the semantic version of the library.
  module Version
    # The frozen version {String}. See {Object#freeze}.
    STRING =
      File.read(
        File.join(
          File.expand_path(File.dirname(__FILE__)), '..', '..', 'VERSION'
        )).chomp.freeze

    # The frozen {Fixnum version numbers}. See {Object#freeze}.
    MAJOR, MINOR, PATCH = STRING.split('.').map(&:freeze)
    # The frozen {Array} of {Fixnum version numbers}. See {Object#freeze}.
    VERSION_NUMBERS     = [MAJOR, MINOR, PATCH].freeze

    # Add singleton methods to the metaclass of {BEL::Version}.
    class << self

      # Return the frozen, semantic version {String}.
      # @return [frozen String] the semantic version
      def to_s
        STRING
      end
      alias :to_str :to_s

      # Return the frozen, semantic version number {Array}.
      # @return [frozen Array] the semantic version numbers
      def to_a
        VERSION_NUMBERS
      end
    end
  end
end
