$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib')
require 'bel'

describe BEL::Nanopub::Term do

  it "determines if it is valid" do
    expect(
      p(HGNC[:AKT1])
      .valid?
    ).to be(true)
    expect(
      tscript(p(HGNC[:AKT1]))
      .valid?
    ).to be(true)
  end

  it "determines if it is invalid" do
    expect(
      p(HGNC[:AGMX2])
      .valid?
    ).to be(false)
    expect(
      tscript(p(HGNC[:AGMX2]))
      .valid?
    ).to be(false)
  end
end
# vim: ts=2 sw=2:
