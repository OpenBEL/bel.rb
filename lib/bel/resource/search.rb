require_relative 'search/search_result'
require_relative 'search/api'

module BEL
  module Resource

    module Search

      module Plugins; end

      extend LittlePlugger(
        :path   => 'bel/resource/search/plugins',
        :module => BEL::Resource::Search::Plugins
      )

      module ClassMethods

        # @param  [Hash<Symbol => Object>] options
        # @return
        def self.create_search(options = {})
          fail NotImplementedError.new, "#{__method__} is not implemented"
        end
      end
    end
  end
end
