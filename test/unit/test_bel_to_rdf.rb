require 'bel'
require 'minitest'
require 'minitest/autorun'
require 'rdf/nquads'

class BelToRDFTest < Minitest::Test
  def setup
    @resources_dir = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'resources')
    @input_io = File.open("#{@resources_dir}/small_corpus.bel", :external_encoding => 'UTF-8')

    @output_io = File.open("#{Dir.tmpdir}/bel_to_rdf_test.rdf", 'w+')
  end

  def test_bel_to_rdf_turtle
    BEL.translate(@input_io, :bel, :turtle, @output_io)

    checkRDFOutputFile "#{Dir.tmpdir}/bel_to_rdf_test.rdf"
  end

  def test_bel_to_rdf_with_prefix_file
    rdf_prefix_file = File.open("#{@resources_dir}/prefix_file.yml", :external_encoding => 'UTF-8')

    BEL.translate(@input_io, :bel, :turtle, @output_io, {
        :rdf_prefix_file => rdf_prefix_file
    })

    checkRDFOutputFileWithPrefixes "#{Dir.tmpdir}/bel_to_rdf_test.rdf", :rdfs_prfx => 'test_rdfs:', :vocab_prfx => 'testv:'
  end

  def test_bel_to_rdf_with_annotations_override_file
    resource_mapping_file = File.open("#{@resources_dir}/resource_mapping.yml", :external_encoding => 'UTF-8')

    BEL.translate(@input_io, :bel, :turtle, @output_io, {
        :remap_file => resource_mapping_file
    })

    checkAnnotations "#{Dir.tmpdir}/bel_to_rdf_test.rdf"
  end

  def test_bel_to_rdf_with_ns_override_file
    resource_mapping_file = File.open("#{@resources_dir}/resource_mapping.yml", :external_encoding => 'UTF-8')

    BEL.translate(@input_io, :bel, :turtle, @output_io, {
        :remap_file => resource_mapping_file
    })

    checkNamespaces "#{Dir.tmpdir}/bel_to_rdf_test.rdf"
  end

  def teardown
    @output_io.close
    # File.delete @output_io
  end

  private
  def getRDFStatements(prefixes = nil)

    rdfs_prfx = prefixes && prefixes.key?(:rdfs_prfx) ? prefixes[:rdfs_prfx] : 'http://www.w3.org/2000/01/rdf-schema#'
    vocab_prfx = prefixes && prefixes.key?(:vocab_prfx) ? prefixes[:vocab_prfx] : 'http://www.openbel.org/vocabulary/'
    
    statements = [{"#{rdfs_prfx}label" =>           'path(MESHD:Atherosclerosis)'},
                  {"#{rdfs_prfx}label" =>           'bp(GOBP:"lipid oxidation")'},
                  {"#{vocab_prfx}hasRelationship" => "#{vocab_prfx}PositiveCorrelation"},
                  {"#{rdfs_prfx}label" =>           'path(MESHD:Atherosclerosis) positiveCorrelation bp(GOBP:"lipid oxidation")'},
                  {"#{rdfs_prfx}label" =>           'path(MESHD:Atherosclerosis)'},
                  {"#{rdfs_prfx}label" =>           'bp(GOBP:"protein oxidation")'},
                  {"#{vocab_prfx}hasRelationship" => "#{vocab_prfx}PositiveCorrelation"},
                  {"#{rdfs_prfx}label" =>           'path(MESHD:Atherosclerosis) positiveCorrelation bp(GOBP:"protein oxidation")'},
                  {"#{rdfs_prfx}label" =>           'bp(GOBP:"response to oxidative stress")'},
                  {"#{rdfs_prfx}label" =>           'bp(GOBP:"apoptotic process")'},
                  {"#{vocab_prfx}hasRelationship" => "#{vocab_prfx}Increases"},
                  {"#{rdfs_prfx}label" =>           'bp(GOBP:"response to oxidative stress") increases bp(GOBP:"apoptotic process")'},
                  {"#{rdfs_prfx}label" =>           'bp(GOBP:"response to oxidative stress")'},
                  {"#{rdfs_prfx}label" =>           'bp(GOBP:necrosis)'},
                  {"#{vocab_prfx}hasRelationship" => "#{vocab_prfx}Increases"},
                  {"#{rdfs_prfx}label" =>           'bp(GOBP:"response to oxidative stress") increases bp(GOBP:necrosis)'},
                  {"#{rdfs_prfx}label" =>           'a(SCHEM:"Oxidized Low Density Lipoprotein")'},
                  {"#{rdfs_prfx}label" =>           'bp(GOBP:"apoptotic process")'},
                  {"#{vocab_prfx}hasRelationship" => "#{vocab_prfx}Increases"},
                  {"#{rdfs_prfx}label" =>           'a(SCHEM:"Oxidized Low Density Lipoprotein") increases bp(GOBP:"apoptotic process")'},
                  {"#{rdfs_prfx}label" =>           'a(SCHEM:"Oxidized Low Density Lipoprotein")'},
                  {"#{rdfs_prfx}label" =>           'bp(GOBP:"apoptotic process")'},
                  {"#{vocab_prfx}hasRelationship" => "#{vocab_prfx}Increases"},
                  {"#{rdfs_prfx}label" =>           'a(SCHEM:"Oxidized Low Density Lipoprotein") increases bp(GOBP:"apoptotic process")'},
                  {"#{rdfs_prfx}label" =>           'a(CHEBI:"oxygen radical")'},
                  {"#{rdfs_prfx}label" =>           'a(SCHEM:"Oxidized Low Density Lipoprotein")'},
                  {"#{vocab_prfx}hasRelationship" => "#{vocab_prfx}Increases"},
                  {"#{rdfs_prfx}label" =>           'a(CHEBI:"oxygen radical") increases a(SCHEM:"Oxidized Low Density Lipoprotein")'},
                  {"#{rdfs_prfx}label" =>           'p(MGI:Mapkap1)'},
                  {"#{rdfs_prfx}label" =>           'p(MGI:Akt1,pmod(P,S,473))'},
                  {"#{rdfs_prfx}label" =>           'p(MGI:Akt1)'},
                  {"#{vocab_prfx}hasRelationship" => "#{vocab_prfx}Increases"},
                  {"#{rdfs_prfx}label" =>           'p(MGI:Mapkap1) increases p(MGI:Akt1,pmod(P,S,473))'},
                  {"#{rdfs_prfx}label" =>           'p(MGI:Mapkap1)'},
                  {"#{rdfs_prfx}label" =>           'p(MGI:Akt1,pmod(P,S,308))'},
                  {"#{rdfs_prfx}label" =>           'p(MGI:Akt1)'},
                  {"#{vocab_prfx}hasRelationship" => "#{vocab_prfx}CausesNoChange"},
                  {"#{rdfs_prfx}label" =>           'p(MGI:Mapkap1) causesNoChange p(MGI:Akt1,pmod(P,S,308))'}]

    statements
  end


  def checkRDFOutputFile(rdf_file_name)
    statements = getRDFStatements()

    RDF::Turtle::Reader.open(rdf_file_name) do |reader|
      stmt = statements.shift

      reader.each_statement do |statement|
        if (stmt && statement.predicate == stmt.keys[0].to_s)
          assert statement.object == stmt.values[0]
          stmt = statements.shift
        end
      end

      assert statements.empty?
    end
  end

  def checkRDFOutputFileWithPrefixes(rdf_file_name, prefixes)
    statements = getRDFStatements prefixes

    stmt = statements.shift

    File.open(rdf_file_name, 'r') do |f|
      f.each_line do |line|
        if (stmt && line.include?(stmt.keys[0].to_s))
          assert line.split(stmt.keys[0].to_s)[1].gsub('\"', '"').include?(stmt.values[0])
          stmt = statements.shift
        end
      end
    end

    assert statements.empty?
  end

  def checkAnnotations(rdf_file_name)
    first_annotations_pre = [
        {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/disease/atherosclerosis'},
        {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://identifiers.org/anatomy/artery'},
        {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://identifiers.org/text-location/Review'}
    ]

    first_annotations_suf = [
        {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/disease/atherosclerosis'},
        {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/anatomy/artery'}
    ]

    annotations = first_annotations_pre + first_annotations_suf +
                  first_annotations_pre + first_annotations_suf +
                  first_annotations_pre + first_annotations_suf +
                  first_annotations_pre + first_annotations_suf +
                  first_annotations_pre +
                  [{'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/cell/endothelial%20cell'}] +
                  first_annotations_suf +
                  [{'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/cell/endothelial%20cell'}] +
                  first_annotations_pre +
                  [{'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/cell/endothelial%20cell'},
                   {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/mesh-anatomy/Muscle,%20Smooth,%20Vascular'}] +
                  first_annotations_suf +
                  [{'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/cell/endothelial%20cell'},
                   {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/mesh-anatomy/Muscle,%20Smooth,%20Vascular'}] +
                  first_annotations_pre +
                  [{'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/cell/endothelial%20cell'},
                   {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/mesh-anatomy/Muscle,%20Smooth,%20Vascular'}] +
                  first_annotations_suf +
                  [{'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/cell/endothelial%20cell'},
                   {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/mesh-anatomy/Muscle,%20Smooth,%20Vascular'}] +
                  [{'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/cell/fibroblast'},
                   # "Results" annotation is skipped as resource_mapping.yml does not contain "Results" in list of keyword "TextLocation"
                   # {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://identifiers.org/text-location/Results'},
                   {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/species-taxonomy-id/10090'},
                   {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/cell/fibroblast'},
                   {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/species-taxonomy-id/10090'},
                   {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/cell/fibroblast'},
                   # {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://identifiers.org/text-location/Results'},
                   {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/species-taxonomy-id/10090'},
                   {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/cell/fibroblast'},
                   {'http://www.openbel.org/vocabulary/hasAnnotation' => 'http://www.openbel.org/bel/annotation/species-taxonomy-id/10090'}
                  ]

    anno = annotations.shift

    RDF::Turtle::Reader.open(rdf_file_name) do |reader|
      reader.each_statement do |statement|
        if (anno && statement.predicate == anno.keys[0].to_s)
          assert statement.object == anno.values[0]
          anno = annotations.shift
        end
      end
    end

    #assert annotations.empty?
  end

  def checkNamespaces(rdf_file_name)
    meshd_count = 0
    gobp_lipid_oxidation = 0
    gobp_protein_oxidation = 0
    gobp_necrosis = 0
    gobp_apoptotic_process_count = 0
    gobp_response_to_oxidative_stress_count = 0

    RDF::Turtle::Reader.open(rdf_file_name) do |reader|
      reader.each_statement do |statement|
        if (statement.subject == 'http://identifiers.org/meshd/Atherosclerosis' &&
            statement.predicate == 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
          meshd_count += 1
          assert statement.object == 'http://www.openbel.org/vocabulary/AbundanceConcept' ||
                     statement.object == 'http://www.openbel.org/vocabulary/PathologyConcept'
        end

        if (statement.subject == 'http://identifiers.org/ncbigene/lipid%20oxidation' &&
            statement.predicate == 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
          gobp_lipid_oxidation += 1
          assert statement.object == 'http://www.openbel.org/vocabulary/AbundanceConcept' ||
                     statement.object == 'http://www.openbel.org/vocabulary/BiologicalProcessConcept'
        end

        if (statement.subject == 'http://identifiers.org/ncbigene/necrosis' &&
            statement.predicate == 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
          gobp_necrosis += 1
          assert statement.object == 'http://www.openbel.org/vocabulary/AbundanceConcept' ||
                     statement.object == 'http://www.openbel.org/vocabulary/BiologicalProcessConcept'
        end

        if (statement.subject == 'http://identifiers.org/ncbigene/protein%20oxidation' &&
            statement.predicate == 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
          gobp_protein_oxidation += 1
          assert statement.object == 'http://www.openbel.org/vocabulary/AbundanceConcept' ||
                     statement.object == 'http://www.openbel.org/vocabulary/BiologicalProcessConcept'
        end

        if (statement.subject == 'http://identifiers.org/ncbigene/apoptotic%20process' &&
            statement.predicate == 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
          gobp_apoptotic_process_count += 1
          assert statement.object == 'http://www.openbel.org/vocabulary/AbundanceConcept' ||
                     statement.object == 'http://www.openbel.org/vocabulary/BiologicalProcessConcept'
        end

        if (statement.subject == 'http://identifiers.org/ncbigene/response%20to%20oxidative%20stress' &&
            statement.predicate == 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
          gobp_response_to_oxidative_stress_count += 1
          assert statement.object == 'http://www.openbel.org/vocabulary/AbundanceConcept' ||
                     statement.object == 'http://www.openbel.org/vocabulary/BiologicalProcessConcept'
        end
      end
    end

    assert meshd_count == 4
    assert gobp_lipid_oxidation == 2
    assert gobp_protein_oxidation == 2
    assert gobp_necrosis == 1
    assert gobp_apoptotic_process_count == 6
    assert gobp_response_to_oxidative_stress_count == 4
  end
end
