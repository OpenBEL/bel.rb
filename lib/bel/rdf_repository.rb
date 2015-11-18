module BEL
  module RdfRepository

    module Plugins; end

    extend LittlePlugger(
      :path   => 'bel/rdf_repository/plugins',
      :module => BEL::RdfRepository::Plugins
    )

    module ClassMethods

      def create_repository(options = {})
        raise NotImplementedError.new("#{__method__} is not implemented.")
      end
    end
  end
end
