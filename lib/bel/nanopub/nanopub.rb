require 'bel'
require 'bel_parser/expression'

require_relative 'citation'
require_relative 'support'
require_relative 'experiment_context'
require_relative 'references'
require_relative 'metadata'

module BEL
  module Nanopub
    # Nanopub represents an asserted biological interaction with associated
    # constituents:
    #
    # - BEL Statement
    # - Citation
    # - Support
    # - Experiment Context
    # - References
    # - Metadata
    class Nanopub

      def self.create(hash)
        nanopub = Nanopub.new
        # Order-dependent; metadata/references must be set first in order for
        # _parse_statement to reference specification and namespaces.
        nanopub.metadata           = Metadata.new(hash[:metadata] || {})
        nanopub.references         = References.new(hash[:references] || {})
        nanopub.bel_statement      = hash[:bel_statement] || nil
        nanopub.citation           = Citation.new(hash[:citation] || {})
        nanopub.support.value      = hash[:support] || nil
        nanopub.experiment_context = ExperimentContext.new(hash[:experiment_context] || [])
        nanopub
      end

      def bel_statement
        @bel_statement
      end

      def bel_statement=(bel_statement)
        @bel_statement =
          case bel_statement
          when String
            _parse_statement(bel_statement)
          when BELParser::Expression::Model::Statement
            bel_statement
          when nil
            nil
          else
            raise ArgumentError, %(expected String, Statement, actual: #{bel_statement.class})
          end
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

      def _parse_statement(bel_statement)
        bel_version =
          metadata[:bel_version] || BELParser::Language.default_version
        spec = BELParser::Language.specification(bel_version)
        BELParser::Expression.parse_statements(
          bel_statement,
          spec,
          references.namespaces_hash
        )
      end
    end
  end
end
