# vim: ts=2 sw=2:
require 'bel/script.rb'

describe BEL::Script::Parameter, "#to_s" do
  it "returns bel syntax without namespace" do
    p = BEL::Script::Parameter.new(nil, 'AKT1')
    expect(p.to_s).to eql('AKT1')
  end

  it "returns bel syntax with namespace" do
    p = BEL::Script::Parameter.new('HGNC', 'AKT1')
    expect(p.to_s).to eql('HGNC:AKT1')
  end

  it "returns quoted values when necessary" do
    p = BEL::Script::Parameter.new('GO', 'apoptotic process')
    expect(p.to_s).to eql('GO:"apoptotic process"')
  end
end

describe BEL::Script::Term, "#to_s" do
  it "returns short form bel syntax" do
    t = BEL::Script::Term.new(
      :kin,
      [
        BEL::Script::Term.new(
          :p,
          BEL::Script::Parameter.new('SFAM', 'AKT Family')
        )
      ]
    )
    expect(t.to_s).to eql('kin(p(SFAM:"AKT Family"))')
  end
end

describe BEL::Script::Statement, "#to_s" do
  it "returns short form bel syntax for subject-only statement" do
    s = BEL::Script::Statement.new(
      BEL::Script::Term.new(
        :kin,
        [
          BEL::Script::Term.new(
            :p,
            BEL::Script::Parameter.new('SFAM', 'AKT Family')
          )
        ]
      )
    )
    expect(s.to_s).to eql('kin(p(SFAM:"AKT Family"))')
  end

  it "returns short form bel syntax for simple statement" do
    s = BEL::Script::Statement.new(
      BEL::Script::Term.new(
        :kin,
        [
          BEL::Script::Term.new(
            :p,
            BEL::Script::Parameter.new('SFAM', 'AKT Family')
          )
        ]
      ), :increases,
      BEL::Script::Term.new(
        :bp,
        BEL::Script::Parameter.new('GO', 'apoptotic process')
      )
    )
    expect(s.to_s).to eql('kin(p(SFAM:"AKT Family")) increases bp(GO:"apoptotic process")')
  end

  it "returns short form bel syntax for nested statement" do
    s = BEL::Script::Statement.new(
      BEL::Script::Term.new(
        :kin,
        [
          BEL::Script::Term.new(
            :p,
            BEL::Script::Parameter.new('HGNC', 'AKT1')
          )
        ]
      ), :increases,
      BEL::Script::Statement.new(
        BEL::Script::Term.new(
          :a,
          BEL::Script::Parameter.new('CHEBI', 'phorbol 13-acetate 12-myristate')
        ),
        :increases,
        BEL::Script::Term.new(
          :p,
          BEL::Script::Parameter.new('HGNC', 'DUSP1')
        )
      )
    )
    expect(s.to_s).to eql('kin(p(HGNC:AKT1)) increases (a(CHEBI:"phorbol 13-acetate 12-myristate") increases p(HGNC:DUSP1))')
  end
end
