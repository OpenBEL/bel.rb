require 'bel/script.rb'

BEL_SCRIPT = <<-EOF
  SET DOCUMENT Name = "Spec"
  SET DOCUMENT Authors = User
  SET DOCUMENT ContactInfo = {"email(at)host(dot)com", "support(at)host(dot).com"}
  DEFINE NAMESPACE HGNC AS URL "http://resource.belframework.org/belframework/1.0/namespace/hgnc-approved-symbols.belns"
  DEFINE ANNOTATION Disease AS  URL "http://resource.belframework.org/belframework/1.0/annotation/mesh-disease.belanno"
  SET STATEMENT_GROUP = "Main"
    SET Disease = "Atherosclerosis"
    path(MESHD:Atherosclerosis)
    path(Atherosclerosis)
    bp(GO:"lipid oxidation")
    p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473))
    path(MESHD:Atherosclerosis) => bp(GO:"lipid oxidation")
    path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GO:"apoptotic process"))
  UNSET STATEMENT_GROUP
EOF

describe BEL::Script::Parser, "#parse" do
  it "returns array of parsed records" do
    records = BEL::Script::Parser.parse(BEL_SCRIPT)
    expect(records).to be
    expect(records).to be_instance_of(Array)
    expect(records.length).to eql(BEL_SCRIPT.count("\n"))
  end

  it "returns valid statements" do
    records = BEL::Script::Parser.parse(BEL_SCRIPT)
    stmts = records.find_all {|x| x.is_a? BEL::Script::StatementDefinition}
    expect(stmts.length).to be 6
    expect(stmts.count{|x| x.subject_only?}).to be 3
    expect(stmts.count{|x| x.simple?}).to be 2
    expect(stmts.count{|x| x.nested?}).to be 1
  end
end

describe BEL::Script::Parser, "#parse_record" do
  records = BEL::Script::Parser.parse(BEL_SCRIPT)
  it "can yield each record to the block" do
    BEL::Script::Parser.parse_record(BEL_SCRIPT) do |rec|
      expect(rec).to eql(records.shift)
    end
  end
end
