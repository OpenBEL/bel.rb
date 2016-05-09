require 'bel'

include BEL::Language
include BEL::Namespace
include BEL::Nanopub

describe Parameter, "#to_s" do
  it "returns bel syntax without namespace" do
    p = Parameter.new(nil, 'AKT1')
    expect(p.to_s).to eql('AKT1')
  end

  it "returns bel syntax with namespace" do
    p = Parameter.new(HGNC, 'AKT1')
    expect(p.to_s).to eql('HGNC:AKT1')
  end

  it "returns quoted values when necessary" do
    p = Parameter.new(GOBP, 'apoptotic process')
    expect(p.to_s).to eql('GOBP:"apoptotic process"')
  end
end

describe Term, "#to_s" do
  it "returns short form bel syntax" do
    t = Term.new(:kin, [Term.new(:p, Parameter.new(SFAM, 'AKT Family'))])
    expect(t.to_s).to eql('kin(p(SFAM:"AKT Family"))')
  end
end

describe Statement, "#to_s" do
  it "returns short form bel syntax for subject-only statement" do
    s = Statement.new(
      Term.new(:kin, [Term.new(:p, Parameter.new(SFAM, 'AKT Family'))])
    )
    expect(s.to_s).to eql('kin(p(SFAM:"AKT Family"))')
  end

  it "returns short form bel syntax for simple statement" do
    s = Statement.new(
      Term.new(:kin, [Term.new(:p, Parameter.new(SFAM, 'AKT Family'))]),
      :increases,
      Term.new(:bp, Parameter.new(GOBP, 'apoptotic process'))
    )
    expect(s.to_s).to eql('kin(p(SFAM:"AKT Family")) increases bp(GOBP:"apoptotic process")')
  end

  it "returns short form bel syntax for nested statement" do
    s = Statement.new(
      Term.new(:kin, [Term.new(:p, Parameter.new(HGNC, 'AKT1'))]),
      :increases,
      Statement.new(
        Term.new(:a, Parameter.new(CHEBI, 'phorbol 13-acetate 12-myristate')),
        :increases,
        Term.new(:p, Parameter.new(HGNC, 'DUSP1'))
      )
    )
    expect(s.to_s).to eql('kin(p(HGNC:AKT1)) increases (a(CHEBI:"phorbol 13-acetate 12-myristate") increases p(HGNC:DUSP1))')
  end
end

describe Annotation, "#to_s" do
  it "returns bel syntax" do
    annotation = Annotation.new('Cell', 'blastoconidium')
    expect(annotation.to_s).to eql('SET Cell = blastoconidium')
  end

  it "escapes quotes within a quoted value" do
    annotation = Annotation.new('Support', 'a "lung-specific" enolase')
    expect(annotation.to_s).to eql('SET Support = "a \"lung-specific\" enolase"')
  end

  it "returns quoted values when necessary" do
    annotation = Annotation.new('Cell', 'ear hair cell')
    expect(annotation.to_s).to eql('SET Cell = "ear hair cell"')

    annotation = Annotation.new('CellLine', 'SUM1315MO2')
    expect(annotation.to_s).to eql('SET CellLine = SUM1315MO2')
  end
end
# vim: ts=2 sw=2:
