require 'bel'

require_relative 'citation'
require_relative 'support'
require_relative 'experiment_context'
require_relative 'references'
require_relative 'metadata'

module BEL
  module Nanopub

    class Nanopub
      def self.create(hash)
        nanopub = Nanopub.new
        nanopub.bel_statement      = hash[:bel_statement] || nil
        nanopub.citation           = Citation.new(hash[:citation] || {})
        nanopub.support.value      = hash[:support] || nil
        nanopub.experiment_context = ExperimentContext.new(hash[:experiment_context] || [])
        nanopub.references         = References.new(hash[:references] || {})
        nanopub.metadata           = Metadata.new(hash[:metadata] || {})
        nanopub
      end

      def self.parse_statement(nanopub)
        namespaces = nanopub.references.namespaces
        ::BEL::Script.parse(
          "#{nanopub.bel_statement}\n",
          Hash[
            namespaces.map { |ns|
              keyword, uri = ns.values_at(:keyword, :uri)
              sym          = keyword.to_sym
              [
                sym,
                ::BEL::Namespace::NamespaceDefinition.new(sym, uri, nil)
              ]
            }
          ]
        ).select { |obj|
          obj.is_a? ::BEL::Nanopub::Statement
        }.first
      end

      def bel_statement
        (@bel_statement ||= Statement.new)
      end

      def bel_statement=(bel_statement)
        @bel_statement = bel_statement
      end

      def citation
        (@citation ||= Citation.new)
      end

      def citation=(citation)
        @citation = citation
      end

      def support
        (@support ||= Support.new)
      end

      def support=(support)
        @support = support
      end

      def experiment_context
        (@experiment_context ||= ExperimentContext.new)
      end

      def experiment_context=(experiment_context)
        @experiment_context = experiment_context
      end

      def references
        (@references ||= References.new)
      end

      def references=(references)
        @references = references
      end

      def metadata
        (@metadata ||= Metadata.new)
      end

      def metadata=(metadata)
        @metadata = metadata
      end

      def to_h(hash = {})
        hash.merge!(
          {
            :bel_statement      => bel_statement,
            :citation           => citation.to_h,
            :support            => support.value,
            :experiment_context => experiment_context.values,
            :references         => references.to_h,
            :metadata           => metadata.to_a
          }
        )
        hash
      end

      private

      def parse_statement(bel_statement)
        namespaces = self.references.namespaces
        ::BEL::Script.parse(
          "#{bel_statement}\n",
          Hash[
            namespaces.map { |ns|
              keyword, uri = ns.values_at(:keyword, :uri)
              sym          = keyword.to_sym
              [
                sym,
                ::BEL::Namespace::NamespaceDefinition.new(sym, uri, uri)
              ]
            }
          ]
        ).select { |obj|
          obj.is_a? ::BEL::Nanopub::Statement
        }.first
      end
    end
  end
end
