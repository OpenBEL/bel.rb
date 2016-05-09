require 'bel/script.rb'

describe BEL::Script::Parser, "#parse" do
  it "understands empty lines and document comments" do
    objects = BEL::Script.parse("####\n\nSET Reviewed = True\n").to_a
    expect(objects).to be
    expect(objects.length).to eql(3)
    expect(objects[0].class).to eql(BEL::Language::Comment)
    expect(objects[1].class).to eql(BEL::Language::Newline)
    expect(objects[2].class).to eql(BEL::Language::Annotation)
  end

  ['Name', 'Description', 'Version', 'Copyright',
   'Authors', 'Licenses', 'ContactInfo'].each do |property|
    it "understands the document header for #{property} (SET DOCUMENT)" do
      objects = BEL::Script.parse(%Q{SET DOCUMENT #{property} = "Test"\n}).to_a
      expect(objects).to be
      expect(objects.length).to eql(1)
    end
  end

  it "provides name/value for document headers" do
    ['Name', 'Description', 'Version', 'Copyright',
     'Authors', 'Licenses', 'ContactInfo'].each do |property|
      BEL::Script.parse(%Q{SET DOCUMENT #{property} = "Test"\n}) do |obj|
        expect(obj).to respond_to(:name)
        expect(obj).to respond_to(:value)
      end
    end
  end

  it "understands annotation definitions (DEFINE ANNOTATION)" do
    define = %Q{DEFINE ANNOTATION Disease AS  URL "http://site/f.belanno"
DEFINE ANNOTATION Dosage AS PATTERN "[0-9]\.[0-9]+"
DEFINE ANNOTATION TextLocation AS  LIST {"Abstract","Results","Legend","Review"}\n}
    objects = BEL::Script.parse(define).to_a
    expect(objects).to be
    expect(objects.length).to eql(3)
  end

  it "provides prefix/value for annotation definitions" do
    define = %Q{DEFINE ANNOTATION Disease AS  URL "http://site/f.belanno"
DEFINE ANNOTATION Dosage AS PATTERN "[0-9]\.[0-9]+"
DEFINE ANNOTATION TextLocation AS  LIST {"Abstract","Results","Legend","Review"}\n}
    BEL::Script.parse(define) do |obj|
      expect(obj).to respond_to(:prefix)
      expect(obj).to respond_to(:value)
    end
  end

  it "understands namespace definitions (DEFINE NAMESPACE)" do
    define = %Q{DEFINE NAMESPACE GOBP AS URL "http://resource.belframework.org/belframework/20131211/namespace/go-biological-process.belns"
DEFINE NAMESPACE HGNC AS URL "http://resource.belframework.org/belframework/20131211/namespace/hgnc-human-genes.belns"
DEFINE NAMESPACE MESHD AS URL "http://resource.belframework.org/belframework/20131211/namespace/mesh-diseases.belns"
DEFINE NAMESPACE MGI AS URL "http://resource.belframework.org/belframework/20131211/namespace/mgi-mouse-genes.belns"\n}
    objects = BEL::Script.parse(define).to_a
    expect(objects).to be
    expect(objects.length).to eql(4)
  end

  it "provides prefix/value for namespace definitions" do
    define = %Q{DEFINE NAMESPACE GOBP AS URL "http://resource.belframework.org/belframework/20131211/namespace/go-biological-process.belns"
DEFINE NAMESPACE HGNC AS URL "http://resource.belframework.org/belframework/20131211/namespace/hgnc-human-genes.belns"
DEFINE NAMESPACE MESHD AS URL "http://resource.belframework.org/belframework/20131211/namespace/mesh-diseases.belns"
DEFINE NAMESPACE MGI AS URL "http://resource.belframework.org/belframework/20131211/namespace/mgi-mouse-genes.belns"\n}
    BEL::Script.parse(define) do |obj|
      expect(obj).to respond_to(:prefix)
      expect(obj).to respond_to(:url)
    end
  end

  it "understands annotations (SET)" do
    annotations = %Q{SET Disease = Atherosclerosis
SET Cell = "Endothelial Cells"
SET Citation = {"PubMed","The Biochemical journal","12444918","","Houslay MD|Adams DR",""}
SET Tissue = {"Endothelium, Vascular","vascular tissue"}
SET Species = 9606
SET Support = "Arterial cells are highly susceptible to oxidative stress, which can induce both necrosis
and apoptosis (programmed cell death) [1,2]"\n}
    objects = BEL::Script.parse(annotations).to_a
    expect(objects).to be
    expect(objects.length).to eql(6)
  end

  it "understands multi-value lists ( { ... } ) containing commas, end bracket, and escaped quotes within values" do
    annotations = %Q|SET Citation = { "Pub,\\"Med\\"", "Name of, the \\"article\\"", "1231,\\"2910\\"", ",", "..,..","21,22(13),3265,71}"}\n|
    objects = BEL::Script.parse(annotations).to_a
    expect(objects).to be
    expect(objects.length).to eql(1)
    expect(objects.first.value).to eql([
      "Pub,\"Med\"",
      "Name of, the \"article\"",
      "1231,\"2910\"",
      ",",
      "..,..",
      "21,22(13),3265,71}"
    ])
  end

  it "provides name/value for annotations" do
    annotations = %Q{SET Disease = Atherosclerosis
SET Cell = "Endothelial Cells"
SET Citation = {"PubMed","The Biochemical journal","12444918","","Houslay MD|Adams DR",""}
SET Tissue = {"Endothelium, Vascular","vascular tissue"}
SET Species = 9606
SET Support = "Arterial cells are highly susceptible to oxidative stress, which can induce both necrosis
and apoptosis (programmed cell death) [1,2]"\n}

    BEL::Script.parse(annotations) do |obj|
      expect(obj).to respond_to(:name)
      expect(obj).to respond_to(:value)
    end
  end

  it "understands terms (yields params, terms, and statements)" do
    namespace_definitions = {
      GOBP: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :GOBP},
      SFAM: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :SFAM},
      HGNC: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :HGNC},
      MESHCS: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MESHCS}
    }
    terms = %Q{biologicalProcess(GOBP:"response to oxidative stress")
biologicalProcess(GOBP:aging)
gtpBoundActivity(proteinAbundance(SFAM:"RHO Family"))
catalyticActivity(proteinAbundance(HGNC:NOS3))
translocation(proteinAbundance(SFAM:"RAS Family"),MESHCS:"Intracellular Space",MESHCS:"Cell Membrane")
proteinAbundance(HGNC:RAF1,proteinModification(P,S))\n}

    objects = BEL::Script.parse(terms, namespace_definitions).to_a
    expect(objects).to be
    expect(objects.length).to eql(26)
  end

  it "provides fx/arguments for terms" do
    namespace_definitions = {
      GOBP: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :GOBP},
      SFAM: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :SFAM},
      HGNC: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :HGNC},
      MESHCS: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MESHCS}
    }
    terms = %Q{biologicalProcess(GOBP:"response to oxidative stress")
biologicalProcess(GOBP:aging)
gtpBoundActivity(proteinAbundance(SFAM:"RHO Family"))
catalyticActivity(proteinAbundance(HGNC:NOS3))
translocation(proteinAbundance(SFAM:"RAS Family"),MESHCS:"Intracellular Space",MESHCS:"Cell Membrane")
proteinAbundance(HGNC:RAF1,proteinModification(P,S))\n}

    BEL::Script.parse(terms, namespace_definitions) do |obj|
      if obj.is_a? BEL::Nanopub::Term
        expect(obj).to respond_to(:fx)
        expect(obj).to respond_to(:arguments)
      end
    end
  end

  it "parses term arguments correctly" do
    namespace_definitions = {
      HGNC: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :HGNC}
    }
    term = 'p(HGNC:FOXO3, pmod(P, S))'

    terms = BEL::Script.parse(term, namespace_definitions).find_all {|obj|
      obj.is_a? BEL::Nanopub::Term
    }.to_a
    expect(terms.size).to eql(2)

    # pmod(P, S)
    expect(terms[0].arguments.size).to eql(2)
    # p(HGNC:FOXO3, pmod(P, S))
    expect(terms[1].arguments.size).to eql(2)
  end

  it "understands statements (parses but does not yield nested stmts)" do
    namespace_definitions = {
      GOBP: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :GOBP},
      MESHD: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MESHD},
      MGI: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MGI},
      HGNC: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :HGNC}
    }
    statements = %Q{path(MESHD:Atherosclerosis) //Comment1
path(Atherosclerosis)
bp(GOBP:"lipid oxidation")
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473)) //Comment2
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process")) //Comment3\n}

    objects = BEL::Script.parse(statements, namespace_definitions).to_a
    expect(objects).to be
    expect(objects.length).to eql(30)
  end

  it "provides subject/rel/object/annotations/comment for statements" do
    namespace_definitions = {
      GOBP: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :GOBP},
      MESHD: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MESHD},
      MGI: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MGI},
      HGNC: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :HGNC}
    }
    statements = %Q{path(MESHD:Atherosclerosis) //Comment1
path(Atherosclerosis)
bp(GOBP:"lipid oxidation")
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473)) //Comment2
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process")) //Comment3\n}

    BEL::Script.parse(statements, namespace_definitions).find_all {|obj|
      obj.is_a? BEL::Nanopub::Statement
    }.each do |obj|
      expect(obj).to respond_to(:subject)
      expect(obj).to respond_to(:relationship)
      expect(obj).to respond_to(:object)
      expect(obj).to respond_to(:annotations)
      expect(obj).to respond_to(:comment)
    end
  end

  it "understands statement groups (SET STATEMENT_GROUP and UNSET STATEMENT_GROUP)" do
    namespace_definitions = {
      GOBP: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :GOBP},
      MESHD: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MESHD},
      MGI: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MGI},
      HGNC: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :HGNC}
    }
    statements = %Q{SET STATEMENT_GROUP = 123
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473))
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process"))
UNSET STATEMENT_GROUP\n}

    objects = BEL::Script.parse(statements, namespace_definitions).to_a
    expect(objects).to be
    expect(objects.length).to eql(23)
  end

  it "provides name/statements/annotations for statement groups" do
    namespace_definitions = {
      GOBP: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :GOBP},
      MESHD: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MESHD},
      MGI: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MGI},
      HGNC: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :HGNC}
    }
    statements = %Q{SET STATEMENT_GROUP = 123
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473))
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process"))
UNSET STATEMENT_GROUP\n}
    BEL::Script.parse(statements, namespace_definitions).find_all {|obj|
      obj.is_a? BEL::Language::StatementGroup
    }.each do |obj|
        expect(obj).to respond_to(:name)
        expect(obj).to respond_to(:statements)
        expect(obj).to respond_to(:annotations)
    end
  end

  it "provides name for unset of statement group" do
    namespace_definitions = {
      GOBP: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :GOBP},
      MESHD: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MESHD},
      MGI: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :MGI},
      HGNC: BEL::Namespace::DEFAULT_NAMESPACES.find {|ns| ns.prefix == :HGNC}
    }
    statements = %Q{SET STATEMENT_GROUP = 123
p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473))
path(MESHD:Atherosclerosis) => bp(GOBP:"lipid oxidation")
path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GOBP:"apoptotic process"))
UNSET STATEMENT_GROUP\n}
    BEL::Script.parse(statements, namespace_definitions).find_all {|obj|
      obj.is_a? BEL::Language::UnsetStatementGroup
    }.each do |obj|
      expect(obj).to respond_to(:name)
    end
  end
end
# vim: ts=2 sw=2:
