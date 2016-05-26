require 'bel_parser/expression/model/namespace'

module BEL
  module Resources
    BASE_URL           = 'http://resource.belframework.org/belframework/latest-release'
    DEFAULT_NAMESPACES = {
      'AFFX' =>
        BELParser::Expression::Model::Namespace.new(
          'AFFX',
          'http://www.openbel.org/bel/namespace/affy-probeset',
          "#{BASE_URL}/namespace/affy-probeset-ids.belns"),
      'CHEBI' =>
        BELParser::Expression::Model::Namespace.new(
          'CHEBI',
          'http://www.openbel.org/bel/namespace/chebi',
          "#{BASE_URL}/namespace/chebi.belns"),
      'CHEBIID' =>
        BELParser::Expression::Model::Namespace.new(
          'CHEBIID',
          'http://www.openbel.org/bel/namespace/chebi',
          "#{BASE_URL}/namespace/chebi-ids.belns"),
      'DEFAULT' =>
        BELParser::Expression::Model::Namespace.new(
          'DEFAULT',
          'http://www.openbel.org/bel/namespace/default',
          "#{BASE_URL}/namespace/default-bel-namespace.belns"),
      'DO' =>
        BELParser::Expression::Model::Namespace.new(
          'DO',
          'http://www.openbel.org/bel/namespace/disease-ontology',
          "#{BASE_URL}/namespace/disease-ontology.belns"),
      'DOID' =>
        BELParser::Expression::Model::Namespace.new(
          'DOID',
          'http://www.openbel.org/bel/namespace/disease-ontology',
          "#{BASE_URL}/namespace/disease-ontology-ids.belns"),
      'EGID' =>
        BELParser::Expression::Model::Namespace.new(
          'EGID',
          'http://www.openbel.org/bel/namespace/entrez-gene',
          "#{BASE_URL}/namespace/entrez-gene-ids.belns"),
      'GOBP' =>
        BELParser::Expression::Model::Namespace.new(
          'GOBP',
          'http://www.openbel.org/bel/namespace/go-biological-process',
          "#{BASE_URL}/namespace/go-biological-process.belns"),
      'GOBPID' =>
        BELParser::Expression::Model::Namespace.new(
          'GOBPID',
          'http://www.openbel.org/bel/namespace/go-biological-process',
          "#{BASE_URL}/namespace/go-biological-process-ids.belns"),
      'GOCC' =>
        BELParser::Expression::Model::Namespace.new(
          'GOCC',
          'http://www.openbel.org/bel/namespace/go-cellular-component',
          "#{BASE_URL}/namespace/go-cellular-component.belns"),
      'GOCCID' =>
        BELParser::Expression::Model::Namespace.new(
          'GOCCID',
          'http://www.openbel.org/bel/namespace/go-cellular-component',
          "#{BASE_URL}/namespace/go-cellular-component-ids.belns"),
      'HGNC' =>
        BELParser::Expression::Model::Namespace.new(
          'HGNC',
          'http://www.openbel.org/bel/namespace/hgnc-human-genes',
          "#{BASE_URL}/namespace/hgnc-human-genes.belns"),
      'MESHCS' =>
        BELParser::Expression::Model::Namespace.new(
          'MESHCS',
          'http://www.openbel.org/bel/namespace/mesh-cellular-structures',
          "#{BASE_URL}/namespace/mesh-cellular-structures.belns"),
      'MESHCSID' =>
        BELParser::Expression::Model::Namespace.new(
          'MESHCSID',
          'http://www.openbel.org/bel/namespace/mesh-cellular-structures',
          "#{BASE_URL}/namespace/mesh-cellular-structures-ids.belns"),
      'MESHC' =>
        BELParser::Expression::Model::Namespace.new(
          'MESHC',
          'http://www.openbel.org/bel/namespace/mesh-chemicals',
          "#{BASE_URL}/namespace/mesh-chemicals.belns"),
      'MESHCID' =>
        BELParser::Expression::Model::Namespace.new(
          'MESHCID',
          'http://www.openbel.org/bel/namespace/mesh-chemicals',
          "#{BASE_URL}/namespace/mesh-chemicals-ids.belns"),
      'MESHD' =>
        BELParser::Expression::Model::Namespace.new(
          'MESHD',
          'http://www.openbel.org/bel/namespace/mesh-diseases',
          "#{BASE_URL}/namespace/mesh-diseases.belns"),
      'MESHDID' =>
        BELParser::Expression::Model::Namespace.new(
          'MESHDID',
          'http://www.openbel.org/bel/namespace/mesh-diseases',
          "#{BASE_URL}/namespace/mesh-diseases-ids.belns"),
      'MESHPP' =>
        BELParser::Expression::Model::Namespace.new(
          'MESHPP',
          'http://www.openbel.org/bel/namespace/mesh-processes',
          "#{BASE_URL}/namespace/mesh-processes.belns"),
      'MESHPPID' =>
        BELParser::Expression::Model::Namespace.new(
          'MESHPPID',
          'http://www.openbel.org/bel/namespace/mesh-processes',
          "#{BASE_URL}/namespace/mesh-processes-ids.belns"),
      'MGI' =>
        BELParser::Expression::Model::Namespace.new(
          'MGI',
          'http://www.openbel.org/bel/namespace/mgi-mouse-genes',
          "#{BASE_URL}/namespace/mgi-mouse-genes.belns"),
      'RGD' =>
        BELParser::Expression::Model::Namespace.new(
          'RGD',
          'http://www.openbel.org/bel/namespace/rgd-rat-genes',
          "#{BASE_URL}/namespace/rgd-rat-genes.belns"),
      'SCHEM' =>
        BELParser::Expression::Model::Namespace.new(
          'SCHEM',
          'http://www.openbel.org/bel/namespace/selventa-legacy-chemicals',
          "#{BASE_URL}/namespace/selventa-legacy-chemicals.belns"),
      'SCOMP' =>
        BELParser::Expression::Model::Namespace.new(
          'SCOMP',
          'http://www.openbel.org/bel/namespace/selventa-named-complexes',
          "#{BASE_URL}/namespace/selventa-named-complexes.belns"),
      'SDIS' =>
        BELParser::Expression::Model::Namespace.new(
          'SDIS',
          'http://www.openbel.org/bel/namespace/selventa-legacy-diseases',
          "#{BASE_URL}/namespace/selventa-legacy-diseases"),
      'SFAM' =>
        BELParser::Expression::Model::Namespace.new(
          'SFAM',
          'http://www.openbel.org/bel/namespace/selventa-protein-families',
          "#{BASE_URL}/namespace/selventa-protein-families.belns"),
      'SP' =>
        BELParser::Expression::Model::Namespace.new(
          'SP',
          'http://www.openbel.org/bel/namespace/swissprot',
          "#{BASE_URL}/namespace/swissprot.belns"),
      'SPID' =>
        BELParser::Expression::Model::Namespace.new(
          'SPID',
          'http://www.openbel.org/bel/namespace/swissprot',
          "#{BASE_URL}/namespace/swissprot-ids.belns"),
    }

    DEFAULT_ANNOTATIONS = {
      'Anatomy' =>
        BELParser::Expression::Model::Namespace.new(
          'Anatomy',
          'http://www.openbel.org/bel/namespace/uberon',
          "#{BASE_URL}/annotation/anatomy.belanno"),
      'Cell' =>
        BELParser::Expression::Model::Namespace.new(
          'Cell',
          'http://www.openbel.org/bel/namespace/cell-ontology',
          "#{BASE_URL}/annotation/cell.belanno"),
      'CellLine' =>
        BELParser::Expression::Model::Namespace.new(
          'CellLine',
          'http://www.openbel.org/bel/namespace/cell-line-ontology',
          "#{BASE_URL}/annotation/cell-line.belanno"),
      'Disease' =>
        BELParser::Expression::Model::Namespace.new(
          'Disease',
          'http://www.openbel.org/bel/namespace/disease-ontology',
          "#{BASE_URL}/annotation/disease.belanno"),
      'ExperimentalFactor' =>
        BELParser::Expression::Model::Namespace.new(
          'ExperimentalFactor',
          'http://www.openbel.org/bel/namespace/experimental-factor-ontology',
          "#{BASE_URL}/annotation/disease.belanno"),
      'MeSHAnatomy' =>
        BELParser::Expression::Model::Namespace.new(
          'MeSHAnatomy',
          'http://www.openbel.org/bel/namespace/mesh-anatomy',
          "#{BASE_URL}/annotation/mesh-anatomy.belanno"),
      'MeSHDisease' =>
        BELParser::Expression::Model::Namespace.new(
          'MeSHDisease',
          'http://www.openbel.org/bel/namespace/mesh-diseases',
          "#{BASE_URL}/annotation/mesh-diseases.belanno"),
      'Species' =>
        BELParser::Expression::Model::Namespace.new(
          'Species',
          'http://www.openbel.org/bel/namespace/ncbi-taxonomy',
          "#{BASE_URL}/annotation/species-taxonomy-id.belanno")
    }

    def self.included(another_class)
      DEFAULT_ANNOTATIONS.each do |keyword, annotation|
        another_class.const_set(keyword.to_sym, annotation)
      end
      DEFAULT_NAMESPACES.each do |keyword, namespace|
        another_class.const_set(keyword.to_sym, namespace)
      end
    end
  end
end
