require_relative 'uuid'
require_relative 'rdf_converter'

module BEL
  module BELRDF
    class NanopubConverter
      include RDFConverter

      def initialize(statement_converter)
        @statement_converter = statement_converter
      end

      # Convert a {BEL::Nanopub::Nanopub} to {RDF::Graph} of RDF statements.
      #
      # @param  [BEL::Nanopub::Nanopub] nanopub
      # @return [RDF::Graph] graph of RDF statements representing the nanopub
      def convert(nanopub)
        resource         = generate_nanopub_uri
        graph            = RDF::Graph.new
        graph           << s(resource, RDF.type, BELV2_0.Nanopub)

        bel_statement(nanopub.bel_statement, resource, graph)
        citation(nanopub.citation, resource, graph)
        support(nanopub.support, resource, graph)
        experiment_context(nanopub.experiment_context, resource, graph)
        references(nanopub.references, resource, graph)
        metadata(nanopub.metadata, resource, graph)

        graph
      end

      protected

      def bel_statement(statement, nr, ng)
        path_part, stmt_uri, sg = @statement_converter.convert(statement)
        ng << sg
        ng << s(nr, BELV2_0.hasStatement, stmt_uri)
      end

      def citation(citation, nr, ng)
        type = citation.type
        if type && (type.to_s.downcase == 'pubmed')
          ng << s(nr, BELV2_0.hasCitation, PUBMED[citation.id.to_s])
        end
      end

      def support(support, nr, ng)
        unless support.value.nil?
          ng << s(nr, BELV2_0.hasSupport, support.to_s)
        end
      end

      def experiment_context(experiment_context, nr, ng)
      end

      def references(references, nr, ng)
      end

      def metadata(metadata, nr, ng)
        v = metadata.bel_version
        bel_version(v, nr, ng) if v
      end

      def bel_version(bel_version, nr, ng)
        spec = BELParser::Language.specification(bel_version) rescue nil
        return unless spec

        bel = RDF::URI(spec.uri)
        ng << s(bel, RDF.type, BELV2_0.BiologicalExpressionLanguage)
        ng << s(bel, BELV2_0.hasVersion, spec.version.to_s)
        ng << s(nr, BELV2_0.hasBiologicalExpressionLanguage, bel)
      end

      private

      # @api private
      def generate_nanopub_uri
        BELN[BELRDF.generate_uuid]
      end
    end
  end
end
