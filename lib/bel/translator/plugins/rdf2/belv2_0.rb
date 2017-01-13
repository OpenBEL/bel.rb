require 'rdf'
require 'rdf/turtle'
require 'rdf/vocab'

module BEL
  module BELRDF

    # Vocabulary constant for Nanopub instances (non-strict).
    BELN   = RDF::Vocabulary.new('http://www.openbel.org/nanopub/')
    BELR   = RDF::Vocabulary.new('http://www.openbel.org/bel/')
    PUBMED = RDF::Vocabulary.new('http://bio2rdf.org/pubmed:')

    class BELV2_0 < RDF::StrictVocabulary('http://www.openbel.org/vocabulary/')
      RDFS = RDF::Vocab::RDFS
      SKOS = RDF::Vocab::SKOS
      XSD  = RDF::Vocab::XSD

      # Concept classes
      term :AnnotationConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => SKOS.Concept
      term :AnnotationConceptScheme,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => SKOS.ConceptScheme
      term :NamespaceConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => SKOS.Concept
      term :NamespaceConceptScheme,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => SKOS.ConceptScheme
      term :AbundanceConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.NamespaceConcept
      term :BiologicalProcessConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.NamespaceConcept
      term :ComplexConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.AbundanceConcept
      term :CompositeConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.AbundanceConcept
      term :GeneConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.AbundanceConcept
      term :LocationConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.NamespaceConcept
      term :RNAConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.AbundanceConcept
      term :MicroRNAConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.RNAConcept
      term :MolecularActivityConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.NamespaceConcept
      term :PathologyConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.BiologicalProcessConcept
      term :ProteinConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.AbundanceConcept
      term :ProteinModificationConcept,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.NamespaceConcept

      # Nanopub classes
      term :Abundance,
        RDF.type           => RDFS.Class
      term :Nanopub,
        RDF.type           => RDFS.Class
      term :Process,
        RDF.type           => RDFS.Class
      term :Relationship,
        RDF.type           => RDFS.Class
      term :Statement,
        RDF.type           => RDFS.Class
      term :Term,
        RDF.type           => RDFS.Class

      # BiologicalExpressionLanguage class
      term :BiologicalExpressionLanguage,
        RDF.type           => RDFS.Class

      # Relationship categories
      term :CausalRelationship,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Relationship
      term :CorrelativeRelationship,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Relationship
      term :DirectRelationship,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Relationship
      term :GenomicRelationship,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Relationship
      term :MembershipRelationship,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Relationship
      term :NegativeRelationship,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Relationship
      term :PositiveRelationship,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Relationship

      # Relationship types
      term :Analogous,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.GenomicRelationship
      term :BiomarkerFor,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Relationship
      term :Association,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.CorrelativeRelationship
      term :CausesNoChange,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.CausalRelationship
      term :Decreases,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => [
          BELV2_0.CausalRelationship,
          BELV2_0.NegativeRelationship
        ]
      term :DirectlyDecreases,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => [
          BELV2_0.CausalRelationship,
          BELV2_0.Decreases,
          BELV2_0.DirectRelationship,
          BELV2_0.NegativeRelationship
        ]
      term :Increases,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.CausalRelationship
      term :DirectlyIncreases,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => [
          BELV2_0.CausalRelationship,
          BELV2_0.DirectRelationship,
          BELV2_0.Increases,
          BELV2_0.PositiveRelationship
        ]
      term :HasComponent,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.MembershipRelationship
      term :HasMember,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.MembershipRelationship
      term :IsA,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.MembershipRelationship
      term :NegativeCorrelation,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => [
          BELV2_0.CorrelativeRelationship,
          BELV2_0.NegativeRelationship
        ]
      term :Orthologous,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.GenomicRelationship
      term :PositiveCorrelation,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => [
          BELV2_0.CorrelativeRelationship,
          BELV2_0.PositiveRelationship
        ]
      term :PrognosticBiomarkerFor,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.BiomarkerFor
      term :SubProcessOf,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.MembershipRelationship
      term :RateLimitingStepOf,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => [
          BELV2_0.CausalRelationship, BELV2_0.Increases, BELV2_0.SubProcessOf
        ]
      term :Regulates,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.CausalRelationship
      term :TranscribedTo,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.GenomicRelationship
      term :TranslatedTo,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.GenomicRelationship

      # Process classes
      term :BiologicalProcess,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Process
      term :Transformation,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Process
      term :Translocation,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Transformation
      term :CellSecretion,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Translocation
      term :CellSurfaceExpression,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Translocation
      term :Degradation,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Transformation
      term :Pathology,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.BiologicalProcess
      term :Reaction,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Transformation

      # Abundance classes
      term :ComplexAbundance,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Abundance
      term :CompositeAbundance,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Abundance
      term :FusionAbundance,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Abundance
      term :GeneAbundance,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Abundance
      term :MicroRNAAbundance,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Abundance
      term :ProteinAbundance,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Abundance
      term :ModifiedProteinAbundance,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.ProteinAbundance
      term :RNAAbundance,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Abundance

      # Molecular activities e.g. act(p(HGNC:FOXO1), ma(tscript))
      term :Activity,
        RDF.type           => RDFS.Class,
        RDFS.subClassOf    => BELV2_0.Process

      # Protein modification
      term :ProteinModification,
        RDF.type           => RDFS.Class

      # Molecular activity properties
      property :hasActivityAbundance,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Activity,
        RDFS.range         => BELV2_0.Abundance
      property :hasActivityType,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Activity,
        RDFS.range         => BELV2_0.MolecularActivityConcept

      # Fusion properties
      property :hasBeginAbundance,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.FusionAbundance,
        RDFS.range         => BELV2_0.Abundance
      property :hasBeginRange,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.FusionAbundance,
        RDFS.range         => XSD.string
      property :hasEndAbundance,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.FusionAbundance,
        RDFS.range         => BELV2_0.Abundance
      property :hasEndRange,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.FusionAbundance,
        RDFS.range         => XSD.string

      # Protein modification properties
      property :hasModifiedProteinAbundance,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.ProteinAbundance,
        RDFS.range         => BELV2_0.ModifiedProteinAbundance
      property :hasProteinModification,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.ModifiedProteinAbundance,
        RDFS.range         => BELV2_0.ProteinModification
      property :hasProteinModificationType,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.ProteinModification,
        RDFS.range         => BELV2_0.ProteinModificationConcept
      property :hasAminoAcid,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.ProteinModification,
        RDFS.range         => XSD.string
      property :hasProteinResidue,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.ProteinModification,
        RDFS.range         => XSD.integer

      # Reaction properties
      property :hasProduct,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Reaction,
        RDFS.range         => BELV2_0.Abundance
      property :hasReactant,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Reaction,
        RDFS.range         => BELV2_0.Abundance


      # Variant properties
      property :hasVariant,
        RDF.type           => RDF.Property,
        RDFS.domain        => [
          BELV2_0.GeneAbundance,
          BELV2_0.MicroRNAAbundance,
          BELV2_0.ProteinAbundance,
          BELV2_0.RNAAbundance
        ],
        RDFS.range         => XSD.string

      # Cellular location properties
      property :hasLocation,
        RDF.type           => RDF.Property,
        RDFS.domain        => [
          BELV2_0.ComplexAbundance,
          BELV2_0.GeneAbundance,
          BELV2_0.MicroRNAAbundance,
          BELV2_0.ProteinAbundance,
          BELV2_0.RNAAbundance
        ],
        RDFS.range         => BELV2_0.LocationConcept
      property :hasFromLocation,
        RDF.type           => RDF.Property,
        RDFS.subPropertyOf => BELV2_0.hasLocation,
        RDFS.domain        => BELV2_0.Translocation,
        RDFS.range         => BELV2_0.LocationConcept
      property :hasToLocation,
        RDF.type           => RDF.Property,
        RDFS.subPropertyOf => BELV2_0.hasLocation,
        RDFS.domain        => BELV2_0.Translocation,
        RDFS.range         => BELV2_0.LocationConcept

      # Fragment properties
      property :hasFragmentRange,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.ProteinAbundance,
        RDFS.range         => XSD.string
      property :hasFragmentDescriptor,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.ProteinAbundance,
        RDFS.range         => XSD.string

      # Term properties
      property :hasChild,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Term,
        RDFS.range         => BELV2_0.Term
      property :hasConcept,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Term,
        RDFS.range         => BELV2_0.NamespaceConcept

      # Statement properties
      property :hasSubject,
        RDF.type           => RDF.Property,
        RDFS.subPropertyOf => BELV2_0.hasChild,
        RDFS.domain        => BELV2_0.Statement,
        RDFS.range         => BELV2_0.Term
      property :hasRelationship,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Statement,
        RDFS.range         => BELV2_0.Relationship
      property :hasObject,
        RDF.type           => RDF.Property,
        RDFS.subPropertyOf => BELV2_0.hasChild,
        RDFS.domain        => BELV2_0.Statement,
        RDFS.range         => BELV2_0.Term
      property :hasNanopub,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Statement,
        RDFS.range         => BELV2_0.Nanopub

      # Nanopub properties
      property :hasAnnotation,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Nanopub,
        RDFS.range         => BELV2_0.AnnotationConcept
      property :hasCitation,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Nanopub,
        RDFS.range         => RDFS.Resource
      property :hasSupport,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Nanopub,
        RDFS.range         => XSD.string
      property :hasStatement,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Nanopub,
        RDFS.range         => BELV2_0.Statement
      property :hasBiologicalExpressionLanguage,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.Nanopub,
        RDFS.range         => BELV2_0.BiologicalExpressionLanguage

      # BiologicalExpressionLanguage properties
      property :hasVersion,
        RDF.type           => RDF.Property,
        RDFS.domain        => BELV2_0.BiologicalExpressionLanguage,
        RDFS.range         => XSD.string
    end
  end
end
