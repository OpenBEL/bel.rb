module BEL
  module LibBEL

    class LibraryLoadError < StandardError

      ERROR_MSG = %Q{
        The C extension library could not be loaded for your platform.

        Host information:

        RUBY_PLATFORM:                #{RUBY_PLATFORM},
        RbConfig::CONFIG['host_os']:  #{RbConfig::CONFIG['host_os']},
        RbConfig::CONFIG['host_cpu']: #{RbConfig::CONFIG['host_cpu']},
        library:                      %s

        Original error:

        Name:                         %s,
        Message:                      %s
      }.gsub(/^\s+/, '')

      attr_reader :cause

      def initialize(library_name, cause=$!)
        super(ERROR_MSG % [library_name, cause.class, cause.message])
        @cause = cause;
      end
    end
  end
end
