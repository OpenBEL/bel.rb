require_relative 'platform_support_error'

module BEL
  module LibBEL

    module LibraryResolver

      EXT_BASE_PATH = File.join(File.expand_path('..', __FILE__), 'ext')

      def resolve_library(lib_name)
        case library_type(lib_name)
        when :compiled
          compiled_library(lib_name)
        when :windows
          windows_library(lib_name)
        when :java
          java_library(lib_name)
        when :unknown
          raise BEL::LibBEL::PlatformSupportError.new
        end
      end

      private

      def library_type(lib_name)
        exist = File.method(:exist?)
        if compiled_library_paths(lib_name).any?(&exist)
          :compiled
        else
          case RUBY_PLATFORM
          when /mingw/i
            :windows
          when /java/i
            :java
          else
            :unsupported
          end
        end
      end

      def compiled_library(lib_name)
        exist = File.method(:exist?)
        compiled_library_paths(lib_name).detect(&exist)
      end

      def compiled_library_paths(lib_name)
        base_path    = "#{EXT_BASE_PATH}"
        extensions   = ['so', 'bundle', 'dylib']

        extensions.map { |ext|
          "%s/%s.%s" % [base_path, lib_name, ext]
        }
      end

      def windows_library(lib_name)
        unless RUBY_VERSION =~ /^2/
          raise BEL::LibBEL::PlatformSupportError.new
        end

        base_path    = "#{EXT_BASE_PATH}/mingw"
        host_cpu     = RbConfig::CONFIG['host_cpu']
        File.join(base_path, host_cpu, ruby_version, 'libbel.so')
      end

      def java_library(lib_name)
        # extra check to make sure jruby supports Ruby 2 (e.g. JRuby 9.0.0.0)
        unless RUBY_VERSION =~ /^2/
          raise BEL::LibBEL::PlatformSupportError.new
        end

        base_path      = "#{EXT_BASE_PATH}/java"
        host_os        = RbConfig::CONFIG['host_os']
        host_cpu       = RbConfig::CONFIG['host_cpu']

        case host_os
        when /darwin/i
          File.join(base_path, 'darwin', host_cpu, 'libbel.bundle')
        when /mswin/i
          File.join(base_path, 'mswin',  host_cpu, ruby_version, 'libbel.so')
        when /linux/i
          File.join(base_path, 'linux',  host_cpu, 'libbel.so')
        else
          raise BEL::LibBEL::PlatformSupportError.new
        end
      end

      def host_cpu
        RbConfig::CONFIG['host_cpu']
      end

      def host_os
        RbConfig::CONFIG['host_os']
      end

      def ruby_version
        major = RbConfig::CONFIG['MAJOR']
        minor = RbConfig::CONFIG['MINOR']

        "%s.%s" % [major, minor]
      end
    end
  end
end
