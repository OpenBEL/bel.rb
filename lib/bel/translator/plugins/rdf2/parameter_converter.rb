require          'rdf'
require_relative 'rdf_converter'
require_relative 'belv2_0'

module BEL
  module BELRDF
    class ParameterConverter
      include RDFConverter

      def initialize(namespace_converter)
        @namespace_converter = namespace_converter
      end
      # Convert a {BELParser::Expression::Model::Parameter} to {RDF::Graph} of
      # RDF statements.
      #
      # @param  [BELParser::Expression::Model::Parameter] parameter
      # @return [RDF::Graph] graph of RDF statements representing the parameter
      def convert(parameter)
        namespace_vocab = @namespace_converter.convert(parameter.namespace)
        return nil unless namespace_vocab

        value_s       = parameter.value.to_s
        param_uri     = namespace_vocab[value_s]
        pg            = RDF::Graph.new
        if parameter.encoding
          parameter.encoding.each do |enc|
            concept_type = ENCODING_HASH[enc]
            next unless concept_type
            pg << s(param_uri, RDF.type, concept_type)
          end
        end
        [param_uri, pg]
      end

      ENCODING_HASH = {
        :A => BELV2_0.AbundanceConcept,
        :B => BELV2_0.BiologicalProcessConcept,
        :C => BELV2_0.ComplexConcept,
        :E => BELV2_0.ProteinModificationConcept,
        :G => BELV2_0.GeneConcept,
        :L => BELV2_0.LocationConcept,
        :M => BELV2_0.MicroRNAConcept,
        :O => BELV2_0.PathologyConcept,
        :P => BELV2_0.ProteinConcept,
        :R => BELV2_0.RNAConcept,
        :T => BELV2_0.MolecularActivityConcept
      }.freeze
    end
  end
end
