module BEL
  module Search
    module IdentifierSearch

      # Search for annotation identifiers based on +query_expression+.
      #
      # If +scheme_uri+ is +not nil+ then filter {SearchResult search results} that are contained in the annotation scheme.
      #
      # If +scheme_uri+ is +nil+ then do not filter by annotation scheme (e.g. return all {SearchResult search results} matching +query_expression+)
      #
      # @param query_expression [responds to #to_s] query expression
      # @param scheme_uri       [responds to #to_s] scheme uri
      # @return [Array<SearchResult>, nil]
      def search_annotations(query_expression, scheme_uri = nil, options = {})
        fail NotImplementedError.new, "#{__method__} is not implemented"
      end

      # Search for namespace identifiers based on +query_expression+.
      #
      # If +scheme_uri+ is +not nil+ then filter {SearchResult search results} that are contained in the namespace scheme.
      #
      # If +scheme_uri+ is +nil+ then do not filter by namespace scheme (e.g. return all {SearchResult search results} matching +query_expression+)
      #
      # @param query_expression [responds to #to_s] query expression
      # @param scheme_uri       [responds to #to_s] scheme uri
      # @return [Array<SearchResult>, nil]
      def search_namespaces(query_expression, scheme_uri = nil, options = {})
        fail NotImplementedError.new, "#{__method__} is not implemented"
      end

      # Represents an identifier search result.
      #
      # @example Create with all parameters
      #   SearchResult.new(
      #     'http://www.openbel.org/bel/namespace/hgnc-human-genes/391',
      #     'http://www.openbel.org/bel/namespace/hgnc-human-genes',
      #     '391',
      #     'AKT1',
      #     'v-akt murine thymoma viral oncogene homolog 1',
      #     ['AKT', 'PKB', 'PRKBA', 'RAC']
      #   )
      #
      # @example Create from hash
      #   SearchResult.new({ :pref_label => 'AKT1' })
      class SearchResult < Struct.new(:uri, :scheme_uri, :identifier, :pref_label, :title, :alt_labels)
        def initialize(*args)
          if args.length == 1 && args.first.is_a?(Hash)
            hash = args.first
            super(*hash.values_at(*self.class.members))
          else
            super
          end
        end
      end
    end
  end
end

