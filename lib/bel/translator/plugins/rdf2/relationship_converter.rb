require          'rdf'
require          'bel_parser/language/version2_0'
require_relative 'rdf_converter'

module BEL
  module BELRDF
    class RelationshipConverter
      include BELParser::Language::Version2_0::Relationships
      include RDFConverter

      # Convert a version 2.0 {BELParser::Language::Relationship}
      # to RDF statements.
      #
      # @param  [BELParser::Language::Relationship] relationship
      # @return [RDF::Graph] graph of RDF statements representing the relationship
      def convert(relationship)
        return nil if relationship.nil?
        [relationship.long.to_s, RELATIONSHIP_HASH[relationship]]
      end

      RELATIONSHIP_HASH = {
        Analogous => BELV2_0.Analogous,
        Association => BELV2_0.Association,
        BiomarkerFor => BELV2_0.BiomarkerFor,
        CausesNoChange => BELV2_0.CausesNoChange,
        Decreases => BELV2_0.Decreases,
        DirectlyDecreases => BELV2_0.DirectlyDecreases,
        DirectlyIncreases => BELV2_0.DirectlyIncreases,
        HasComponent => BELV2_0.HasComponent,
        HasMember => BELV2_0.HasMember,
        Increases => BELV2_0.Increases,
        IsA => BELV2_0.IsA,
        NegativeCorrelation => BELV2_0.NegativeCorrelation,
        Orthologous => BELV2_0.Orthologous,
        PositiveCorrelation => BELV2_0.PositiveCorrelation,
        PrognosticBiomarkerFor => BELV2_0.PrognosticBiomarkerFor,
        RateLimitingStepOf => BELV2_0.RateLimitingStepOf,
        Regulates => BELV2_0.Regulates,
        SubProcessOf => BELV2_0.SubProcessOf,
        TranscribedTo => BELV2_0.TranscribedTo,
        TranslatedTo => BELV2_0.TranslatedTo
      }.freeze
      # Special
        # HasMembers
        # HasComponents
    end
  end
end

