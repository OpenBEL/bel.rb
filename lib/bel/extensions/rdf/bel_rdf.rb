# vim: ts=2 sw=2:
# Defines the RDF vocabulary for BEL structures.

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
      a:                       BELV.Abundance,
      abundance:               BELV.Abundance,
      g:                       BELV.GeneAbundance,
      geneAbundance:           BELV.GeneAbundance,
      p:                       BELV.ProteinAbundance,
      proteinAbundance:        BELV.ProteinAbundance,
      r:                       BELV.RNAAbundance,
      rnaAbundance:            BELV.RNAAbundance,
      m:                       BELV.microRNAAbundance,
      microRNAAbundance:       BELV.microRNAAbundance,
      complex:                 BELV.ComplexAbundance,
      complexAbundance:        BELV.ComplexAbundance,
      composite:               BELV.CompositeAbundance,
      compositeAbundance:      BELV.CompositeAbundance,
      bp:                      BELV.BiologicalProcess,
      biologicalProcess:       BELV.BiologicalProcess,
      path:                    BELV.Pathology,
      pathology:               BELV.Pathology,
      rxn:                     BELV.Reaction,
      reaction:                BELV.Reaction,
      tloc:                    BELV.Translocation,
      translocation:           BELV.Translocation,
      sec:                     BELV.CellSecretion,
      cellSecretion:           BELV.CellSecretion,
      deg:                     BELV.Degradation,
      degradation:             BELV.Degradation,
      cat:                     BELV.AbundanceActivity,
      catalyticActivity:       BELV.AbundanceActivity,
      chap:                    BELV.AbundanceActivity,
      chaperoneActivity:       BELV.AbundanceActivity,
      gtp:                     BELV.AbundanceActivity,
      gtpBoundActivity:        BELV.AbundanceActivity,
      kin:                     BELV.AbundanceActivity,
      kinaseActivity:          BELV.AbundanceActivity,
      act:                     BELV.AbundanceActivity,
      molecularActivity:       BELV.AbundanceActivity,
      pep:                     BELV.AbundanceActivity,
      peptidaseActivity:       BELV.AbundanceActivity,
      phos:                    BELV.AbundanceActivity,
      phosphataseActivity:     BELV.AbundanceActivity,
      ribo:                    BELV.AbundanceActivity,
      ribosylationActivity:    BELV.AbundanceActivity,
      tscript:                 BELV.AbundanceActivity,
      transcriptionalActivity: BELV.AbundanceActivity,
      tport:                   BELV.AbundanceActivity,
      transportActivity:       BELV.AbundanceActivity
    }

    RELATIONSHIP_TYPE = {
        'association'            => BELV.Association,
        '--'                     => BELV.Association,
        'biomarkerFor'           => BELV.BiomarkerFor,
        'causesNoChange'         => BELV.CausesNoChange,
        'decreases'              => BELV.Decreases,
        '-|'                     => BELV.Decreases,
        'directlyDecreases'      => BELV.DirectlyDecreases,
        '=|'                     => BELV.DirectlyDecreases,
        'directlyIncreases'      => BELV.DirectlyIncreases,
        '=>'                     => BELV.DirectlyIncreases,
        'hasComponent'           => BELV.HasComponent,
        'hasMember'              => BELV.HasMember,
        'increases'              => BELV.Increases,
        '->'                     => BELV.Increases,
        'isA'                    => BELV.IsA,
        'negativeCorrelation'    => BELV.NegativeCorrelation,
        'positiveCorrelation'    => BELV.PositiveCorrelation,
        'prognosticBiomarkerFor' => BELV.PrognosticBiomarkerFor,
        'rateLimitingStepOf'     => BELV.RateLimitingStepOf,
        'subProcessOf'           => BELV.SubProcessOf,
        ':>'                     => BELV.TranscribedTo,
        '>>'                     => BELV.TranslatedTo,

        # Supported by schema
        # 'actsIn'               => BELV.ActsIn, # (BELV.hasChild)

        # Unsupported in schema
        #'analogous'              => BELV.Analogous,
        #'hasModification'        => BELV.HasModification,
        #'hasProduct'             => BELV.HasProduct,
        #'hasVariant'             => BELV.HasVariant,
        #'includes'               => BELV.Includes,
        #'orthologous'            => BELV.Orthologous,
        #'reactantIn'             => BELV.ReactantIn,
        #'transcribedTo'          => BELV.TranscribedTo,
        #'translatedTo'           => BELV.TranslatedTo,
        #'translocates'           => BELV.Translocates,

        # Macro statements - TODO needs parser AST translation
        #'hasComponents'          => BELV.HasComponents,
        #'hasMembers'             => BELV.HasMembers,
    }

    RELATIONSHIP_CLASSIFICATION = {
        :'association'            => BELV.CorrelativeRelationship,
        :'--'                     => BELV.CorrelativeRelationship,
        :'biomarkerFor'           => BELV.BiomarkerFor,
        :'causesNoChange'         => BELV.CausesNoChange,
        :'decreases'              => BELV.Decreases,
        :'-|'                     => BELV.Decreases,
        :'directlyDecreases'      => BELV.DirectlyDecreases,
        :'=|'                     => BELV.DirectlyDecreases,
        :'directlyIncreases'      => BELV.DirectlyIncreases,
        :'=>'                     => BELV.DirectlyIncreases,
        :'hasComponent'           => BELV.HasComponent,
        :'hasMember'              => BELV.HasMember,
        :'increases'              => BELV.Increases,
        :'->'                     => BELV.Increases,
        :'isA'                    => BELV.IsA,
        :'negativeCorrelation'    => BELV.NegativeCorrelation,
        :'positiveCorrelation'    => BELV.PositiveCorrelation,
        :'prognosticBiomarkerFor' => BELV.PrognosticBiomarkerFor,
        :'rateLimitingStepOf'     => BELV.RateLimitingStepOf,
        :'subProcessOf'           => BELV.SubProcessOf
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
        # Classes
          # Concept - Annotations
          [BELV.AnnotationConcept, RDF::RDFS.subClassOf, RDF::SKOS.Concept],
          [BELV.AnnotationConceptScheme, RDF::RDFS.subClassOf, RDF::SKOS.ConceptScheme],
          # Concept - Namespaces
          [BELV.AbundanceConcept, RDF::RDFS.subClassOf, BELV.NamespaceConcept],
          [BELV.BiologicalProcessConcept, RDF::RDFS.subClassOf, BELV.NamespaceConcept],
          [BELV.ComplexConcept, RDF::RDFS.subClassOf, BELV.AbundanceConcept],
          [BELV.GeneConcept, RDF::RDFS.subClassOf, BELV.AbundanceConcept],
          [BELV.MicroRNAConcept, RDF::RDFS.subClassOf, BELV.RNAConcept],
          [BELV.NamespaceConceptScheme, RDF::RDFS.subClassOf, RDF::SKOS.ConceptScheme],
          [BELV.NamespaceConcept, RDF::RDFS.subClassOf, RDF::SKOS.Concept],
          [BELV.ProteinConcept, RDF::RDFS.subClassOf, BELV.AbundanceConcept],
          [BELV.RNAConcept, RDF::RDFS.subClassOf, BELV.AbundanceConcept],
          [BELV.PathologyConcept, RDF::RDFS.subClassOf, BELV.BiologicalProcessConcept],
          # BEL Language
          [BELV.Abundance, RDF.type, RDF::RDFS.Class],
          [BELV.Activity, RDF.type, RDF::RDFS.Class],
          [BELV.Evidence, RDF.type, RDF::RDFS.Class],
          [BELV.Modification, RDF.type, RDF::RDFS.Class],
          [BELV.Relationship, RDF.type, RDF::RDFS.Class],
          [BELV.Statement, RDF.type, RDF::RDFS.Class],
          [BELV.Term, RDF.type, RDF::RDFS.Class],
          # Relationships
          [BELV.Association, RDF::RDFS.subClassOf, BELV.CorrelativeRelationship],
          [BELV.BiomarkerFor, RDF::RDFS.subClassOf, BELV.Relationship],
          [BELV.CausesNoChange, RDF::RDFS.subClassOf, BELV.CausalRelationship],
          [BELV.CausalRelationship, RDF::RDFS.subClassOf, BELV.Relationship],
          [BELV.CorrelativeRelationship, RDF::RDFS.subClassOf, BELV.Relationship],
          [BELV.Decreases, RDF::RDFS.subClassOf, BELV.CausalRelationship],
          [BELV.Decreases, RDF::RDFS.subClassOf, BELV.NegativeRelationship],
          [BELV.DirectlyDecreases, RDF::RDFS.subClassOf, BELV.CausalRelationship],
          [BELV.DirectlyDecreases, RDF::RDFS.subClassOf, BELV.NegativeRelationship],
          [BELV.DirectlyDecreases, RDF::RDFS.subClassOf, BELV.DirectRelationship],
          [BELV.DirectlyDecreases, RDF::RDFS.subClassOf, BELV.Decreases],
          [BELV.DirectlyIncreases, RDF::RDFS.subClassOf, BELV.CausalRelationship],
          [BELV.DirectlyIncreases, RDF::RDFS.subClassOf, BELV.PositiveRelationship],
          [BELV.DirectlyIncreases, RDF::RDFS.subClassOf, BELV.DirectRelationship],
          [BELV.DirectlyIncreases, RDF::RDFS.subClassOf, BELV.Increases],
          [BELV.DirectRelationship, RDF::RDFS.subClassOf, BELV.Relationship],
          [BELV.HasComponent, RDF::RDFS.subClassOf, BELV.MembershipRelationship],
          [BELV.HasMember, RDF::RDFS.subClassOf, BELV.MembershipRelationship],
          [BELV.Increases, RDF::RDFS.subClassOf, BELV.CausalRelationship],
          [BELV.Increases, RDF::RDFS.subClassOf, BELV.PositiveRelationship],
          [BELV.IsA, RDF::RDFS.subClassOf, BELV.MembershipRelationship],
          [BELV.MembershipRelationship, RDF::RDFS.subClassOf, BELV.Relationship],
          [BELV.NegativeCorrelation, RDF::RDFS.subClassOf, BELV.CorrelativeRelationship],
          [BELV.NegativeCorrelation, RDF::RDFS.subClassOf, BELV.NegativeRelationship],
          [BELV.NegativeRelationship, RDF::RDFS.subClassOf, BELV.Relationship],
          [BELV.PositiveCorrelation, RDF::RDFS.subClassOf, BELV.CorrelativeRelationship],
          [BELV.PositiveCorrelation, RDF::RDFS.subClassOf, BELV.PositiveRelationship],
          [BELV.PositiveRelationship, RDF::RDFS.subClassOf, BELV.Relationship],
          [BELV.PrognosticBiomarkerFor, RDF::RDFS.subClassOf, BELV.BiomarkerFor],
          [BELV.RateLimitingStepOf, RDF::RDFS.subClassOf, BELV.Increases],
          [BELV.RateLimitingStepOf, RDF::RDFS.subClassOf, BELV.CausalRelationship],
          [BELV.RateLimitingStepOf, RDF::RDFS.subClassOf, BELV.SubProcessOf],
          [BELV.SubProcessOf, RDF::RDFS.subClassOf, BELV.MembershipRelationship],
          # Abundances
          [BELV.AbundanceActivity, RDF::RDFS.subClassOf, BELV.Process],
          [BELV.BiologicalProcess, RDF::RDFS.subClassOf, BELV.Process],
          [BELV.CellSecretion, RDF::RDFS.subClassOf, BELV.Translocation],
          [BELV.ComplexAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
          [BELV.CompositeAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
          [BELV.Degradation, RDF::RDFS.subClassOf, BELV.Transformation],
          [BELV.GeneAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
          [BELV.MicroRNAAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
          [BELV.ModifiedProteinAbundance, RDF::RDFS.subClassOf, BELV.ProteinAbundance],
          [BELV.Pathology, RDF::RDFS.subClassOf, BELV.BiologicalProcess],
          [BELV.Process, RDF.type, RDF::RDFS.Class],
          [BELV.ProteinAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
          [BELV.ProteinVariantAbundance, RDF::RDFS.subClassOf, BELV.ProteinAbundance],
          [BELV.Reaction, RDF::RDFS.subClassOf, BELV.Transformation],
          [BELV.RNAAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
          [BELV.Transformation, RDF::RDFS.subClassOf, BELV.Process],
          [BELV.Translocation, RDF::RDFS.subClassOf, BELV.Transformation],
          # Activities
          [BELV.Activity, RDF::RDFS.subClassOf, BELV.Activity],
          [BELV.Catalytic, RDF::RDFS.subClassOf, BELV.Activity],
          [BELV.Chaperone, RDF::RDFS.subClassOf, BELV.Activity],
          [BELV.GtpBound, RDF::RDFS.subClassOf, BELV.Activity],
          [BELV.Kinase, RDF::RDFS.subClassOf, BELV.Activity],
          [BELV.Peptidase, RDF::RDFS.subClassOf, BELV.Activity],
          [BELV.Phosphatase, RDF::RDFS.subClassOf, BELV.Activity],
          [BELV.Ribosylase, RDF::RDFS.subClassOf, BELV.Activity],
          [BELV.Transcription, RDF::RDFS.subClassOf, BELV.Activity],
          [BELV.Transport, RDF::RDFS.subClassOf, BELV.Activity],
          # Modifications
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

        # Properties
          # Term
          [BELV.hasActivityType, RDF.type, RDF.Property],
          [BELV.hasActivityType, RDF::RDFS.range, BELV.Activity],
          [BELV.hasActivityType, RDF::RDFS.domain, BELV.Term],
          [BELV.hasChild, RDF.type, RDF.Property],
          [BELV.hasChild, RDF::RDFS.range, BELV.Term],
          [BELV.hasChild, RDF::RDFS.domain, BELV.Term],
          [BELV.hasConcept, RDF.type, RDF.Property],
          [BELV.hasConcept, RDF::RDFS.range, BELV.NamespaceConcept],
          [BELV.hasConcept, RDF::RDFS.domain, BELV.Term],
          [BELV.hasModificationPosition, RDF.type, RDF.Property],
          [BELV.hasModificationPosition, RDF::RDFS.range, RDF::XSD.integer],
          [BELV.hasModificationPosition, RDF::RDFS.domain, BELV.Term],
          [BELV.hasModificationType, RDF.type, RDF.Property],
          [BELV.hasModificationType, RDF::RDFS.range, BELV.Activity],
          [BELV.hasModificationType, RDF::RDFS.domain, BELV.Term],
          # Statement
          [BELV.hasEvidence, RDF.type, RDF.Property],
          [BELV.hasEvidence, RDF::RDFS.range, BELV.Evidence],
          [BELV.hasEvidence, RDF::RDFS.domain, BELV.Statement],
          [BELV.hasObject, RDF::RDFS.subPropertyOf, BELV.hasChild],
          [BELV.hasObject, RDF::RDFS.range, BELV.Term],
          [BELV.hasObject, RDF::RDFS.domain, BELV.Statement],
          [BELV.hasRelationship, RDF.type, RDF.Property],
          [BELV.hasRelationship, RDF::RDFS.range, BELV.Relationship],
          [BELV.hasRelationship, RDF::RDFS.domain, BELV.Statement],
          [BELV.hasSubject, RDF::RDFS.subPropertyOf, BELV.hasChild],
          [BELV.hasSubject, RDF::RDFS.range, BELV.Term],
          [BELV.hasSubject, RDF::RDFS.domain, BELV.Statement],
          # Evidence
          [BELV.hasAnnotation, RDF.type, RDF.Property],
          [BELV.hasAnnotation, RDF::RDFS.range, BELV.AnnotationConcept],
          [BELV.hasAnnotation, RDF::RDFS.domain, BELV.Evidence],
          [BELV.hasCitation, RDF.type, RDF.Property],
          [BELV.hasCitation, RDF::RDFS.domain, BELV.Evidence],
          [BELV.hasEvidenceText, RDF::RDFS.range, RDF::XSD.string],
          [BELV.hasEvidenceText, RDF::RDFS.domain, BELV.Evidence],
          [BELV.hasStatement, RDF.type, RDF.Property],
          [BELV.hasStatement, RDF::RDFS.range, BELV.Statement],
          [BELV.hasStatement, RDF::RDFS.domain, BELV.Evidence]
      ]
    end
  end
end
