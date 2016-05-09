require 'bel/script.rb'
require 'pathname'

BEL_SCRIPT = <<-EOF
SET DOCUMENT Name = "Spec"
SET DOCUMENT Authors = User
DEFINE NAMESPACE GOBP AS URL "http://resource.belframework.org/belframework/20131211/namespace/go-biological-process.belns"
DEFINE NAMESPACE HGNC AS URL "http://resource.belframework.org/belframework/20131211/namespace/hgnc-human-genes.belns"
DEFINE NAMESPACE MESHD AS URL "http://resource.belframework.org/belframework/20131211/namespace/mesh-diseases.belns"
DEFINE NAMESPACE MGI AS URL "http://resource.belframework.org/belframework/20131211/namespace/mgi-mouse-genes.belns"
DEFINE ANNOTATION Disease AS  URL "http://resource.belframework.org/belframework/1.0/annotation/mesh-disease.belanno"
DEFINE ANNOTATION Dosage AS PATTERN "[0-9]\.[0-9]+"
DEFINE ANNOTATION TextLocation AS  LIST {"Abstract","Results","Legend","Review"}
SET Disease = "Atherosclerosis"
path(MESHD:Atherosclerosis) //Comment1
path(Atherosclerosis)
UNSET Disease
bp(GOBP:"lipid oxidation")
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473)) //Comment2
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process")) //Comment3
EOF

describe BEL::Script, "#parse" do
  it "can return all parsed objects" do
    objects = BEL::Script.parse(BEL_SCRIPT).to_a
    expect(objects).to be
    expect(objects.length).to eql(41)
  end

  it "can parse spaces and tabs" do
    objects = BEL::Script.parse(
<<-EOF
DEFINE NAMESPACE\tGOBP\tAS URL\t\t"http://resource.belframework.org/belframework/20131211/namespace/go-biological-process.belns"
DEFINE NAMESPACE\tHGNC\tAS URL\t\t"http://resource.belframework.org/belframework/20131211/namespace/hgnc-human-genes.belns"
p(HGNC:AKT1)  \t\t  =>  \t\t  bp(GOBP:"apoptotic process")
EOF
).to_a
    expect(objects).to be
    expect(objects.length).to eql(7)
  end

  it "support flexible spacing around relationship" do
    [
      'p(A)->p(B)',
      'p(A) ->p(B)',
      'p(A)-> p(B)',
      'p(A) -> p(B)',
      "p(A)\t->\tp(B)",
      "p(A)  \t  ->  \t  p(B)"
    ].each do |bel_expression|
      statement_obj = BEL::Script.parse(bel_expression).to_a.last
      expect(statement_obj.to_s).to eql('p(A) -> p(B)')
    end
  end

  it "is enumerable" do
    statements = BEL::Script.parse(BEL_SCRIPT).find_all { |x|
      x.is_a? BEL::Nanopub::Statement
    }.to_a
    expect(statements.length).to be 6
    expect(statements.count{|x| x.subject_only?}).to be 3
    expect(statements.count{|x| x.simple?}).to be 2
    expect(statements.count{|x| x.nested?}).to be 1
  end

  it "can be called with a block" do
    objects = []
    BEL::Script.parse(BEL_SCRIPT) do |obj|
      objects << obj
    end
    expect(objects.length).to be 41
  end

  it "can handle file-like objects" do
    bel_file = Pathname(File.dirname(__FILE__)) + 'bel' + 'small_corpus.bel'
    parser = BEL::Script.parse(File.open(bel_file))
    expect(parser).to respond_to :each
  end

  it "should fail when content parameter type is not supported" do
    expect { BEL::Script.parse(3) }.to raise_error(ArgumentError)
  end
end
# vim: ts=2 sw=2:
