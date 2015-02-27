# vim: ts=2 sw=2:
require 'bel'
require 'uuid'

include BEL::Language
include BEL::Namespace

describe 'RDF functionality of BEL language objects' do

  before(:all) do
    if not BEL::Features.rdf_support?
      fail RuntimeError, "RDF tests cannot run; install rdf requirements"
    end
  end

  describe NamespaceDefinition do

    it "provides a URI based on namespace name" do
      stable_prefix = 'http://www.openbel.org/bel/namespace/'
      expect(HGNC.to_uri).to eq(stable_prefix + 'hgnc-human-genes')
    end
  end

  describe Parameter do

    it "provides a URI consistent with Namespace URI" do
      value = 'AKT1'
      expect(
        Parameter.new(HGNC, value, 'GRP').to_uri
      ).to eq(
        HGNC.to_rdf_vocabulary[value]
      )
    end

    it "provides RDF statements for concept types based on encoding" do
      triples = Parameter.new(HGNC, 'AKT1', 'GRP').to_rdf
      expect(triples.size).to eq(3)
      expect(
        triples.find_all { |x|
          x.object.uri? and x.object.value == BEL::RDF::BELV.GeneConcept
        }.size
      ).to eq(1)
      expect(
        triples.find_all { |x|
          x.object.uri? and x.object.value == BEL::RDF::BELV.RNAConcept
        }.size
      ).to eq(1)
      expect(
        triples.find_all { |x|
          x.object.uri? and x.object.value == BEL::RDF::BELV.ProteinConcept
        }.size
      ).to eq(1)
    end
  end

  describe Term do

    it "provides RDF statements for Term instances" do
      term = p(Parameter.new(HGNC, 'AKT1', 'GRP'))

      (term_uri, rdf_statements) = term.to_rdf
      expect(term_uri).to eq(term.to_uri)
      expect(rdf_statements.size).to eq(4)
      expect(
        rdf_statements.include? [term.to_uri, BEL::RDF::RDF.type, BEL::RDF::BELV.Term]
      ).to be(true)
      expect(
        rdf_statements.include? [term.to_uri, BEL::RDF::RDF.type, term.rdf_type]
      ).to be(true)
      expect(
        rdf_statements.include? [term.to_uri, BEL::RDF::RDFS.label, term.to_s]
      ).to be(true)
      expect(
        rdf_statements.include? [term.to_uri, BEL::RDF::BELV.hasConcept, term.arguments[0].to_uri]
      ).to be(true)
    end
  end

  describe Statement do

    it "provides RDF statements for Statement instances" do
      statement = tscript(p(Parameter.new(HGNC, 'AKT1', 'GRP'))).increases bp(Parameter.new(GOBP, 'apoptotic process', 'B'))

      (uri, rdf_statements) = statement.to_rdf
      expect(uri).to eq(statement.to_uri)
      expect(rdf_statements.size).to eq(21)
    end

    it "reference a single Evidence identified by UUID blank node" do
      statement = kin(p(Parameter.new(SFAM, 'PRKC Family'))).increases cat(p(Parameter.new(SFAM, 'PLD Family')))
      (_, rdf_statements) = statement.to_rdf

      type_evidence_statements = rdf_statements.find_all { |stmt|
        stmt[1] == BEL::RDF::RDF.type and stmt[2] == BEL::RDF::BELV.Evidence
      }
      expect(type_evidence_statements.size).to eq(1)

      evidence_resource = type_evidence_statements.first[0]
      expect(evidence_resource).to be_a(BEL::RDF::RDF::Node)

      evidence_resource_identifier = evidence_resource.to_s.gsub(/^_:/, '')
      expect(UUID.validate(evidence_resource_identifier)).to be(true)
    end
  end
end
