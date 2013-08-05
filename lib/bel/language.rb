# vim: ts=2 sw=2:
module BEL
  module Language
    FUNCTIONS = [
      :a, :abundance,
      :bp, :biologicalProcess,
      :cat, :catalyticActivity,
      :sec, :cellSecretion,
      :surf, :cellSurfaceExpression,
      :chap, :chaperoneActivity,
      :complex, :complexAbundance,
      :deg, :degradation,
      :fus, :fusion,
      :g, :geneAbundance,
      :gtp, :gtpBoundActivity,
      :kin, :kinaseActivity,
      :list,
      :m, :microRNAAbundance,
      :act, :molecularActivity,
      :path, :pathology,
      :pep, :peptidaseActivity,
      :phos, :phosphataseActivity,
      :products,
      :p, :proteinAbundance,
      :reactants,
      :rxn, :reaction,
      :ribo, :ribosylationActivity,
      :r, :rnaAbundance,
      :sub, :substitution,
      :tscript, :transcriptionalActivity,
      :tloc, :translocation,
      :tport, :transportActivity,
      :trunc, :truncation
    ]

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
    FUNCTIONS.each do |fx|
      Language.send(:define_method, fx) do |*args|
        Term.new(fx, *args)
      end
    end
  end
end
