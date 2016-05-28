require          'rdf'
require          'bel_parser/language/version2_0'
require          'bel_parser/quoting'
require_relative 'belv2_0'
require_relative 'rdf_converter'

module BEL
  module BELRDF
    class TermConverter
      include BELParser::Language::Version2_0::Functions
      include BELParser::Quoting
      include RDFConverter

      def initialize(parameter_converter)
        @parameter_converter = parameter_converter
      end

      # Convert a {BELParser::Expression::Model::Term} to {RDF::Graph} of
      # RDF statements.
      #
      # @param  [BELParser::Expression::Model::Term] term
      # @return [RDF::Graph] graph of RDF statements representing the term
      def convert(term)
        path_part     = to_path_part(term)
        term_uri      = to_uri(path_part)
        tg            = RDF::Graph.new
        tg           << s(term_uri, RDF.type, BELV2_0.Term)

        term_class = FUNCTION_HASH[term.function]
        if term_class
          tg << s(term_uri, RDF.type, term_class)
        end

        term.arguments.each do |arg|
          case arg
          when BELParser::Expression::Model::Parameter
            param_uri, paramg = @parameter_converter.convert(arg)
            if param_uri
              tg << paramg
              tg << s(term_uri, BELV2_0.hasConcept, param_uri)
            end
          when BELParser::Expression::Model::Term
            if FUNCTION_HASH.key?(arg.function)
              path_part, iterm_uri, itermg = convert(arg)
              tg << itermg
              tg << s(term_uri, BELV2_0.hasChild, iterm_uri)
            end
            handle_special_inner(term, term_uri, arg, tg)
          end
        end

        [path_part, term_uri, tg]
      end

      private

      def handle_special_inner(outer_term, outer_uri, inner_term, tg)
        inner_function = inner_term.function
        case
        when inner_function.return_type.subtype_of?(BELParser::Language::Version2_0::ReturnTypes::Abundance)
          handle_activity_abundance(outer_term, outer_uri, inner_term, tg)
        when inner_function == Fragment
          handle_fragment(outer_term, outer_uri, inner_term, tg)
        when inner_function == FromLocation
          handle_from_location(outer_term, outer_uri, inner_term, tg)
        when inner_function == Location
          handle_location(outer_term, outer_uri, inner_term, tg)
        when inner_function == MolecularActivity
          handle_molecular_activity(outer_term, outer_uri, inner_term, tg)
        when inner_function == Products
          handle_products(outer_term, outer_uri, inner_term, tg)
        when inner_function == ProteinModification
          handle_pmod(outer_term, outer_uri, inner_term, tg)
        when inner_function == Reactants
          handle_reactants(outer_term, outer_uri, inner_term, tg)
        when inner_function == ToLocation
          handle_to_location(outer_term, outer_uri, inner_term, tg)
        when inner_function == Variant
          handle_variant(outer_term, outer_uri, inner_term, tg)
        end
      end

      def handle_activity_abundance(outer_term, outer_uri, inner_term, tg)
        if outer_term.function == Activity
          _, inner_uri, _ = convert(inner_term)
          tg << s(outer_uri, BELV2_0.hasActivityAbundance, inner_uri)
        end
      end

      def handle_fragment(outer_term, outer_uri, inner_term, tg)
        if outer_term.function == ProteinAbundance
          frag_range, frag_desc = inner_term.arguments
          if frag_range.is_a?(BELParser::Expression::Model::Parameter)
            tg << s(outer_uri, BELV2_0.hasFragmentRange, unquote(frag_range.to_s))
          end
          if frag_desc.is_a?(BELParser::Expression::Model::Parameter)
            tg << s(outer_uri, BELV2_0.hasFragmentDescriptor, unquote(frag_desc.to_s))
          end
        end
      end

      def handle_location(outer_term, outer_uri, inner_term, tg)
        match = LOCATION_ABUNDANCES.any? { |f| outer_term.function == f}
        if match
          location = inner_term.arguments[0]
          if location.is_a?(BELParser::Expression::Model::Parameter)
            param_uri, paramg = @parameter_converter.convert(location)
            if param_uri
              tg << paramg
              tg << s(outer_uri, BELV2_0.hasLocation, param_uri)
            end
          end
        end
      end

      def handle_from_location(outer_term, outer_uri, inner_term, tg)
        if outer_term.function == Translocation
          location = inner_term.arguments[0]
          if location.is_a?(BELParser::Expression::Model::Parameter)
            param_uri, paramg = @parameter_converter.convert(location)
            if param_uri
              tg << paramg
              tg << s(outer_uri, BELV2_0.hasFromLocation, param_uri)
            end
          end
        end
      end

      def handle_to_location(outer_term, outer_uri, inner_term, tg)
        if outer_term.function == Translocation
          location = inner_term.arguments[0]
          if location.is_a?(BELParser::Expression::Model::Parameter)
            param_uri, paramg = @parameter_converter.convert(location)
            if param_uri
              tg << paramg
              tg << s(outer_uri, BELV2_0.hasToLocation, param_uri)
            end
          end
        end
      end

      def handle_molecular_activity(outer_term, outer_uri, inner_term, tg)
        if outer_term.function == Activity
          ma, _ = inner_term.arguments
          if ma.is_a?(BELParser::Expression::Model::Parameter)
            param_uri, paramg = @parameter_converter.convert(ma)
            if param_uri
              tg << paramg
              tg << s(outer_uri, BELV2_0.hasActivityType, param_uri)
            end
          end
        end
      end

      def handle_products(outer_term, outer_uri, inner_term, tg)
        if outer_term.function == Reaction
          inner_term.arguments.each do |arg|
            if arg.is_a?(BELParser::Expression::Model::Term)
              _, inner_uri, _ = convert(arg)
              tg << s(outer_uri, BELV2_0.hasProduct, inner_uri)
            end
          end
        end
      end

      def handle_reactants(outer_term, outer_uri, inner_term, tg)
        if outer_term.function == Reaction
          inner_term.arguments.each do |arg|
            if arg.is_a?(BELParser::Expression::Model::Term)
              _, inner_uri, _ = convert(arg)
              tg << s(outer_uri, BELV2_0.hasReactant, inner_uri)
            end
          end
        end
      end

      def handle_pmod(outer_term, outer_uri, inner_term, tg)
        if outer_term.function == ProteinAbundance
          tg << s(outer_uri, RDF.type, BELV2_0.ModifiedProteinAbundance)
          tg << s(outer_uri, BELV2_0.hasModifiedProteinAbundance, outer_uri)

          mod_protein_uri = BELR[URI::encode(to_path_part(inner_term))]
          tg << s(outer_uri, BELV2_0.hasProteinModification, mod_protein_uri)

          modtype, amino_acid, residue = inner_term.arguments
          if modtype && modtype.is_a?(BELParser::Expression::Model::Parameter)
            param_uri, paramg = @parameter_converter.convert(modtype)
            if param_uri
              tg << paramg
              tg << s(mod_protein_uri, BELV2_0.hasProteinModificationType, param_uri)
            end
          end

          if amino_acid && amino_acid.is_a?(BELParser::Expression::Model::Parameter)
            tg << s(mod_protein_uri, BELV2_0.hasAminoAcid, unquote(amino_acid.to_s))
          end

          if residue && residue.is_a?(BELParser::Expression::Model::Parameter)
            tg << s(mod_protein_uri, BELV2_0.hasProteinResidue, residue.to_s.to_i)
          end
        end
      end

      def handle_variant(outer_term, outer_uri, inner_term, tg)
        match = VARIANT_ABUNDANCES.any? { |f| outer_term.function == f}
        if match
          hgvs_descriptor, _ = inner_term.arguments
          if hgvs_descriptor.is_a?(BELParser::Expression::Model::Parameter)
            tg << s(outer_uri, BELV2_0.hasVariant, unquote(hgvs_descriptor.to_s))
          end
        end
      end

      def to_path_part(term)
        return '' if term.nil?
        term
          .to_s
          .squeeze(')')
          .gsub(/[")\[\]]/, '')
          .gsub(/[(:, ]/, '_')
      end

      def to_uri(path_part)
        BELR[URI::encode(path_part)]
      end

      FUNCTION_HASH = {
        Abundance => BELV2_0.Abundance,
        Activity  => BELV2_0.Activity,
        BiologicalProcess => BELV2_0.BiologicalProcess,
        CellSecretion => BELV2_0.CellSecretion,
        CellSurfaceExpression => BELV2_0.CellSurfaceExpression,
        ComplexAbundance => BELV2_0.ComplexAbundance,
        CompositeAbundance => BELV2_0.CompositeAbundance,
        Degradation => BELV2_0.Degradation,
        Fusion => BELV2_0.FusionAbundance,
        GeneAbundance => BELV2_0.GeneAbundance,
        MicroRNAAbundance => BELV2_0.MicroRNAAbundance,
        Pathology => BELV2_0.Pathology,
        ProteinAbundance => BELV2_0.ProteinAbundance,
        Reaction => BELV2_0.Reaction,
        RNAAbundance => BELV2_0.RNAAbundance,
        Translocation => BELV2_0.Translocation
      }.freeze

      LOCATION_ABUNDANCES = [
        ComplexAbundance,
        GeneAbundance,
        MicroRNAAbundance,
        ProteinAbundance,
        RNAAbundance
      ]

      VARIANT_ABUNDANCES = [
        GeneAbundance,
        MicroRNAAbundance,
        ProteinAbundance,
        RNAAbundance
      ]
    end
  end
end
