# vim: ts=2 sw=2:
require 'bel/script.rb'

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
bp(GOBP:"lipid oxidation")
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473)) //Comment2
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process")) //Comment3
EOF

describe BEL::Script::Parser, "#parse" do
  it "returns bel objects" do
    objects = []
    parser = BEL::Script::Parser.new
    parser.parse(BEL_SCRIPT) do |obj|
      objects << obj
    end
    expect(objects).to be
    expect(objects.length).to eql(40)
  end

  it "returns all types of statements" do
    objects = []
    parser = BEL::Script::Parser.new
    parser.parse(BEL_SCRIPT) do |obj|
      objects << obj
    end
    stmts = objects.find_all {|x| x.is_a? BEL::Language::Statement}
    expect(stmts.length).to be 6
    expect(stmts.count{|x| x.subject_only?}).to be 3
    expect(stmts.count{|x| x.simple?}).to be 2
    expect(stmts.count{|x| x.nested?}).to be 1
  end

  it "is observable" do
    objects = []
    class Observe
      attr_reader :objects
      def initialize(objects)
        @objects = objects
      end
      def update(obj)
        @objects << obj
      end
    end

    observer = Observe.new(objects)
    parser = BEL::Script::Parser.new
    parser.add_observer(observer)
    parser.parse(BEL_SCRIPT)

    expect(observer.objects.length).to be 40
  end
end
