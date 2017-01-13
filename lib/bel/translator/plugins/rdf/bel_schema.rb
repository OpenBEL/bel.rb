require 'rdf'
require 'rdf/vocab'

# Defines the RDF vocabulary for BEL structures.
module BELRDF

  # uri prefixes
  BELR   = ::RDF::Vocabulary.new('http://www.openbel.org/bel/')
  BELV   = ::RDF::Vocabulary.new('http://www.openbel.org/vocabulary/')
  BELE   = ::RDF::Vocabulary.new('http://www.openbel.org/evidence/')
  DC     = ::RDF::Vocab::DC
  FOAF   = ::RDF::Vocab::FOAF
  PUBMED = ::RDF::Vocabulary.new('http://bio2rdf.org/pubmed:')
  RDF    = ::RDF
  RDFS   = ::RDF::Vocab::RDFS
  SKOS   = ::RDF::Vocab::SKOS
  VOID   = ::RDF::Vocab::VOID
  XSD    = ::RDF::Vocab::XSD

  # annotations
  Anatomy       = 'http://www.openbel.org/bel/annotation/anatomy/'
  Cell          = 'http://www.openbel.org/bel/annotation/cell/'
  CellLine      = 'http://www.openbel.org/bel/annotation/cell-line/'
  CellStructure = 'http://www.openbel.org/bel/annotation/cell-structure/'
  Disease       = 'http://www.openbel.org/bel/annotation/disease/'
  MeSHAnatomy   = 'http://www.openbel.org/bel/annotation/mesh-anatomy/'
  MeSHDisease   = 'http://www.openbel.org/bel/annotation/mesh-diseases/'
  Species       = 'http://www.openbel.org/bel/annotation/species-taxonomy-id/'

  # maps outer function to bel/vocabulary class
  FUNCTION_TYPE = {
    a:                       BELV.Abundance,
    act:                     BELV.AbundanceActivity,
    bp:                      BELV.BiologicalProcess,
    cat:                     BELV.AbundanceActivity,
    chap:                    BELV.AbundanceActivity,
    complex:                 BELV.ComplexAbundance,
    composite:               BELV.CompositeAbundance,
    deg:                     BELV.Degradation,
    fus:                     BELV.Fusion,
    g:                       BELV.GeneAbundance,
    gtp:                     BELV.AbundanceActivity,
    kin:                     BELV.AbundanceActivity,
    m:                       BELV.microRNAAbundance,
    p:                       BELV.ProteinAbundance,
    path:                    BELV.Pathology,
    pep:                     BELV.AbundanceActivity,
    phos:                    BELV.AbundanceActivity,
    pmod:                    BELV.ProteinModification,
    r:                       BELV.RNAAbundance,
    ribo:                    BELV.AbundanceActivity,
    rxn:                     BELV.Reaction,
    sec:                     BELV.CellSecretion,
    sub:                     BELV.Substitution,
    surf:                    BELV.CellSurfaceExpression,
    tloc:                    BELV.Translocation,
    tport:                   BELV.AbundanceActivity,
    tscript:                 BELV.AbundanceActivity,
    abundance:               BELV.Abundance,
    biologicalProcess:       BELV.BiologicalProcess,
    catalyticActivity:       BELV.AbundanceActivity,
    cellSecretion:           BELV.CellSecretion,
    cellSurfaceExpression:   BELV.CellSurfaceExpression,
    chaperoneActivity:       BELV.AbundanceActivity,
    complexAbundance:        BELV.ComplexAbundance,
    compositeAbundance:      BELV.CompositeAbundance,
    degradation:             BELV.Degradation,
    fusion:                  BELV.Fusion,
    geneAbundance:           BELV.GeneAbundance,
    gtpBoundActivity:        BELV.AbundanceActivity,
    kinaseActivity:          BELV.AbundanceActivity,
    list:                    BELV.List,
    microRNAAbundance:       BELV.microRNAAbundance,
    molecularActivity:       BELV.AbundanceActivity,
    pathology:               BELV.Pathology,
    peptidaseActivity:       BELV.AbundanceActivity,
    phosphataseActivity:     BELV.AbundanceActivity,
    products:                BELV.Products,
    proteinAbundance:        BELV.ProteinAbundance,
    proteinModification:     BELV.ProteinModification,
    reactants:               BELV.Reactants,
    reaction:                BELV.Reaction,
    ribosylationActivity:    BELV.AbundanceActivity,
    rnaAbundance:            BELV.RNAAbundance,
    substitution:            BELV.Substitution,
    transcriptionalActivity: BELV.AbundanceActivity,
    translocation:           BELV.Translocation,
    transportActivity:       BELV.AbundanceActivity,
    truncation:              BELV.Truncation,
  }

  RELATIONSHIP_TYPE = {
      '--'                     => BELV.Association,
      '-|'                     => BELV.Decreases,
      '=|'                     => BELV.DirectlyDecreases,
      '=>'                     => BELV.DirectlyIncreases,
      '->'                     => BELV.Increases,
      ':>'                     => BELV.TranscribedTo,
      '>>'                     => BELV.TranslatedTo,
      'actsIn'                 => BELV.ActsIn,
      'analogous'              => BELV.Analogous,
      'association'            => BELV.Association,
      'biomarkerFor'           => BELV.BiomarkerFor,
      'causesNoChange'         => BELV.CausesNoChange,
      'decreases'              => BELV.Decreases,
      'directlyDecreases'      => BELV.DirectlyDecreases,
      'directlyIncreases'      => BELV.DirectlyIncreases,
      'hasComponent'           => BELV.HasComponent,
      'hasComponents'          => BELV.HasComponents,
      'hasMember'              => BELV.HasMember,
      'hasMembers'             => BELV.HasMembers,
      'hasModification'        => BELV.HasModification,
      'hasProduct'             => BELV.HasProduct,
      'hasVariant'             => BELV.HasVariant,
      'includes'               => BELV.Includes,
      'increases'              => BELV.Increases,
      'isA'                    => BELV.IsA,
      'negativeCorrelation'    => BELV.NegativeCorrelation,
      'orthologous'            => BELV.Orthologous,
      'positiveCorrelation'    => BELV.PositiveCorrelation,
      'prognosticBiomarkerFor' => BELV.PrognosticBiomarkerFor,
      'rateLimitingStepOf'     => BELV.RateLimitingStepOf,
      'reactantIn'             => BELV.ReactantIn,
      'subProcessOf'           => BELV.SubProcessOf,
      'transcribedTo'          => BELV.TranscribedTo,
      'translatedTo'           => BELV.TranslatedTo,
      'translocates'           => BELV.Translocates,
  }

  RELATIONSHIP_CLASSIFICATION = {
      :'--'                     => BELV.CorrelativeRelationship,
      :'-|'                     => BELV.Decreases,
      :'=|'                     => BELV.DirectlyDecreases,
      :'=>'                     => BELV.DirectlyIncreases,
      :'->'                     => BELV.Increases,
      :'association'            => BELV.CorrelativeRelationship,
      :'biomarkerFor'           => BELV.BiomarkerFor,
      :'causesNoChange'         => BELV.CausesNoChange,
      :'decreases'              => BELV.Decreases,
      :'directlyDecreases'      => BELV.DirectlyDecreases,
      :'directlyIncreases'      => BELV.DirectlyIncreases,
      :'hasComponent'           => BELV.HasComponent,
      :'hasMember'              => BELV.HasMember,
      :'increases'              => BELV.Increases,
      :'isA'                    => BELV.IsA,
      :'negativeCorrelation'    => BELV.NegativeCorrelation,
      :'positiveCorrelation'    => BELV.PositiveCorrelation,
      :'prognosticBiomarkerFor' => BELV.PrognosticBiomarkerFor,
      :'rateLimitingStepOf'     => BELV.RateLimitingStepOf,
      :'subProcessOf'           => BELV.SubProcessOf,
  }

  ACTIVITY_TYPE = {
    act:                     BELV.Activity,
    cat:                     BELV.Catalytic,
    chap:                    BELV.Chaperone,
    gtp:                     BELV.GtpBound,
    kin:                     BELV.Kinase,
    pep:                     BELV.Peptidase,
    phos:                    BELV.Phosphatase,
    ribo:                    BELV.Ribosylase,
    tport:                   BELV.Transport,
    tscript:                 BELV.Transcription,
    catalyticActivity:       BELV.Catalytic,
    chaperoneActivity:       BELV.Chaperone,
    gtpBoundActivity:        BELV.GtpBound,
    kinaseActivity:          BELV.Kinase,
    molecularActivity:       BELV.Activity,
    peptidaseActivity:       BELV.Peptidase,
    phosphataseActivity:     BELV.Phosphatase,
    ribosylationActivity:    BELV.Ribosylase,
    transcriptionalActivity: BELV.Transcription,
    transportActivity:       BELV.Transport,
  }

  # maps modification types to bel/vocabulary class
  MODIFICATION_TYPE = {
    'A'   => BELV.Acetylation,
    'F'   => BELV.Farnesylation,
    'G'   => BELV.Glycosylation,
    'H'   => BELV.Hydroxylation,
    'M'   => BELV.Methylation,
    'P'   => BELV.Phosphorylation,
    'P,S' => BELV.PhosphorylationSerine,
    'P,T' => BELV.PhosphorylationThreonine,
    'P,Y' => BELV.PhosphorylationTyrosine,
    'R'   => BELV.Ribosylation,
    'S'   => BELV.Sumoylation,
    'U'   => BELV.Ubiquitination,
  }

  # protein variant
  PROTEIN_VARIANT = [:fus, :fusion, :sub, :substitution, :trunc, :truncation]

  def self.deep_freeze(array)
    if array.respond_to?(:to_a)
      array.each { |i| deep_freeze(i) }
      array.freeze
    end
  end
  private_class_method :deep_freeze

  RDFS_SCHEMA = deep_freeze([
    # Classes - Annotation Concept
    [BELV.AnnotationConcept, RDFS.subClassOf, SKOS.Concept],
    [BELV.AnnotationConceptScheme, RDFS.subClassOf, SKOS.ConceptScheme],

    # Classes - Namespace Concept
    [BELV.AbundanceConcept, RDFS.subClassOf, BELV.NamespaceConcept],
    [BELV.BiologicalProcessConcept, RDFS.subClassOf, BELV.NamespaceConcept],
    [BELV.ComplexConcept, RDFS.subClassOf, BELV.AbundanceConcept],
    [BELV.GeneConcept, RDFS.subClassOf, BELV.AbundanceConcept],
    [BELV.MicroRNAConcept, RDFS.subClassOf, BELV.RNAConcept],
    [BELV.NamespaceConceptScheme, RDFS.subClassOf, SKOS.ConceptScheme],
    [BELV.NamespaceConcept, RDFS.subClassOf, SKOS.Concept],
    [BELV.ProteinConcept, RDFS.subClassOf, BELV.AbundanceConcept],
    [BELV.RNAConcept, RDFS.subClassOf, BELV.AbundanceConcept],
    [BELV.PathologyConcept, RDFS.subClassOf, BELV.BiologicalProcessConcept],

    # Classes - Language Concepts
    [BELV.Abundance, RDF.type, RDFS.Class],
    [BELV.Activity, RDF.type, RDFS.Class],
    [BELV.Nanopub, RDF.type, RDFS.Class],
    [BELV.Modification, RDF.type, RDFS.Class],
    [BELV.Relationship, RDF.type, RDFS.Class],
    [BELV.Statement, RDF.type, RDFS.Class],
    [BELV.Term, RDF.type, RDFS.Class],

    # Classes - Relationships
    [BELV.Association, RDFS.subClassOf, BELV.CorrelativeRelationship],
    [BELV.BiomarkerFor, RDFS.subClassOf, BELV.Relationship],
    [BELV.CausesNoChange, RDFS.subClassOf, BELV.CausalRelationship],
    [BELV.CausalRelationship, RDFS.subClassOf, BELV.Relationship],
    [BELV.CorrelativeRelationship, RDFS.subClassOf, BELV.Relationship],
    [BELV.Decreases, RDFS.subClassOf, BELV.CausalRelationship],
    [BELV.Decreases, RDFS.subClassOf, BELV.NegativeRelationship],
    [BELV.DirectlyDecreases, RDFS.subClassOf, BELV.CausalRelationship],
    [BELV.DirectlyDecreases, RDFS.subClassOf, BELV.NegativeRelationship],
    [BELV.DirectlyDecreases, RDFS.subClassOf, BELV.DirectRelationship],
    [BELV.DirectlyDecreases, RDFS.subClassOf, BELV.Decreases],
    [BELV.DirectlyIncreases, RDFS.subClassOf, BELV.CausalRelationship],
    [BELV.DirectlyIncreases, RDFS.subClassOf, BELV.PositiveRelationship],
    [BELV.DirectlyIncreases, RDFS.subClassOf, BELV.DirectRelationship],
    [BELV.DirectlyIncreases, RDFS.subClassOf, BELV.Increases],
    [BELV.DirectRelationship, RDFS.subClassOf, BELV.Relationship],
    [BELV.HasComponent, RDFS.subClassOf, BELV.MembershipRelationship],
    [BELV.HasMember, RDFS.subClassOf, BELV.MembershipRelationship],
    [BELV.Increases, RDFS.subClassOf, BELV.CausalRelationship],
    [BELV.Increases, RDFS.subClassOf, BELV.PositiveRelationship],
    [BELV.IsA, RDFS.subClassOf, BELV.MembershipRelationship],
    [BELV.MembershipRelationship, RDFS.subClassOf, BELV.Relationship],
    [BELV.NegativeCorrelation, RDFS.subClassOf, BELV.CorrelativeRelationship],
    [BELV.NegativeCorrelation, RDFS.subClassOf, BELV.NegativeRelationship],
    [BELV.NegativeRelationship, RDFS.subClassOf, BELV.Relationship],
    [BELV.PositiveCorrelation, RDFS.subClassOf, BELV.CorrelativeRelationship],
    [BELV.PositiveCorrelation, RDFS.subClassOf, BELV.PositiveRelationship],
    [BELV.PositiveRelationship, RDFS.subClassOf, BELV.Relationship],
    [BELV.PrognosticBiomarkerFor, RDFS.subClassOf, BELV.BiomarkerFor],
    [BELV.RateLimitingStepOf, RDFS.subClassOf, BELV.Increases],
    [BELV.RateLimitingStepOf, RDFS.subClassOf, BELV.CausalRelationship],
    [BELV.RateLimitingStepOf, RDFS.subClassOf, BELV.SubProcessOf],
    [BELV.SubProcessOf, RDFS.subClassOf, BELV.MembershipRelationship],

    # Classes - Abundances
    [BELV.AbundanceActivity, RDFS.subClassOf, BELV.Process],
    [BELV.BiologicalProcess, RDFS.subClassOf, BELV.Process],
    [BELV.CellSecretion, RDFS.subClassOf, BELV.Translocation],
    [BELV.ComplexAbundance, RDFS.subClassOf, BELV.Abundance],
    [BELV.CompositeAbundance, RDFS.subClassOf, BELV.Abundance],
    [BELV.Degradation, RDFS.subClassOf, BELV.Transformation],
    [BELV.GeneAbundance, RDFS.subClassOf, BELV.Abundance],
    [BELV.MicroRNAAbundance, RDFS.subClassOf, BELV.Abundance],
    [BELV.ModifiedProteinAbundance, RDFS.subClassOf, BELV.ProteinAbundance],
    [BELV.Pathology, RDFS.subClassOf, BELV.BiologicalProcess],
    [BELV.Process, RDF.type, RDFS.Class],
    [BELV.ProteinAbundance, RDFS.subClassOf, BELV.Abundance],
    [BELV.ProteinVariantAbundance, RDFS.subClassOf, BELV.ProteinAbundance],
    [BELV.Reaction, RDFS.subClassOf, BELV.Transformation],
    [BELV.RNAAbundance, RDFS.subClassOf, BELV.Abundance],
    [BELV.Transformation, RDFS.subClassOf, BELV.Process],
    [BELV.Translocation, RDFS.subClassOf, BELV.Transformation],

    # Classes - Activities
    [BELV.Activity, RDFS.subClassOf, BELV.Activity],
    [BELV.Catalytic, RDFS.subClassOf, BELV.Activity],
    [BELV.Chaperone, RDFS.subClassOf, BELV.Activity],
    [BELV.GtpBound, RDFS.subClassOf, BELV.Activity],
    [BELV.Kinase, RDFS.subClassOf, BELV.Activity],
    [BELV.Peptidase, RDFS.subClassOf, BELV.Activity],
    [BELV.Phosphatase, RDFS.subClassOf, BELV.Activity],
    [BELV.Ribosylase, RDFS.subClassOf, BELV.Activity],
    [BELV.Transcription, RDFS.subClassOf, BELV.Activity],
    [BELV.Transport, RDFS.subClassOf, BELV.Activity],

    # Classes - Modifications
    [BELV.Acetylation, RDFS.subClassOf, BELV.Modification],
    [BELV.Farnesylation, RDFS.subClassOf, BELV.Modification],
    [BELV.Glycosylation, RDFS.subClassOf, BELV.Modification],
    [BELV.Hydroxylation, RDFS.subClassOf, BELV.Modification],
    [BELV.Methylation, RDFS.subClassOf, BELV.Modification],
    [BELV.Phosphorylation, RDFS.subClassOf, BELV.Modification],
    [BELV.Ribosylation, RDFS.subClassOf, BELV.Modification],
    [BELV.Sumoylation, RDFS.subClassOf, BELV.Modification],
    [BELV.Ubiquitination, RDFS.subClassOf, BELV.Modification],
    [BELV.PhosphorylationSerine, RDFS.subClassOf, BELV.Phosphorylation],
    [BELV.PhosphorylationTyrosine, RDFS.subClassOf, BELV.Phosphorylation],
    [BELV.PhosphorylationThreonine, RDFS.subClassOf, BELV.Phosphorylation],

    # Properties - BEL Term
    [BELV.hasActivityType, RDF.type, RDF.Property],
    [BELV.hasActivityType, RDFS.range, BELV.Activity],
    [BELV.hasActivityType, RDFS.domain, BELV.Term],
    [BELV.hasChild, RDF.type, RDF.Property],
    [BELV.hasChild, RDFS.range, BELV.Term],
    [BELV.hasChild, RDFS.domain, BELV.Term],
    [BELV.hasConcept, RDF.type, RDF.Property],
    [BELV.hasConcept, RDFS.range, BELV.NamespaceConcept],
    [BELV.hasConcept, RDFS.domain, BELV.Term],
    [BELV.hasModificationPosition, RDF.type, RDF.Property],
    [BELV.hasModificationPosition, RDFS.range, XSD.integer],
    [BELV.hasModificationPosition, RDFS.domain, BELV.Term],
    [BELV.hasModificationType, RDF.type, RDF.Property],
    [BELV.hasModificationType, RDFS.range, BELV.Activity],
    [BELV.hasModificationType, RDFS.domain, BELV.Term],

    # Properties - BEL Statement
    [BELV.hasNanopub, RDF.type, RDF.Property],
    [BELV.hasNanopub, RDFS.range, BELV.Nanopub],
    [BELV.hasNanopub, RDFS.domain, BELV.Statement],
    [BELV.hasObject, RDFS.subPropertyOf, BELV.hasChild],
    [BELV.hasObject, RDFS.range, BELV.Term],
    [BELV.hasObject, RDFS.domain, BELV.Statement],
    [BELV.hasRelationship, RDF.type, RDF.Property],
    [BELV.hasRelationship, RDFS.range, BELV.Relationship],
    [BELV.hasRelationship, RDFS.domain, BELV.Statement],
    [BELV.hasSubject, RDFS.subPropertyOf, BELV.hasChild],
    [BELV.hasSubject, RDFS.range, BELV.Term],
    [BELV.hasSubject, RDFS.domain, BELV.Statement],

    # Properties - Nanopub
    [BELV.hasAnnotation, RDF.type, RDF.Property],
    [BELV.hasAnnotation, RDFS.range, BELV.AnnotationConcept],
    [BELV.hasAnnotation, RDFS.domain, BELV.Nanopub],
    [BELV.hasCitation, RDF.type, RDF.Property],
    [BELV.hasCitation, RDFS.domain, BELV.Nanopub],
    [BELV.hasNanopubText, RDFS.range, XSD.string],
    [BELV.hasNanopubText, RDFS.domain, BELV.Nanopub],
    [BELV.hasStatement, RDF.type, RDF.Property],
    [BELV.hasStatement, RDFS.range, BELV.Statement],
    [BELV.hasStatement, RDFS.domain, BELV.Nanopub]
  ])

  def self.vocabulary_rdf
    RDFS_SCHEMA
  end
end
# vim: ts=2 sw=2:
