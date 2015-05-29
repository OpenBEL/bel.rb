require_relative 'quoting'
module BEL
  module Language

    class Newline
      def to_bel
        ""
      end
      alias_method :to_s, :to_bel
    end
    NEW_LINE = Newline.new

    Comment = Struct.new(:text) do
      def to_bel
        %Q{##{self.text}}
      end
      alias_method :to_s, :to_bel
    end

    DocumentProperty = Struct.new(:name, :value) do
      include BEL::Quoting

      def to_bel
        %Q{SET DOCUMENT #{self.name} = #{ensure_quotes(self.value)}}
      end
      alias_method :to_s, :to_bel
    end

    AnnotationDefinition = Struct.new(:type, :prefix, :value) do
      def to_bel
        case self.type
        when :list
          %Q{DEFINE ANNOTATION #{self.prefix} AS LIST {#{self.value.join(',')}}}
        when :pattern
          %Q{DEFINE ANNOTATION #{self.prefix} AS PATTERN "#{self.value}"}
        when :url
          %Q{DEFINE ANNOTATION #{self.prefix} AS URL "#{self.value}"}
        end
      end
      alias_method :to_s, :to_bel
    end

    class Parameter
      include BEL::Quoting
      include Comparable
      attr_accessor :ns, :value, :enc, :signature

      def initialize(ns, value, enc=nil)
        @ns = ns
        @value = value
        @enc = enc || ''
        @signature = E.new(@enc)
      end

      def <=>(other)
        ns_compare = @ns <=> other.ns
        if ns_compare == 0
          @value <=> other.value
        else
          ns_compare
        end
      end

      def valid?
        return false unless value
        return true unless @ns
        @ns.respond_to?(:values) && ns.values.include?(value)
      end

      def hash
        [@ns, @value].hash
      end

      def ==(other)
        return false if other == nil
        @ns == other.ns && @value == other.value
      end

      alias_method :eql?, :'=='

      def to_bel
        %Q{#{@ns ? @ns.prefix.to_s + ':' : ''}#{ensure_quotes(@value)}}
      end

      alias_method :to_s, :to_bel
    end

    class Function
      attr_reader :short_form, :long_form, :return_type,
                  :description, :signatures

      def initialize args
        args.each do |k,v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end
      end

      def [](key)
        instance_variable_get("@#{key}")
      end

      def hash
        [@short_form, @long_form, @return_type, @description, @signatures].hash
      end

      def ==(other)
        return false if other == nil
        @short_form == other.short_form &&
        @long_form == other.long_form &&
        @return_type == other.return_type &&
        @description == other.description &&
        @signatures == other.signatures
      end

      alias_method :eql?, :'=='

      def to_sym
        @short_form
      end

      def to_s
        @long_form.to_s
      end
    end

    class Term
      include Comparable
      attr_accessor :fx, :arguments, :signature

      def initialize(fx, *arguments)
        @fx = case fx
        when String
          Function.new(FUNCTIONS[fx.to_sym])
        when Symbol
          Function.new(FUNCTIONS[fx.to_sym])
        when Function
          fx
        when nil
          raise ArgumentError, 'fx must not be nil'
        end
        @arguments = (arguments ||= []).flatten
        @signature = Signature.new(
          @fx[:short_form],
          *@arguments.map { |arg|
            case arg
            when Term
              F.new(arg.fx.return_type)
            when Parameter
              E.new(arg.enc)
            when nil
              NullE.new
            end
          })
      end

      def <<(item)
        @arguments << item
      end

      def valid?
        invalid_signatures = @arguments.find_all { |arg|
          arg.is_a? Term
        }.find_all { |term|
          not term.valid?
        }
        return false if not invalid_signatures.empty?

        sigs = @fx.signatures
        sigs.any? do |sig| (@signature <=> sig) >= 0 end
      end

      def valid_signatures
        @fx.signatures.find_all { |sig| (@signature <=> sig) >= 0 }
      end

      def invalid_signatures
        @fx.signatures.find_all { |sig| (@signature <=> sig) < 0 }
      end

      def hash
        [@fx, @arguments].hash
      end

      def ==(other)
        return false if other == nil
        @fx == other.fx && @arguments == other.arguments
      end

      alias_method :eql?, :'=='

      def to_bel
        "#{@fx[:short_form]}(#{[@arguments].flatten.map(&:to_bel).join(',')})"
      end

      alias_method :to_s, :to_bel
    end

    Annotation = Struct.new(:name, :value) do
      include BEL::Quoting

      def to_bel
        if self.value.respond_to? :each
          value = self.value.map {|v| always_quote(v)}
          value = "{#{value.join(',')}}"
        else
          value = ensure_quotes(self.value)
        end
        "SET #{self.name} = #{value}"
      end

      alias_method :to_s, :to_bel
    end

    UnsetAnnotation = Struct.new(:name) do
      def to_bel
        %Q{UNSET #{self.name}}
      end

      alias_method :to_s, :to_bel
    end

    class Statement
      attr_accessor :subject, :relationship, :object, :annotations, :comment

      def initialize(subject=nil, relationship=nil, object=nil, annotations=[], comment=nil)
        @subject = subject
        @relationship = relationship
        @object = object
        @annotations = annotations
        @comment = comment
      end

      def subject_only?
        !@relationship
      end

      def simple?
        @object and @object.is_a? Term
      end

      def nested?
        @object and @object.is_a? Statement
      end

      def hash
        [@subject, @relationship, @object, @annotations, @comment].hash
      end

      def ==(other)
        return false if other == nil
        @subject == other.subject &&
        @relationship == other.relationship &&
        @object == other.object &&
        @annotations == other.annotations &&
        @comment == comment
      end

      alias_method :eql?, :'=='

      def to_bel
        lbl = case
        when subject_only?
          @subject.to_s
        when simple?
          "#{@subject.to_s} #{@relationship} #{@object.to_s}"
        when nested?
          "#{@subject.to_s} #{@relationship} (#{@object.to_s})"
        else
          ''
        end
        comment ? lbl + ' //' + comment : lbl
      end

      alias_method :to_s, :to_bel
    end

    StatementGroup = Struct.new(:name, :statements, :annotations) do
      include BEL::Quoting

      def <=>(other_group)
        if not other_group || other_group.is_a?
          1
        else
          (statements || []) <=> (other_group.statements || [])
        end
      end

      def to_bel
        %Q{SET STATEMENT_GROUP = #{ensure_quotes(self.name)}}
      end

      alias_method :to_s, :to_bel
    end

    UnsetStatementGroup = Struct.new(:name) do
      def to_bel
        %Q{UNSET STATEMENT_GROUP}
      end

      alias_method :to_s, :to_bel
    end

    class Signature
      attr_reader :fx, :arguments
      def initialize(fx, *arguments)
        @fx = fx
        @arguments = arguments

        dup_hash = {}
        @arguments.each_with_index { |arg, i| (dup_hash[arg] ||= []) << i }
        dup_hash.keep_if { |k, v| v.length > 1 }.values.each do |v|
          first_arg = @arguments[v[0]]
          if F === first_arg
            replace_range = (v.first..v.last)
            @arguments[replace_range] = F.new(first_arg.func_return, true)
          end
        end
      end

      def ==(other)
        return false if other == nil
        @fx == other.fx && @arguments == other.arguments
      end

      def <=>(other)
        return 1 if other.nil?
        return -1 if @fx != other.fx
        return -1 if @arguments.nil? and not other.nil?
        return 1 if not @arguments.nil? and other.nil?
        @arguments <=> other.arguments
      end

      def to_s
        return_type = FUNCTIONS[@fx][:return_type]
        "#{@fx}(#{@arguments.map(&:to_s) * ','})#{return_type}"
      end
    end

    class F
      attr_reader :func_return, :var
      def initialize(func_return, var=false)
        @func_return = func_return
        @var = var
      end

      def ==(other)
        return false if other == nil
        return false if not other.respond_to? :func_return
        @func_return == other.func_return and @var == other.var
      end

      alias_method :eql?, :==

      def hash
        [@func_return, @var].hash
      end

      def <=>(other)
        return 1 if @var ^ other.var

        tree = FUNCTION_TYPES[@func_return]
        return -1 if not tree.include?(other.func_return)
        -(tree.index(@func_return) <=> tree.index(other.func_return))
      end

      def to_s
        "F:#{@func_return}#{'...' if @var}"
      end
    end

    class E
      attr_reader :encoding, :var
      def initialize(encoding, var=false)
        @encoding = encoding
        @var = var
      end

      def <=>(other)
        return 1 if @var ^ other.var

        # compare for equals and wildcard case
        cmp = @encoding <=> other.encoding
        return cmp if cmp.zero? or (@encoding == :* or other.encoding == :*)

        # compare encoding for assignability; based on array index
        @encoding.to_s.each_char do |enc_char|
          enc_sym = enc_char.to_sym
          tree = PARAMETER_ENCODING[enc_sym]
          next if not tree.include?(other.encoding)

          match = -(tree.index(enc_sym) <=> tree.index(other.encoding))
          return match if match >= 0
        end
        -1
      end

      def to_s
        "E:#{@encoding}"
      end
    end

    class NullE
      def <=>(other)
        return 0 if NullE === other
        -1
      end

      def to_s
        "E:nil"
      end
    end

    FUNCTIONS = {
      a: {
        short_form: :a,
        long_form: :abundance,
        description: 'Denotes the abundance of an entity',
        return_type: :a,
        signatures: [
          Signature.new(:a, E.new(:A))
        ]
      },
      bp: {
        short_form: :bp,
        long_form: :biologicalProcess,
        description: 'Denotes a process or population of events',
        return_type: :bp,
        signatures: [
          Signature.new(:bp, E.new(:B))
        ]
      },
      cat: {
        short_form: :cat,
        long_form: :catalyticActivity,
        description: 'Denotes the frequency or abundance of events where a member acts as an enzymatic catalyst of biochecmial reactions',
        return_type: :a,
        signatures: [
          Signature.new(:cat, F.new(:complex)),
          Signature.new(:cat, F.new(:p))
        ]
      },
      sec: {
        short_form: :sec,
        long_form: :cellSecretion,
        description: 'Denotes the frequency or abundance of events in which members of an abundance move from cells to regions outside of the cells',
        return_type: :a,
        signatures: [
          Signature.new(:sec, F.new(:a))
        ]
      },
      surf: {
        short_form: :surf,
        long_form: :cellSurfaceExpression,
        description: 'Denotes the frequency or abundance of events in which members of an abundance move to the surface of cells',
        return_type: :a,
        signatures: [
          Signature.new(:surf, F.new(:a))
        ]
      },
      chap: {
        short_form: :chap,
        long_form: :chaperoneActivity,
        description: 'Denotes the frequency or abundance of events in which a member binds to some substrate and acts as a chaperone for the substrate',
        return_type: :a,
        signatures: [
          Signature.new(:chap, F.new(:complex)),
          Signature.new(:chap, F.new(:p))
        ]
      },
      complex: {
        short_form: :complex,
        long_form: :complexAbundance,
        description: 'Denotes the abundance of a molecular complex',
        return_type: :complex,
        signatures: [
          Signature.new(:complex, E.new(:A)),
          Signature.new(:complex, F.new(:a, true))
        ]
      },
      composite: {
        short_form: :composite,
        long_form: :compositeAbundance,
        description: 'Denotes the frequency or abundance of events in which members are present',
        return_type: :a,
        signatures: [
          Signature.new(:composite, F.new(:a, true))
        ]
      },
      deg: {
        short_form: :deg,
        long_form: :degradation,
        description: 'Denotes the frequency or abundance of events in which a member is degraded in some way such that it is no longer a member',
        return_type: :a,
        signatures: [
          Signature.new(:deg, F.new(:a))
        ]
      },
      fus: {
        short_form: :fus,
        long_form: :fusion,
        description: 'Specifies the abundance of a protein translated from the fusion of a gene',
        return_type: :fus,
        signatures: [
          Signature.new(:fus, E.new(:G)),
          Signature.new(:fus, E.new(:G), E.new(:*), E.new(:*)),
          Signature.new(:fus, E.new(:P)),
          Signature.new(:fus, E.new(:P), E.new(:*), E.new(:*)),
          Signature.new(:fus, E.new(:R)),
          Signature.new(:fus, E.new(:R), E.new(:*), E.new(:*))
        ]
      },
      g: {
        short_form: :g,
        long_form: :geneAbundance,
        description: 'Denotes the abundance of a gene',
        return_type: :g,
        signatures: [
          Signature.new(:g, E.new(:G)),
          Signature.new(:g, E.new(:G), F.new(:fus))
        ]
      },
      gtp: {
        short_form: :gtp,
        long_form: :gtpBoundActivity,
        description: 'Denotes the frequency or abundance of events in which a member of a G-protein abundance is GTP-bound',
        return_type: :a,
        signatures: [
          Signature.new(:gtp, F.new(:complex)),
          Signature.new(:gtp, F.new(:p))
        ]
      },
      kin: {
        short_form: :kin,
        long_form: :kinaseActivity,
        description: 'Denotes the frequency or abundance of events in which a member acts as a kinase, performing enzymatic phosphorylation of a substrate',
        return_type: :a,
        signatures: [
          Signature.new(:kin, F.new(:complex)),
          Signature.new(:kin, F.new(:p))
        ]
      },
      list: {
        short_form: :list,
        long_form: :list,
        description: 'Groups a list of terms together',
        return_type: :list,
        signatures: [
          Signature.new(:list, E.new(:A, true)),
          Signature.new(:list, F.new(:a, true))
        ]
      },
      m: {
        short_form: :m,
        long_form: :microRNAAbundance,
        description: 'Denotes the abundance of a processed, functional microRNA',
        return_type: :m,
        signatures: [
          Signature.new(:m, E.new(:M))
        ]
      },
      act: {
        short_form: :act,
        long_form: :molecularActivity,
        description: 'Denotes the frequency or abundance of events in which a member acts as a causal agent at the molecular scale',
        return_type: :a,
        signatures: [
          Signature.new(:act, F.new(:a))
        ]
      },
      path: {
        short_form: :path,
        long_form: :pathology,
        description: 'Denotes a disease or pathology process',
        return_type: :path,
        signatures: [
          Signature.new(:path, E.new(:O))
        ]
      },
      pep: {
        short_form: :pep,
        long_form: :peptidaseActivity,
        description: 'Denotes the frequency or abundance of events in which a member acts to cleave a protein',
        return_type: :a,
        signatures: [
          Signature.new(:pep, F.new(:complex)),
          Signature.new(:pep, F.new(:p))
        ]
      },
      phos: {
        short_form: :phos,
        long_form: :phosphataseActivity,
        description: 'Denotes the frequency or abundance of events in which a member acts as a phosphatase',
        return_type: :a,
        signatures: [
          Signature.new(:phos, F.new(:complex)),
          Signature.new(:phos, F.new(:p))
        ]
      },
      products: {
        short_form: :products,
        long_form: :products,
        description: 'Denotes the products of a reaction',
        return_type: :products,
        signatures: [
          Signature.new(:products, F.new(:a))
        ]
      },
      p: {
        short_form: :p,
        long_form: :proteinAbundance,
        description: 'Denotes the abundance of a protein',
        return_type: :p,
        signatures: [
          Signature.new(:p, E.new(:P)),
          Signature.new(:p, E.new(:P), F.new(:pmod)),
          Signature.new(:p, E.new(:P), F.new(:sub)),
          Signature.new(:p, E.new(:P), F.new(:fus)),
          Signature.new(:p, E.new(:P), F.new(:trunc))
        ]
      },
      pmod: {
        short_form: :pmod,
        long_form: :proteinModification,
        description: 'Denotes a covalently modified protein abundance',
        return_type: :pmod,
        signatures: [
          Signature.new(:pmod, E.new(:*)),
          Signature.new(:pmod, E.new(:*), E.new(:*)),
          Signature.new(:pmod, E.new(:*), E.new(:*), E.new(:*))
        ]
      },
      reactants: {
        short_form: :reactants,
        long_form: :reactants,
        description: 'Denotes the reactants of a reaction',
        return_type: :reactants,
        signatures: [
          Signature.new(:reactants, F.new(:a))
        ]
      },
      rxn: {
        short_form: :rxn,
        long_form: :reaction,
        description: 'Denotes the frequency or abundance of events in a reaction',
        return_type: :a,
        signatures: [
          Signature.new(:rxn, F.new(:reactants), F.new(:products))
        ]
      },
      ribo: {
        short_form: :ribo,
        long_form: :ribosylationActivity,
        description: 'Denotes the frequency or abundance of events in which a member acts to perform post-translational modification of proteins',
        return_type: :a,
        signatures: [
          Signature.new(:ribo, F.new(:complex)),
          Signature.new(:ribo, F.new(:p))
        ]
      },
      r: {
        short_form: :r,
        long_form: :rnaAbundance,
        description: 'Denotes the abundance of a gene',
        return_type: :g,
        signatures: [
          Signature.new(:r, E.new(:R)),
          Signature.new(:r, E.new(:R), F.new(:fus))
        ]
      },
      sub: {
        short_form: :sub,
        long_form: :substitution,
        description: 'Indicates the abundance of proteins with amino acid substitution sequence',
        return_type: :sub,
        signatures: [
          Signature.new(:sub, E.new(:*), E.new(:*), E.new(:*))
        ]
      },
      tscript: {
        short_form: :tscript,
        long_form: :transcriptionalActivity,
        description: 'Denotes the frequency or abundance of events in which a member directly acts to control transcription of genes',
        return_type: :a,
        signatures: [
          Signature.new(:tscript, F.new(:complex)),
          Signature.new(:tscript, F.new(:p))
        ]
      },
      tloc: {
        short_form: :tloc,
        long_form: :translocation,
        description: 'Denotes the frequency or abundance of events in which members move between locations',
        return_type: :a,
        signatures: [
          Signature.new(:tloc, F.new(:a), E.new(:A), E.new(:A))
        ]
      },
      tport: {
        short_form: :tport,
        long_form: :transportActivity,
        description: 'Denotes the frequency or abundance of events in which a member directs acts to enable the directed movement of substances into, out of, within, or between cells',
        return_type: :a,
        signatures: [
          Signature.new(:tport, F.new(:complex)),
          Signature.new(:tport, F.new(:p))
        ]
      },
      trunc: {
        short_form: :trunc,
        long_form: :truncation,
        description: 'Indicates an abundance of proteins with truncation sequence variants',
        return_type: :trunc,
        signatures: [
          Signature.new(:trunc, E.new(:*))
        ]
      }
    }
    FUNCTIONS.merge!(Hash[*FUNCTIONS.map {|_,v| [v[:long_form], v]}.flatten])

    PARAMETER_ENCODING = {
      B: [:B],
      O: [:O, :B],
      R: [:R, :A],
      M: [:M, :R, :A],
      P: [:P, :A],
      G: [:G, :A],
      A: [:A],
      C: [:C, :A]
    }

    FUNCTION_TYPES = {
      a: [:a],
      bp: [:bp],
      complex: [:complex, :a],
      g: [:g, :a],
      m: [:m, :r, :a],
      path: [:path, :bp],
      p: [:p, :a],
      r: [:r, :a]
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

    RELATIONSHIPS.each do |rel|
      Term.send(:define_method, rel) do |another|
        s = Statement.new self
        s.relationship = rel
        s.object = another
        s
      end
    end
    FUNCTIONS.each do |fx, metadata|
      func = Function.new(metadata)
      Language.send(:define_method, fx) do |*args|
        Term.new(func, *args)
      end
      Language.send(:define_method, metadata[:long_form]) do |*args|
        Term.new(func, *args)
      end
    end
  end
end
# vim: ts=2 sw=2:
# encoding: utf-8
