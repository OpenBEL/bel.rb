unless BEL::Features.sqlite3_support?
  # rdf and addressable are required
  raise RuntimeError, %Q{The sqlite3 configuration for BEL::Search is not supported.
The sqlite3 gem is required.

Install the gems:
      gem install sqlite3}
end

require_relative 'identifier_search'
require 'sqlite3'

module BEL
  module Search

    class Sqlite3FTS
      include BEL::Search::IdentifierSearch

      GLOBAL_FTS_QUERY = '''
        select
          distinct uri, snippet(literals_fts)
        from
          literals_fts
        where
          literals_fts MATCH ?'''
        .gsub(/[ \n]{2,}/, ' ')
      SCHEME_FTS_QUERY = GLOBAL_FTS_QUERY + ' and scheme_uri = ?'

      def initialize(options = {})
        @db_file = options.delete(:db_file)
        unless @db_file or File.readable?(@db_file)
          fail ArgumentError.new('The db_file option cannot be read.')
        end

        @db = SQLite3::Database.new @db_file
        @gq = @db.prepare(GLOBAL_FTS_QUERY)
        @sq = @db.prepare(SCHEME_FTS_QUERY)
      end

      # see {BEL::IdentifierSearch#search_annotations}
      def search_annotations(query_expression, scheme_uri = nil)
        nil
      end

      # see {BEL::IdentifierSearch#search_namespaces}
      def search_namespaces(query_expression, scheme_uri = nil)
        if scheme_uri
          @sq.execute(query_expression, scheme_uri)
        else
          @gq.execute(query_expression)
        end
      end
    end
  end
end
