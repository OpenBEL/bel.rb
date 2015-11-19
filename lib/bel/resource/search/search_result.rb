module BEL
  module Resource
    module Search

      # Represents an identifier search result.
      #
      # @example Create with all parameters
      #   SearchResult.new(
      #     'viral <b>oncogene</b> homolog',
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
      class SearchResult < Struct.new(:snippet, :uri, :scheme_uri, :identifier, :pref_label, :title, :alt_labels)
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
