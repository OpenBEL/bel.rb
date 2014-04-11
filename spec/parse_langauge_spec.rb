# vim: ts=2 sw=2:
require 'bel/script.rb'

describe BEL::Script::Parser, "#parse" do
  it "understands empty lines and document comments" do
    parser = BEL::Script::Parser.new
    objects = []

    parser.parse("####\n\nSET Reviewed = True\n") do |obj|
      objects << obj
    end
    expect(objects).to be
    expect(objects.length).to eql(3)
    expect(objects[0].class).to eql(BEL::Language::Comment)
    expect(objects[1].class).to eql(BEL::Language::Newline)
    expect(objects[2].class).to eql(BEL::Language::Annotation)
  end

  ['Name', 'Description', 'Version', 'Copyright',
   'Authors', 'Licenses', 'ContactInfo'].each do |property|
    it "understands the document header for #{property} (SET DOCUMENT)" do
      parser = BEL::Script::Parser.new

      objects = []
      parser.parse(%Q{SET DOCUMENT #{property} = "Test"\n}) do |obj|
        objects << obj
      end
      expect(objects).to be
      expect(objects.length).to eql(1)
    end
  end

  it "provides name/value for document headers" do
    parser = BEL::Script::Parser.new

    ['Name', 'Description', 'Version', 'Copyright',
     'Authors', 'Licenses', 'ContactInfo'].each do |property|
      parser.parse(%Q{SET DOCUMENT #{property} = "Test"\n}) do |obj|
        expect(obj).to respond_to(:name)
        expect(obj).to respond_to(:value)
      end
    end
  end

  it "understands annotation definitions (DEFINE ANNOTATION)" do
    parser = BEL::Script::Parser.new
    objects = []

    define = %Q{DEFINE ANNOTATION Disease AS  URL "http://site/f.belanno"
DEFINE ANNOTATION Dosage AS PATTERN "[0-9]\.[0-9]+"
DEFINE ANNOTATION TextLocation AS  LIST {"Abstract","Results","Legend","Review"}\n}

    parser.parse(define) do |obj|
      objects << obj
    end
    expect(objects).to be
    expect(objects.length).to eql(3)
  end

  it "provides prefix/value for annotation definitions" do
    parser = BEL::Script::Parser.new

    define = %Q{DEFINE ANNOTATION Disease AS  URL "http://site/f.belanno"
DEFINE ANNOTATION Dosage AS PATTERN "[0-9]\.[0-9]+"
DEFINE ANNOTATION TextLocation AS  LIST {"Abstract","Results","Legend","Review"}\n}

    parser.parse(define) do |obj|
      expect(obj).to respond_to(:prefix)
      expect(obj).to respond_to(:value)
    end
  end

  it "understands namespace definitions (DEFINE NAMESPACE)" do
    parser = BEL::Script::Parser.new
    objects = []

    define = %Q{DEFINE NAMESPACE GOBP AS URL "http://resource.belframework.org/belframework/20131211/namespace/go-biological-process.belns"
DEFINE NAMESPACE HGNC AS URL "http://resource.belframework.org/belframework/20131211/namespace/hgnc-human-genes.belns"
DEFINE NAMESPACE MESHD AS URL "http://resource.belframework.org/belframework/20131211/namespace/mesh-diseases.belns"
DEFINE NAMESPACE MGI AS URL "http://resource.belframework.org/belframework/20131211/namespace/mgi-mouse-genes.belns"\n}

    parser.parse(define) do |obj|
      objects << obj
    end
    expect(objects).to be
    expect(objects.length).to eql(4)
  end

  it "provides prefix/value for namespace definitions" do
    parser = BEL::Script::Parser.new

    define = %Q{DEFINE NAMESPACE GOBP AS URL "http://resource.belframework.org/belframework/20131211/namespace/go-biological-process.belns"
DEFINE NAMESPACE HGNC AS URL "http://resource.belframework.org/belframework/20131211/namespace/hgnc-human-genes.belns"
DEFINE NAMESPACE MESHD AS URL "http://resource.belframework.org/belframework/20131211/namespace/mesh-diseases.belns"
DEFINE NAMESPACE MGI AS URL "http://resource.belframework.org/belframework/20131211/namespace/mgi-mouse-genes.belns"\n}

    parser.parse(define) do |obj|
      expect(obj).to respond_to(:prefix)
      expect(obj).to respond_to(:value)
    end
  end

  it "understands annotations (SET)" do
    parser = BEL::Script::Parser.new
    objects = []

    annotations = %Q{SET Disease = Atherosclerosis
SET Cell = "Endothelial Cells"
SET Citation = {"PubMed","The Biochemical journal","12444918","","Houslay MD|Adams DR",""}
SET Tissue = {"Endothelium, Vascular","vascular tissue"}
SET Species = 9606
SET Evidence = "Arterial cells are highly susceptible to oxidative stress, which can induce both necrosis
and apoptosis (programmed cell death) [1,2]"\n}

    parser.parse(annotations) do |obj|
      objects << obj
    end
    expect(objects).to be
    expect(objects.length).to eql(6)
  end

  it "provides name/value for annotations" do
    parser = BEL::Script::Parser.new

    annotations = %Q{SET Disease = Atherosclerosis
SET Cell = "Endothelial Cells"
SET Citation = {"PubMed","The Biochemical journal","12444918","","Houslay MD|Adams DR",""}
SET Tissue = {"Endothelium, Vascular","vascular tissue"}
SET Species = 9606
SET Evidence = "Arterial cells are highly susceptible to oxidative stress, which can induce both necrosis
and apoptosis (programmed cell death) [1,2]"\n}

    parser.parse(annotations) do |obj|
      expect(obj).to respond_to(:name)
      expect(obj).to respond_to(:value)
    end
  end

  it "understands terms (yields params, terms, and statements)" do
    parser = BEL::Script::Parser.new
    objects = []

    terms = %Q{biologicalProcess(GOBP:"response to oxidative stress")
biologicalProcess(GOBP:aging)
gtpBoundActivity(proteinAbundance(SFAM:"RHO Family"))
catalyticActivity(proteinAbundance(HGNC:NOS3))
translocation(proteinAbundance(SFAM:"RAS Family"),MESHCL:"Intracellular Space",MESHCL:"Cell Membrane")
proteinAbundance(HGNC:RAF1,proteinModification(P,S))\n}

    parser.parse(terms) do |obj|
      objects << obj
    end
    expect(objects).to be
    expect(objects.length).to eql(26)
  end

  it "provides fx/arguments for terms" do
    parser = BEL::Script::Parser.new

    terms = %Q{biologicalProcess(GOBP:"response to oxidative stress")
biologicalProcess(GOBP:aging)
gtpBoundActivity(proteinAbundance(SFAM:"RHO Family"))
catalyticActivity(proteinAbundance(HGNC:NOS3))
translocation(proteinAbundance(SFAM:"RAS Family"),MESHCL:"Intracellular Space",MESHCL:"Cell Membrane")
proteinAbundance(HGNC:RAF1,proteinModification(P,S))\n}

    parser.parse(terms) do |obj|
      if obj.is_a? BEL::Language::Term
        expect(obj).to respond_to(:fx)
        expect(obj).to respond_to(:arguments)
      end
    end
  end

  it "understands statements (parses but does not yield nested stmts)" do
    parser = BEL::Script::Parser.new
    objects = []

    statements = %Q{path(MESHD:Atherosclerosis) //Comment1
path(Atherosclerosis)
bp(GOBP:"lipid oxidation")
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473)) //Comment2
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process")) //Comment3\n}

    parser.parse(statements) do |obj|
      objects << obj
    end
    expect(objects).to be
    expect(objects.length).to eql(30)
  end

  it "provides subject/rel/object/annotations/comment for statements" do
    parser = BEL::Script::Parser.new

    statements = %Q{path(MESHD:Atherosclerosis) //Comment1
path(Atherosclerosis)
bp(GOBP:"lipid oxidation")
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473)) //Comment2
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process")) //Comment3\n}

    parser.parse(statements) do |obj|
      if obj.is_a? BEL::Language::Statement
        expect(obj).to respond_to(:subject)
        expect(obj).to respond_to(:relationship)
        expect(obj).to respond_to(:object)
        expect(obj).to respond_to(:annotations)
        expect(obj).to respond_to(:comment)
      end
    end
  end

  it "understands statement groups (SET STATEMENT_GROUP and UNSET STATEMENT_GROUP)" do
    parser = BEL::Script::Parser.new
    objects = []

    statements = %Q{SET STATEMENT_GROUP = 123
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473))
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process"))
UNSET STATEMENT_GROUP\n}

    parser.parse(statements) do |obj|
      objects << obj
    end
    expect(objects).to be
    expect(objects.length).to eql(23)

  end

  it "provides name/statements/annotations for statement groups" do
    parser = BEL::Script::Parser.new

    statements = %Q{SET STATEMENT_GROUP = 123
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473))
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process"))
UNSET STATEMENT_GROUP\n}

    parser.parse(statements) do |obj|
      if obj.is_a? BEL::Language::StatementGroup
        expect(obj).to respond_to(:name)
        expect(obj).to respond_to(:statements)
        expect(obj).to respond_to(:annotations)
      end
    end
  end

  it "provides name for unset of statement group" do
    parser = BEL::Script::Parser.new

    statements = %Q{SET STATEMENT_GROUP = 123
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473))
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process"))
UNSET STATEMENT_GROUP\n}

    parser.parse(statements) do |obj|
      if obj.is_a? BEL::Language::UnsetStatementGroup
        expect(obj).to respond_to(:name)
      end
    end
  end
end
