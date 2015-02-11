require_relative 'identifier_search'
require 'net/http'

module BEL
  module Search

    class RemoteAPI
      include BEL::Search::IdentifierSearch

      # see {BEL::IdentifierSearch#search}
      def search(query_expression, scheme_uri = nil, options = {})
        NotImplementedError.new("No support for remote api yet.")
      end

      # see {BEL::IdentifierSearch#search_annotations}
      def search_annotations(query_expression, scheme_uri = nil, options = {})
        NotImplementedError.new("No support for remote api yet.")
      end

      # see {BEL::IdentifierSearch#search_namespaces}
      def search_namespaces(query_expression, scheme_uri = nil, options = {})
        NotImplementedError.new("No support for remote api yet.")
      end
    end
  end
end
