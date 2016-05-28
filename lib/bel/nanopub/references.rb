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
            namespace[:type],
            namespace[:domain]
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
        annotation =
          BELParser::Expression::Model::Annotation.new(
            keyword,
            type.to_sym,
            domain)
        annotations << annotation
        annotations.sort_by! { |a| a.keyword }
      end

      def add_namespace(keyword, type, domain)
        case type
        when :uri
          uri = domain
          url = nil
        when :url
          url = domain
          uri = nil
        end

        namespace =
          BELParser::Expression::Model::Namespace.new(
            keyword.to_s,
            uri,
            url)
        namespaces << namespace
        namespaces.sort_by! { |n| n.keyword }
      end

      def to_h(hash = {})
        hash[ANNOTATIONS] = annotations.map { |anno|
          {
            :keyword => anno.keyword,
            :type    => anno.type,
            :domain  =>
              case anno.domain
              when Regexp
                anno.domain.source
              else
                anno.domain
              end
          }
        }

        hash[NAMESPACES] = namespaces.map { |ns|
          {
            :keyword => ns.keyword,
            :type    => ns.type,
            :domain  => ns.domain
          }
        }

        hash
      end

      def_delegators :@values, :[],    :"[]=", :delete_if,   :each, :each_pair,
                               :fetch, :keys,  :size,        :sort, :store
    end
  end
end
