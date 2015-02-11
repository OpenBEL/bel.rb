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

      LIMIT_CLAUSE     = ' LIMIT ? OFFSET ?'
      GLOBAL_FTS_QUERY = '''
        SELECT
          distinct uri, scheme_uri, identifier, pref_label, alt_labels, snippet(literals_fts) AS snippet
        FROM
          literals_fts
        WHERE
          literals_fts MATCH ?'''
        .gsub(/[ \n]{2,}/, ' ')
      SCHEME_FTS_QUERY = GLOBAL_FTS_QUERY + ' AND scheme_uri = ?'

      def initialize(options = {})
        @db_file = options.delete(:db_file)
        unless @db_file or File.readable?(@db_file)
          fail ArgumentError.new('The db_file option cannot be read.')
        end

        @db = SQLite3::Database.new @db_file
        @db.results_as_hash = true
        @gq  = @db.prepare(GLOBAL_FTS_QUERY + LIMIT_CLAUSE)
        @sq  = @db.prepare(SCHEME_FTS_QUERY + LIMIT_CLAUSE)
      end

      # see {BEL::IdentifierSearch#search}
      def search(query_expression, scheme_uri = nil, options = {})
        search_namespaces(query_expression, scheme_uri, options)
      end

      # see {BEL::IdentifierSearch#search_annotations}
      def search_annotations(query_expression, scheme_uri = nil, options = {})
        search_namespaces(query_expression, scheme_uri, options)
      end

      # see {BEL::IdentifierSearch#search_namespaces}
      def search_namespaces(query_expression, scheme_uri = nil, options = {})
        start = (options.delete(:start) ||  0).to_i
        size  = options.delete(:size)   || -1
        if size.to_i.zero?
          fail ArgumentError.new(":size is zero")
        end

        result_set =
          if scheme_uri
            @sq.execute(query_expression, scheme_uri, size, start)
          else
            @gq.execute(query_expression, size, start)
          end
        if result_set.respond_to? :lazy
          result_set = result_set.lazy
        end
        result_set.map { |result_hash|
          symbolize_keys!(result_hash)
          result_hash[:alt_labels] = (result_hash[:alt_labels] || '').split('|')
          SearchResult.new(result_hash)
        }
      end

      private

      def symbolize_keys!(hash)
        hash.keys.each do |key|
            hash[(key.to_sym rescue key) || key] = hash.delete(key)
        end
      end
    end
  end
end
