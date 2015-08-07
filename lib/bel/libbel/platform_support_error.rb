module BEL
  module LibBEL

    class PlatformSupportError < StandardError

      ERROR_MSG = %Q{
        The C extension library is not supported for your platform.

        Host information:

        RUBY_PLATFORM:                #{RUBY_PLATFORM},
        RUBY_ENGINE:                  #{RUBY_ENGINE},
        RUBY_VERSION:                 #{RUBY_VERSION},
        RbConfig::CONFIG['host_os']:  #{RbConfig::CONFIG['host_os']},
        RbConfig::CONFIG['host_cpu']: #{RbConfig::CONFIG['host_cpu']},
      }.gsub(/^\s+/, '')

      def initialize
        super(ERROR_MSG)
      end
    end
  end
end
