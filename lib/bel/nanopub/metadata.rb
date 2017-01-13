require 'forwardable'

module BEL
  module Nanopub
    class Metadata

      attr_reader :values

      extend Forwardable
      include Enumerable

      BEL_VERSION     = :bel_version
      DOCUMENT_HEADER = :document_header

      def initialize(values = {})
        if values.is_a? Array
          @values = Hash[
            values.map { |item|
              name  = item[:name]  || item['name']
              value = item[:value] || item['value']
              [name.to_sym, value]
            }
          ]
        else
          @values = values
        end

        doc_hdr = @values[:document_header]
        unless doc_hdr.nil?
          @values[:document_header] = Hash[
            doc_hdr.map { |item|
              [item[0].to_sym, item[1]]
            }
          ]
        end

        unless @values.key?(:bel_version)
          @values[:bel_version] = BELParser::Language.default_version
        end

        header = @values[:document_header]
        unless header.nil?
          authors = header[:Authors]
          unless authors.is_a? Array
            authors = [authors]
            header[:Authors] = authors
          end

          licenses = header[:Licenses]
          unless licenses.is_a? Array
            licenses = [licenses]
            header[:Licenses] = licenses
          end
        end
      end

      def bel_version
        @values[BEL_VERSION]
      end

      def bel_version=(bel_version)
        @values[BEL_VERSION] =
          case bel_version
          when BELParser::Language::Specification
            bel_version.version.to_s
          when String
            bel_version
          else
            raise(
              ArgumentError,
              %(expected String, Specification; actual #{bel_version.class}))
          end
      end

      def document_header
        @values[DOCUMENT_HEADER] ||= {}
      end

      def document_header=(document_header)
        @values[DOCUMENT_HEADER] = document_header
      end

      def ==(other)
        return false if other.nil?
        @values == other.values
      end
      alias eql? ==

      def to_a
        @values.each_pair.map { |key, value|
          {
            name:  key,
            value: value
          }
        }
      end

      def_delegators :@values, :[],    :"[]=", :delete_if, :each, :each_pair,
                               :fetch, :keys,  :size,      :sort, :store
    end
  end
end
