# vim: ts=2 sw=2:
# Defines the RDF vocabulary for BEL structures.

unless BEL::Features.rdf_support?
  # rdf and addressable are required
  raise RuntimeError, %Q{BEL::RDF is not supported.
The rdf and addressable gems are required.

Install the gems:
      gem install rdf
      gem install addressable}
end

require 'rdf'
require 'addressable/uri'

# rename rdf module to avoid conflict within BEL::RDF
RUBYRDF = RDF

module BEL
  module RDF

    # uri prefixes
    BELR    = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/')
    BELV    = RUBYRDF::Vocabulary.new('http://www.openbel.org/vocabulary/')
    PUBMED  = RUBYRDF::Vocabulary.new('http://bio2rdf.org/pubmed:')
    RDF     = RUBYRDF
    RDFS    = RUBYRDF::RDFS

    # annotations
    Anatomy       = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/anatomy/')
    Cell          = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/cell/')
    CellLine      = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/cell-line/')
    CellStructure = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/cell-structure/')
    Disease       = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/disease/')
    MeSHAnatomy   = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/mesh-anatomy/')
    MeSHDisease   = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/mesh-diseases/')
    Species       = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/species-taxonomy-id/')

    # maps outer function to bel/vocabulary class
    FUNCTION_TYPE = {
      a: BELV.Abundance,
      g: BELV.GeneAbundance,
      p: BELV.ProteinAbundance,
      r: BELV.RNAAbundance,
      m: BELV.microRNAAbundance,
      complex: BELV.ComplexAbundance,
      composite: BELV.CompositeAbundance,
      bp: BELV.BiologicalProcess,
      path: BELV.Pathology,
      rxn: BELV.Reaction,
      tloc: BELV.Translocation,
      sec: BELV.CellSecretion,
      deg: BELV.Degradation,
      cat: BELV.AbundanceActivity,
      chap: BELV.AbundanceActivity,
      gtp: BELV.AbundanceActivity,
      kin: BELV.AbundanceActivity,
      act: BELV.AbundanceActivity,
      pep: BELV.AbundanceActivity,
      phos: BELV.AbundanceActivity,
      ribo: BELV.AbundanceActivity,
      tscript: BELV.AbundanceActivity,
      tport: BELV.AbundanceActivity
    }

    RELATIONSHIP_TYPE = {
      # 'actsIn' =>                 'actsIn',  XXX captured by BELV.hasChild]
        'analogous'              => 'analogous',
        'association'            => 'association',
        '--'                     => 'association',
        'biomarkerFor'           => 'biomarkerFor',
        'causesNoChange'         => 'causesNoChange',
        'decreases'              => 'decreases',
        '-|'                     => 'decreases',
        'directlyDecreases'      => 'directlyDecreases',
        '=|'                     => 'directlyDecreases',
        'directlyIncreases'      => 'directlyIncreases',
        '=>'                     => 'directlyIncreases',
        'hasComponent'           => 'hasComponent',
        'hasComponents'          => 'hasComponents',
        'hasMember'              => 'hasMember',
        'hasMembers'             => 'hasMembers',
        'hasModification'        => 'hasModification',
        'hasProduct'             => 'hasProduct',
        'hasVariant'             => 'hasVariant',
        'includes'               => 'includes',
        'increases'              => 'increases',
        '->'                     => 'increases',
        'isA'                    => 'isA',
        'negativeCorrelation'    => 'negativeCorrelation',
        'orthologous'            => 'orthologous',
        'positiveCorrelation'    => 'positiveCorrelation',
        'prognosticBiomarkerFor' => 'prognosticBiomarkerFor',
        'rateLimitingStepOf'     => 'rateLimitingStepOf',
        'reactantIn'             => 'reactantIn',
        'subProcessOf'           => 'subProcessOf',
        'transcribedTo'          => 'transcribedTo',
        ':>'                     => 'transcribedTo',
        '>>'                     => 'translatedTo',
        'translatedTo'           => 'translatedTo',
        'translocates'           => 'translocates'
    }

    RELATIONSHIP_CLASSIFICATION = {
        :'association'            => BELV.correlativeRelationship,
        :'--'                     => BELV.correlativeRelationship,
        :'biomarkerFor'           => BELV.biomarkerFor,
        :'causesNoChange'         => BELV.causesNoChange,
        :'decreases'              => BELV.decreases,
        :'-|'                     => BELV.decreases,
        :'directlyDecreases'      => BELV.directlyDecreases,
        :'=|'                     => BELV.directlyDecreases,
        :'directlyIncreases'      => BELV.directlyIncreases,
        :'=>'                     => BELV.directlyIncreases,
        :'hasComponent'           => BELV.hasComponent,
        :'hasMember'              => BELV.hasMember,
        :'increases'              => BELV.increases,
        :'->'                     => BELV.increases,
        :'isA'                    => BELV.isA,
        :'negativeCorrelation'    => BELV.negativeCorrelation,
        :'positiveCorrelation'    => BELV.positiveCorrelation,
        :'prognosticBiomarkerFor' => BELV.prognosticBiomarkerFor,
        :'rateLimitingStepOf'     => BELV.rateLimitingStepOf,
        :'subProcessOf'           => BELV.subProcessOf
    }

    ACTIVITY_TYPE = {
      cat: BELV.Catalytic,
      chap: BELV.Chaperone,
      gtp: BELV.GtpBound,
      kin: BELV.Kinase,
      act: BELV.Activity,
      pep: BELV.Peptidase,
      phos: BELV.Phosphatase,
      ribo: BELV.Ribosylase,
      tscript: BELV.Transcription,
      tport: BELV.Transport
    }

    # maps modification types to bel/vocabulary class
    MODIFICATION_TYPE = {
      'P,S' => BELV.PhosphorylationSerine,
      'P,T' => BELV.PhosphorylationThreonine,
      'P,Y' => BELV.PhosphorylationTyrosine,
      'A'   => BELV.Acetylation,
      'F'   => BELV.Farnesylation,
      'G'   => BELV.Glycosylation,
      'H'   => BELV.Hydroxylation,
      'M'   => BELV.Methylation,
      'P'   => BELV.Phosphorylation,
      'R'   => BELV.Ribosylation,
      'S'   => BELV.Sumoylation,
      'U'   => BELV.Ubiquitination
    }

    # protein variant
    PROTEIN_VARIANT = [:fus, :fusion, :sub, :substitution, :trunc, :truncation]

    def self.vocabulary_rdf
      [
        # Class
        [BELV.Term, RDF.type, RDF::RDFS.Class],
        [BELV.Statement, RDF.type, RDF::RDFS.Class],
        [BELV.Evidence, RDF.type, RDF::RDFS.Class],
        [BELV.Abundance, RDF.type, RDF::RDFS.Class],
        [BELV.Modification, RDF.type, RDF::RDFS.Class],
        [BELV.relationship, RDF.type, RDF::RDFS.Class],

        # Property
        [BELV.hasConcept, RDF.type, RDF.Property],
        [BELV.hasChild, RDF.type, RDF.Property],
        [BELV.hasSubject, RDF::RDFS.subPropertyOf, BELV.hasChild],
        [BELV.hasSubject, RDF::RDFS.range, BELV.Term],
        [BELV.hasSubject, RDF::RDFS.domain, BELV.Statement],
        [BELV.hasObject, RDF::RDFS.subPropertyOf, BELV.hasChild],
        [BELV.hasObject, RDF::RDFS.range, BELV.Term],
        [BELV.hasObject, RDF::RDFS.domain, BELV.Statement],
        [BELV.hasRelationship, RDF.type, RDF.Property],
        [BELV.hasActivityType, RDF.type, RDF.Property],
        [BELV.hasModificationPosition, RDF.type, RDF.Property],
        [BELV.hasModificationType, RDF.type, RDF.Property],
        [BELV.hasEvidence, RDF.type, RDF.Property],
        [BELV.hasStatement, RDF.type, RDF.Property],
        [BELV.hasAnnotation, RDF.type, RDF.Property],
        [BELV.hasCitation, RDF.type, RDF.Property],
        [BELV.hasEvidenceText, RDF.type, RDF.Property],

        # abundance subclasses
        [BELV.Process, RDF.type, RDF::RDFS.Class],
        [BELV.ProteinAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.ModifiedProteinAbundance, RDF::RDFS.subClassOf, BELV.ProteinAbundance],
        [BELV.ProteinVariantAbundance, RDF::RDFS.subClassOf, BELV.ProteinAbundance],
        [BELV.ComplexAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.CompositeAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.RNAAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.GeneAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.microRNAAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.BiologicalProcess, RDF::RDFS.subClassOf, BELV.Process],
        [BELV.Pathology, RDF::RDFS.subClassOf, BELV.BiologicalProcess],
        [BELV.Transformation, RDF::RDFS.subClassOf, BELV.Process],
        [BELV.Reaction, RDF::RDFS.subClassOf, BELV.Transformation],
        [BELV.Translocation, RDF::RDFS.subClassOf, BELV.Transformation],
        [BELV.CellSecretion, RDF::RDFS.subClassOf, BELV.Translocation],
        [BELV.Degradation, RDF::RDFS.subClassOf, BELV.Transformation],
        [BELV.AbundanceActivity, RDF::RDFS.subClassOf, BELV.Process],

        # modification subclasses
        [BELV.Acetylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Farnesylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Glycosylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Hydroxylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Methylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Phosphorylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Ribosylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Sumoylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Ubiquitination, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.PhosphorylationSerine, RDF::RDFS.subClassOf, BELV.Phosphorylation],
        [BELV.PhosphorylationTyrosine, RDF::RDFS.subClassOf, BELV.Phosphorylation],
        [BELV.PhosphorylationThreonine, RDF::RDFS.subClassOf, BELV.Phosphorylation],

        # relationships subclasses
        [BELV.positiveRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.negativeRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.causalRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.directRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.membershipRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.correlativeRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.biomarkerFor, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.causesNoChange, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.increases, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.increases, RDF::RDFS.subClassOf, BELV.positiveRelationship],
        [BELV.decreases, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.decreases, RDF::RDFS.subClassOf, BELV.negativeRelationship],
        [BELV.directlyIncreases, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.directlyIncreases, RDF::RDFS.subClassOf, BELV.positiveRelationship],
        [BELV.directlyIncreases, RDF::RDFS.subClassOf, BELV.directRelationship],
        [BELV.directlyIncreases, RDF::RDFS.subClassOf, BELV.increases],
        [BELV.directlyDecreases, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.directlyDecreases, RDF::RDFS.subClassOf, BELV.negativeRelationship],
        [BELV.directlyDecreases, RDF::RDFS.subClassOf, BELV.directRelationship],
        [BELV.directlyDecreases, RDF::RDFS.subClassOf, BELV.decreases],
        [BELV.negativeCorrelation, RDF::RDFS.subClassOf, BELV.correlativeRelationship],
        [BELV.negativeCorrelation, RDF::RDFS.subClassOf, BELV.negativeRelationship],
        [BELV.positiveCorrelation, RDF::RDFS.subClassOf, BELV.correlativeRelationship],
        [BELV.positiveCorrelation, RDF::RDFS.subClassOf, BELV.positiveRelationship],
        [BELV.association, RDF::RDFS.subClassOf, BELV.correlativeRelationship],
        [BELV.hasComponent, RDF::RDFS.subClassOf, BELV.membershipRelationship],
        [BELV.hasMember, RDF::RDFS.subClassOf, BELV.membershipRelationship],
        [BELV.isA, RDF::RDFS.subClassOf, BELV.membershipRelationship],
        [BELV.prognosticBiomarkerFor, RDF::RDFS.subClassOf, BELV.biomarkerFor],
        [BELV.rateLimitingStepOf, RDF::RDFS.subClassOf, BELV.increases],
        [BELV.rateLimitingStepOf, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.rateLimitingStepOf, RDF::RDFS.subClassOf, BELV.subProcessOf],
        [BELV.subProcessOf, RDF::RDFS.subClassOf, BELV.membershipRelationship]
      ]
    end
  end
end
