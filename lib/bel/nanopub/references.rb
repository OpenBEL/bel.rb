require 'forwardable'
require 'set'
require 'bel_parser/expression/model/namespace'

module BEL
  module Nanopub
    class References

      attr_reader :values

      extend Forwardable
      include Enumerable

      ANNOTATIONS = :annotations
      NAMESPACES  = :namespaces

      def initialize(values = {})
        @values = {}

        values.fetch(ANNOTATIONS, []).each do |annotation|

          add_annotation(
            annotation[:keyword],
            annotation[:type],
            annotation[:domain]
          )
        end

        values.fetch(NAMESPACES, []).each do |namespace|

          add_namespace(
            namespace[:keyword],
            namespace[:uri]
          )
        end
      end

      def annotations
        @values[ANNOTATIONS] ||= []
      end

      def annotations_hash
        Hash[annotations.map { |ns| ns.values_at(:keyword, :domain) }]
      end

      def annotations=(annotations)
        @values[ANNOTATIONS] = annotations
      end

      def namespaces
        @values[NAMESPACES] ||= []
      end

      def namespaces_hash
        Hash[ namespaces.map { |n| [n.keyword, n] } ]
      end

      def namespaces=(namespaces)
        @values[NAMESPACES] = namespaces
      end

      def add_annotation(keyword, type, domain)
        if type == :pattern
          domain = case domain
                   when Regexp
                     domain
                   else
                     Regexp.new(domain.to_s)
                   end
        end

        annotations << {
          :keyword => keyword,
          :type    => type,
          :domain  => domain
        }
        annotations.sort_by! { |anno| anno[:keyword] }
      end

      def add_namespace(keyword, uri)
        namespace =
          BELParser::Expression::Model::Namespace.new(
            keyword.to_s,
            uri,
            nil)
        namespaces << namespace
        namespaces.sort_by! { |n| n.keyword }
      end

      def to_h(hash = {})
        hash[ANNOTATIONS] = annotations.map { |anno|
          keyword, type, domain = anno.values_at(:keyword, :type, :domain)

          domain = case domain
                   when Regexp
                     domain.source
                   else
                     domain
                   end

          {
            :keyword => keyword,
            :type    => type,
            :domain  => domain
          }
        }

        hash[NAMESPACES] = namespaces.map { |ns|
          ns.dup
        }

        hash
      end

      def_delegators :@values, :[],    :"[]=", :delete_if,   :each, :each_pair,
                               :fetch, :keys,  :size,        :sort, :store
    end
  end
end
