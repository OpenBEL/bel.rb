# vim: ts=2 sw=2:
module BEL
  module Language
    FUNCTIONS = {
      abundance: {
        short_form: :a,
        description: 'Denotes the abundance of an entity',
        signatures: ['abundance(E:A)abundance']
      },
      biologicalProcess: {
        short_form: :bp,
        description: 'Denotes a process or population of events',
        signatures: ['biologicalProcess(E:B)biologicalProcess']
      },
      catalyticActivity: {
        short_form: :cat,
        description: 'Denotes the frequency or abundance of events where a member acts as an enzymatic catalyst of biochecmial reactions',
        signatures: [
          'catalyticActivity(F:complexAbundance)abundance',
          'catalyticActivity(F:proteinAbundance)abundance'
        ]
      },
      cellSecretion: {
        short_form: :sec,
        description: 'Denotes the frequency or abundance of events in which members of an abundance move from cells to regions outside of the cells',
        signatures: ['cellSecretion(F:abundance)abundance']
      },
      cellSurfaceExpression: {
        short_form: :surf,
        description: 'Denotes the frequency or abundance of events in which members of an abundance move to the surface of cells',
        signatures: ['cellSurfaceExpression(F:abundance)abundance']
      },
      chaperoneActivity: {
        short_form: :chap,
        description: 'Denotes the frequency or abundance of events in which a member binds to some substrate and acts as a chaperone for the substrate',
        signatures: [
          'chaperoneActivity(F:complexAbundance)abundance',
          'chaperoneActivity(F:proteinAbundance)abundance'
        ]
      },
      complexAbundance: {
        short_form: :complex,
        description: 'Denotes the abundance of a molecular complex',
        signatures: [
          'complexAbundance(E:A)complexAbundance',
          'complexAbundance(F:abundance...)complexAbundance'
        ]
      },
      degradation: {
        short_form: :deg,
        description: 'Denotes the frequency or abundance of events in which a member is degraded in some way such that it is no longer a member',
        signatures: ['degradation(F:abundance)abundance']
      },
      fusion: {
        short_form: :fus,
        description: 'Specifies the abundance of a protein translated from the fusion of a gene',
        signatures: [
          'fusion(E:G)fusion',
          'fusion(E:G,E:*,E:*)fusion',
          'fusion(E:P)fusion',
          'fusion(E:P,E:*,E:*)fusion',
          'fusion(E:R)fusion',
          'fusion(E:R,E:*,E:*)fusion'
        ]
      },
      geneAbundance: {
        short_form: :g,
        description: 'Denotes the abundance of a gene',
        signatures: [
          'geneAbundance(E:G)geneAbundance',
          'geneAbundance(E:G,F:fusion)geneAbundance'
        ]
      },
      gtpBoundActivity: {
        short_form: :gtp,
        description: 'Denotes the frequency or abundance of events in which a member of a G-protein abundance is GTP-bound',
        signatures: [
          'gtpBoundActivity(F:complexAbundance)abundance',
          'gtpBoundActivity(F:proteinAbundance)abundance'
        ]
      },
      kinaseActivity: {
        short_form: :kin,
        description: 'Denotes the frequency or abundance of events in which a member acts as a kinase, performing enzymatic phosphorylation of a substrate',
        signatures: [
          'kinaseActivity(F:complexAbundance)abundance',
          'kinaseActivity(F:proteinAbundance)abundance'
        ]
      },
      list: {
        short_form: :list,
        description: 'Groups a list of terms together',
        signatures: [
          'list(E:A...)list',
          'list(F:abundance...)list'
        ]
      },
      microRNAAbundance: {
        short_form: :m,
        description: 'Denotes the abundance of a processed, functional microRNA',
        signatures: [
          'microRNAAbundance(E:M)microRNAAbundance'
        ]
      },
      molecularActivity: {
        short_form: :act,
        description: 'Denotes the frequency or abundance of events in which a member acts as a causal agent at the molecular scale',
        signatures: [
          'molecularActivity(F:abundance)abundance'
        ]
      },
      pathology: {
        short_form: :path,
        description: 'Denotes a disease or pathology process',
        signatures: [
          'pathology(E:O)pathology'
        ]
      },
      peptidaseActivity: {
        short_form: :pep,
        description: 'Denotes the frequency or abundance of events in which a member acts to cleave a protein',
        signatures: [
          'peptidaseActivity(F:complexAbundance)abundance',
          'peptidaseActivity(F:proteinAbundance)abundance'
        ]
      },
      phosphataseActivity: {
        short_form: :phos,
        description: 'Denotes the frequency or abundance of events in which a member acts as a phosphatase',
        signatures: [
          'phosphataseActivity(F:complexAbundance)abundance',
          'phosphataseActivity(F:proteinAbundance)abundance']
      },
      products: {
        short_form: :products,
        description: 'Denotes the products of a reaction',
        signatures: [
          'products(F:abundance...)products'
        ]
      },
      proteinAbundance: {
        short_form: :p,
        description: 'Denotes the abundance of a protein',
        signatures: [
          'proteinAbundance(E:P)proteinAbundance',
          'proteinAbundance(E:P,F:proteinModification)proteinAbundance',
          'proteinAbundance(E:P,F:substitution)proteinAbundance',
          'proteinAbundance(E:P,F:fusion)proteinAbundance',
          'proteinAbundance(E:P,F:truncation)proteinAbundance'
        ]
      },
      reactants: {
        short_form: :reactants,
        description: 'Denotes the reactants of a reaction',
        signatures: [
          'reactants(F:abundance...)reactants'
        ]
      },
      reaction: {
        short_form: :rxn,
        description: 'Denotes the frequency or abundance of events in a reaction',
        signatures: [
          'reaction(F:reactants,F:products)abundance'
        ]
      },
      ribosylationActivity: {
        short_form: :ribo,
        description: 'Denotes the frequency or abundance of events in which a member acts to perform post-translational modification of proteins',
        signatures: [
          'ribosylationActivity(F:complexAbundance)abundance',
          'ribosylationActivity(F:proteinAbundance)abundance'
        ]
      },
      rnaAbundance: {
        short_form: :r,
        description: 'Denotes the abundance of a gene',
        signatures: [
          'rnaAbundance(E:R)geneAbundance',
          'rnaAbundance(E:R,F:fusion)geneAbundance'
        ]
      },
      substitution: {
        short_form: :sub,
        description: 'Indicates the abundance of proteins with amino acid substitution sequence',
        signatures: [
          'substitution(E:*,E:*,E:*)substitution'
        ]
      },
      transcriptionalActivity: {
        short_form: :tscript,
        description: 'Denotes the frequency or abundance of events in which a member directly acts to control transcription of genes',
        signatures: [
          'transcriptionalActivity(F:complexAbundance)abundance',
          'transcriptionalActivity(F:proteinAbundance)abundance'
        ]
      },
      translocation: {
        short_form: :tloc,
        description: 'Denotes the frequency or abundance of events in which members move between locations',
        signatures: [
          'translocation(F:abundance,E:A,E:A)abundance'
        ]
      },
      transportActivity: {
        short_form: :tport,
        description: 'Denotes the frequency or abundance of events in which a member directs acts to enable the directed movement of substances into, out of, within, or between cells',
        signatures: [
          'transportActivity(F:complexAbundance)abundance',
          'transportActivity(F:proteinAbundance)abundance']
      },
      truncation: {
        short_form: :trunc,
        description: 'Indicates an abundance of proteins with truncation sequence variants',
        signatures: [
          'truncation(E:*)truncation'
        ]
      }
    }

    RELATIONSHIPS = [
      :actsIn,
      :analogous,
      :association,
      :biomarkerFor,
      :causesNoChange,
      :decreases,
      :directlyDecreases,
      :directlyIncreases,
      :hasComponent, :hasComponents,
      :hasMember, :hasMembers,
      :hasModification,
      :hasProduct,
      :hasVariant,
      :includes,
      :increases,
      :isA,
      :negativeCorrelation,
      :orthologous,
      :positiveCorrelation,
      :prognosticBiomarkerFor,
      :rateLimitingStepOf,
      :reactantIn,
      :subProcessOf,
      :transcribedTo,
      :translatedTo,
      :translocates
    ]

    class Parameter
      include Comparable

      attr_reader :ns_def
      attr_reader :value
      attr_reader :enc

      def initialize(ns_def, value, enc)
        @ns_def = ns_def
        @value = value
        @enc = enc
      end

      def <=>(other)
        ns_compare = ns_def <=> other.ns_def
        if ns_compare == 0
          value <=> other.value
        else
          ns_compare
        end
      end
    end

    class Statement
      attr_accessor :subject
      attr_accessor :relationship
      attr_accessor :object
    end

    class Term
      include Comparable

      attr_reader :fx
      attr_reader :arguments

      def initialize(fx, *arguments)
        @fx = fx
        @arguments = arguments
      end

      def <<(argument)
        @arguments << argument
      end

      def valid?
        true
      end
    end

    RELATIONSHIPS.each do |rel|
      Term.send(:define_method, rel) do |another|
        s = Statement.new
        s.subject = self
        s.relationship = rel
        s.object = another
        s
      end
    end
    FUNCTIONS.each do |fx, metadata|
      Language.send(:define_method, fx) do |*args|
        Term.new(fx, *args)
      end
      Language.send(:define_method, metadata[:short_form]) do |*args|
        Term.new(fx, *args)
      end
    end
  end
end
