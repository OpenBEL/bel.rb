# vim: ts=2 sw=2:
require 'bel/script.rb'

describe BEL::Language::Parameter, "#to_s" do
  it "returns bel syntax without namespace" do
    p = BEL::Language::Parameter.new(nil, 'AKT1')
    expect(p.to_s).to eql('AKT1')
  end

  it "returns bel syntax with namespace" do
    p = BEL::Language::Parameter.new('HGNC', 'AKT1')
    expect(p.to_s).to eql('HGNC:AKT1')
  end

  it "returns quoted values when necessary" do
    p = BEL::Language::Parameter.new('GO', 'apoptotic process')
    expect(p.to_s).to eql('GO:"apoptotic process"')
  end
end

describe BEL::Language::Term, "#to_s" do
  it "returns short form bel syntax" do
    t = BEL::Language::Term.new(
      :kin,
      [
        BEL::Language::Term.new(
          :p,
          BEL::Language::Parameter.new('SFAM', 'AKT Family')
        )
      ]
    )
    expect(t.to_s).to eql('kin(p(SFAM:"AKT Family"))')
  end
end

describe BEL::Language::Statement, "#to_s" do
  it "returns short form bel syntax for subject-only statement" do
    s = BEL::Language::Statement.new(
      BEL::Language::Term.new(
        :kin,
        [
          BEL::Language::Term.new(
            :p,
            BEL::Language::Parameter.new('SFAM', 'AKT Family')
          )
        ]
      )
    )
    expect(s.to_s).to eql('kin(p(SFAM:"AKT Family"))')
  end

  it "returns short form bel syntax for simple statement" do
    s = BEL::Language::Statement.new(
      BEL::Language::Term.new(
        :kin,
        [
          BEL::Language::Term.new(
            :p,
            BEL::Language::Parameter.new('SFAM', 'AKT Family')
          )
        ]
      ), :increases,
      BEL::Language::Term.new(
        :bp,
        BEL::Language::Parameter.new('GO', 'apoptotic process')
      )
    )
    expect(s.to_s).to eql('kin(p(SFAM:"AKT Family")) increases bp(GO:"apoptotic process")')
  end

  it "returns short form bel syntax for nested statement" do
    s = BEL::Language::Statement.new(
      BEL::Language::Term.new(
        :kin,
        [
          BEL::Language::Term.new(
            :p,
            BEL::Language::Parameter.new('HGNC', 'AKT1')
          )
        ]
      ), :increases,
      BEL::Language::Statement.new(
        BEL::Language::Term.new(
          :a,
          BEL::Language::Parameter.new('CHEBI', 'phorbol 13-acetate 12-myristate')
        ),
        :increases,
        BEL::Language::Term.new(
          :p,
          BEL::Language::Parameter.new('HGNC', 'DUSP1')
        )
      )
    )
    expect(s.to_s).to eql('kin(p(HGNC:AKT1)) increases (a(CHEBI:"phorbol 13-acetate 12-myristate") increases p(HGNC:DUSP1))')
  end
end
