$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib')
require 'bel'
require 'uuid'

# Preload translator to load BELV objects
BEL.translator(:ntriples)

include BEL::Language
BEL::Language.include_bel_dsl

include BEL::Nanopub
include BEL::Namespace

BELV = BELRDF::BELV

describe 'RDF functionality of BEL language objects' do

  before(:all) do
    begin
      BEL.translator(:ntriples)
    rescue LoadError => e
      raise
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
      _, triples = Parameter.new(HGNC, 'AKT1', 'GRP').to_rdf
      expect(triples.size).to eq(4)
      expect(
        triples.count { |x|
          x.object.uri? and x.object.value == BELV.AbundanceConcept
        }).to eq(1)
      expect(
        triples.count { |x|
          x.object.uri? and x.object.value == BELV.GeneConcept
        }).to eq(1)
      expect(
        triples.count { |x|
          x.object.uri? and x.object.value == BELV.RNAConcept
        }).to eq(1)
      expect(
        triples.count { |x|
          x.object.uri? and x.object.value == BELV.ProteinConcept
        }).to eq(1)
    end

    it "URL-encodes UTF-8 concepts" do
      uri = Parameter.new(CHEBI, '5α-androst-16-en-3-one').to_uri
      expect(uri.to_s).to include("%CE%B1")
    end
  end

  describe Term do

    it "provides RDF statements for Term instances" do
      term = p(Parameter.new(HGNC, 'AKT1', 'GRP'))

      (term_uri, rdf_statements) = term.to_rdf
      expect(term_uri).to eq(term.to_uri)
      expect(rdf_statements.size).to eq(8)
      expect(
        rdf_statements.include? [term.to_uri, RDF.type, BELV.Term]
      ).to be(true)
      expect(
        rdf_statements.include? [term.to_uri, RDF.type, term.rdf_type]
      ).to be(true)
      expect(
        rdf_statements.include? [term.to_uri, RDF::RDFS.label, term.to_s]
      ).to be(true)
      expect(
        rdf_statements.include? [term.to_uri, BELV.hasConcept, term.arguments[0].to_uri]
      ).to be(true)
    end

    it "forces term labels as UTF-8" do
      (_, rdf_statements) = a(Parameter.new(CHEBI, '5α-androst-16-en-3-one')).to_rdf
      _, _, label_literal = rdf_statements.find { |stmt|
        stmt[1] == RDF::RDFS.label
      }

      expect(label_literal.value.encoding).to eql(Encoding::UTF_8)
      expect(label_literal).to                eql(RDF::Literal.new(%Q{a(CHEBI:"5α-androst-16-en-3-one")}))
    end
  end

  describe Statement do

    it "provides RDF statements for Statement instances" do
      statement = tscript(p(Parameter.new(HGNC, 'AKT1', 'GRP'))).increases bp(Parameter.new(GOBP, 'apoptotic process', 'B'))

      (uri, rdf_statements) = statement.to_rdf
      expect(uri).to eq(statement.to_uri)
      expect(rdf_statements.size).to eq(27)
    end

    it "reference a single Nanopub identified by UUID blank node" do
      statement = kin(p(Parameter.new(SFAM, 'PRKC Family'))).increases cat(p(Parameter.new(SFAM, 'PLD Family')))
      (_, rdf_statements) = statement.to_rdf

      type_nanopub_statements = rdf_statements.find_all { |stmt|
        stmt[1] == RDF.type and stmt[2] == BELV.Nanopub
      }
      expect(type_nanopub_statements.size).to eq(1)

      nanopub_resource = type_nanopub_statements.first[0]
      expect(nanopub_resource).to be_a(RDF::URI)
    end

    it "forces statement labels as UTF-8" do
      (_, rdf_statements) =
        (a(Parameter.new(CHEBI, '5α-androst-16-en-3-one')).association a(Parameter.new(CHEBI, 'luteolin 7-O-β-D-glucosiduronate'))).to_rdf
      _, _, label_literal = rdf_statements.select { |stmt|
        stmt[1] == RDF::RDFS.label
      }.last

      expect(label_literal.value.encoding).to eql(Encoding::UTF_8)
      expect(label_literal).to                eql(RDF::Literal.new(%Q{a(CHEBI:"5α-androst-16-en-3-one") association a(CHEBI:"luteolin 7-O-β-D-glucosiduronate")}))
    end

    it "forces nanopub text as UTF-8" do
      SUPPORT_TEST = '''
        SET Support = "Contains UTF-8 ... 84±3 55±7% α O-β-D γ κ"
        a(SCHEM:Sorbitol) -> kin(p(RGD:Mapk8))
        SET Support = "Plain text ASCII."
        a(SCHEM:"Prostaglandin F1") -| bp(MESHPP:Apoptosis)
      '''.gsub(%r{^\s*}, '')

      BEL::Script.parse(SUPPORT_TEST).select { |obj|
        obj.is_a? Statement
      }.each do |stmt|
        expect(stmt.annotations).to include('Support')
        nanopub = stmt.annotations['Support']
        expect(nanopub.value.encoding).to eql(Encoding::UTF_8)
      end
    end
  end
end
# vim: ts=2 sw=2:
