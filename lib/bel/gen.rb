require          'bel'

module BEL

  # The {Gen} module defines submodules that generate random data that
  # represent parts of a {::BEL::Nanopub nanopub}.
  module Gen

    # Requires +paths+ treated as a soft dependency to bel.rb.
    #
    # @param  [Array<String>] paths the paths to require as soft dependencies
    # @return [Array<Boolean>] array of {Kernel#require} results; parallel
    #         with +paths+
    # @raise  [LoadError] if any {String} in +paths+ cannot be required
    def self.soft_require(*paths)
      paths.map { |path|
        begin
          require(path)
        rescue LoadError => err
          $stderr.puts <<-ERR.gsub(/^ {12}/, '')
            Error loading soft dependency.
            You will need to install "#{path}" to use this feature.

            Execute the following on the command line:

              gem install #{path}

            Error:

              #{err}

          ERR
          raise
        end
      }
    end
  end
end

# Load generators after {BEL::Gen#soft_require} is available.
require_relative 'gen/document_header'
require_relative 'gen/annotation'
require_relative 'gen/citation'
require_relative 'gen/namespace'
require_relative 'gen/parameter'
require_relative 'gen/term'
require_relative 'gen/statement'
require_relative 'gen/nanopub'
require_relative 'gen/sample_resources'

# vim: ts=2 sw=2:
# encoding: utf-8
