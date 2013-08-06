# vim: ts=2 sw=2:
module BEL
  module Language
    FUNCTIONS = {
      abundance: {
        short_form: :a,
        long_form: :abundance,
        description: 'Denotes the abundance of an entity',
        return_type: :a,
        signatures: ['a(E:A)a']
      },
      biologicalProcess: {
        short_form: :bp,
        long_form: :biologicalProcess,
        description: 'Denotes a process or population of events',
        return_type: :bp,
        signatures: ['bp(E:B)bp']
      },
      catalyticActivity: {
        short_form: :cat,
        long_form: :catalyticActivity,
        description: 'Denotes the frequency or abundance of events where a member acts as an enzymatic catalyst of biochecmial reactions',
        return_type: :a,
        signatures: [
          'cat(F:complex)a',
          'cat(F:p)a'
        ]
      },
      cellSecretion: {
        short_form: :sec,
        long_form: :cellSecretion,
        description: 'Denotes the frequency or abundance of events in which members of an abundance move from cells to regions outside of the cells',
        return_type: :a,
        signatures: ['sec(F:a)a']
      },
      cellSurfaceExpression: {
        short_form: :surf,
        long_form: :cellSurfaceExpression,
        description: 'Denotes the frequency or abundance of events in which members of an abundance move to the surface of cells',
        return_type: :a,
        signatures: ['surf(F:a)a']
      },
      chaperoneActivity: {
        short_form: :chap,
        long_form: :chaperoneActivity,
        description: 'Denotes the frequency or abundance of events in which a member binds to some substrate and acts as a chaperone for the substrate',
        return_type: :a,
        signatures: [
          'chap(F:complex)a',
          'chap(F:p)a'
        ]
      },
      complexAbundance: {
        short_form: :complex,
        long_form: :complexAbundance,
        description: 'Denotes the abundance of a molecular complex',
        return_type: :complex,
        signatures: [
          'complex(E:A)complex',
          'complex(F:a...)complex'
        ]
      },
      degradation: {
        short_form: :deg,
        long_form: :degradation,
        description: 'Denotes the frequency or abundance of events in which a member is degraded in some way such that it is no longer a member',
        return_type: :a,
        signatures: ['deg(F:a)a']
      },
      fusion: {
        short_form: :fus,
        long_form: :fusion,
        description: 'Specifies the abundance of a protein translated from the fusion of a gene',
        return_type: :fus,
        signatures: [
          'fus(E:G)fus',
          'fus(E:G,E:*,E:*)fus',
          'fus(E:P)fus',
          'fus(E:P,E:*,E:*)fus',
          'fus(E:R)fus',
          'fus(E:R,E:*,E:*)fus'
        ]
      },
      geneAbundance: {
        short_form: :g,
        long_form: :geneAbundance,
        description: 'Denotes the abundance of a gene',
        return_type: :g,
        signatures: [
          'g(E:G)g',
          'g(E:G,F:fus)g'
        ]
      },
      gtpBoundActivity: {
        short_form: :gtp,
        long_form: :gtpBoundActivity,
        description: 'Denotes the frequency or abundance of events in which a member of a G-protein abundance is GTP-bound',
        return_type: :a,
        signatures: [
          'gtp(F:complex)a',
          'gtp(F:p)a'
        ]
      },
      kinaseActivity: {
        short_form: :kin,
        long_form: :kinaseActivity,
        description: 'Denotes the frequency or abundance of events in which a member acts as a kinase, performing enzymatic phosphorylation of a substrate',
        return_type: :a,
        signatures: [
          'kin(F:complex)a',
          'kin(F:p)a'
        ]
      },
      list: {
        short_form: :list,
        long_form: :list,
        description: 'Groups a list of terms together',
        return_type: :list,
        signatures: [
          'list(E:A...)list',
          'list(F:a...)list'
        ]
      },
      microRNAAbundance: {
        short_form: :m,
        long_form: :microRNAAbundance,
        description: 'Denotes the abundance of a processed, functional microRNA',
        return_type: :m,
        signatures: [
          'm(E:M)m'
        ]
      },
      molecularActivity: {
        short_form: :act,
        long_form: :molecularActivity,
        description: 'Denotes the frequency or abundance of events in which a member acts as a causal agent at the molecular scale',
        return_type: :a,
        signatures: [
          'act(F:a)a'
        ]
      },
      pathology: {
        short_form: :path,
        long_form: :pathology,
        description: 'Denotes a disease or pathology process',
        return_type: :path,
        signatures: [
          'path(E:O)path'
        ]
      },
      peptidaseActivity: {
        short_form: :pep,
        long_form: :peptidaseActivity,
        description: 'Denotes the frequency or abundance of events in which a member acts to cleave a protein',
        return_type: :a,
        signatures: [
          'pep(F:complex)a',
          'pep(F:p)a'
        ]
      },
      phosphataseActivity: {
        short_form: :phos,
        long_form: :phosphataseActivity,
        description: 'Denotes the frequency or abundance of events in which a member acts as a phosphatase',
        return_type: :a,
        signatures: [
          'phos(F:complex)a',
          'phos(F:p)a'
        ]
      },
      products: {
        short_form: :products,
        long_form: :products,
        description: 'Denotes the products of a reaction',
        return_type: :products,
        signatures: [
          'products(F:a...)products'
        ]
      },
      proteinAbundance: {
        short_form: :p,
        long_form: :proteinAbundance,
        description: 'Denotes the abundance of a protein',
        return_type: :p,
        signatures: [
          'p(E:P)p',
          'p(E:P,F:pmod)p',
          'p(E:P,F:sub)p',
          'p(E:P,F:fus)p',
          'p(E:P,F:trunc)p'
        ]
      },
      proteinModification: {
        short_form: :pmod,
        long_form: :proteinModification,
        description: 'Denotes a covalently modified protein abundance',
        return_type: :pmod,
        signatures: [
          'pmod(E:*)pmod',
          'pmod(E:*,E:*)pmod',
          'pmod(E:*,E:*,E:*)pmod'
        ]
      },
      reactants: {
        short_form: :reactants,
        long_form: :reactants,
        description: 'Denotes the reactants of a reaction',
        return_type: :reactants,
        signatures: [
          'reactants(F:a...)reactants'
        ]
      },
      reaction: {
        short_form: :rxn,
        long_form: :reaction,
        description: 'Denotes the frequency or abundance of events in a reaction',
        return_type: :a,
        signatures: [
          'rxn(F:reactants,F:products)a'
        ]
      },
      ribosylationActivity: {
        short_form: :ribo,
        long_form: :ribosylationActivity,
        description: 'Denotes the frequency or abundance of events in which a member acts to perform post-translational modification of proteins',
        return_type: :a,
        signatures: [
          'ribo(F:complex)a',
          'ribo(F:p)a'
        ]
      },
      rnaAbundance: {
        short_form: :r,
        long_form: :rnaAbundance,
        description: 'Denotes the abundance of a gene',
        return_type: :g,
        signatures: [
          'r(E:R)g',
          'r(E:R,F:fus)g'
        ]
      },
      substitution: {
        short_form: :sub,
        long_form: :substitution,
        description: 'Indicates the abundance of proteins with amino acid substitution sequence',
        return_type: :sub,
        signatures: [
          'sub(E:*,E:*,E:*)sub'
        ]
      },
      transcriptionalActivity: {
        short_form: :tscript,
        long_form: :transcriptionalActivity,
        description: 'Denotes the frequency or abundance of events in which a member directly acts to control transcription of genes',
        return_type: :a,
        signatures: [
          'tscript(F:complex)a',
          'tscript(F:p)a'
        ]
      },
      translocation: {
        short_form: :tloc,
        long_form: :translocation,
        description: 'Denotes the frequency or abundance of events in which members move between locations',
        return_type: :a,
        signatures: [
          'tloc(F:a,E:A,E:A)a'
        ]
      },
      transportActivity: {
        short_form: :tport,
        long_form: :transportActivity,
        description: 'Denotes the frequency or abundance of events in which a member directs acts to enable the directed movement of substances into, out of, within, or between cells',
        return_type: :a,
        signatures: [
          'tport(F:)a',
          'tport(F:p)a']
      },
      truncation: {
        short_form: :trunc,
        long_form: :truncation,
        description: 'Indicates an abundance of proteins with truncation sequence variants',
        return_type: :trunc,
        signatures: [
          'trunc(E:*)trunc'
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
