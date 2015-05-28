module BEL
  module Model

    # A {Statement} captures a BEL statement composed of a subject {Term},
    # +relationship+, and object {Term}. A {Statement} may be one of the
    # following common forms:
    #
    # - SUBJECT
    #   - +complex(p(HGNC:F3),p(HGNC:F7))+
    # - SUBJECT RELATIONSHIP OBJECT(Term)
    #   - +pep(complex(p(HGNC:F3),p(HGNC:F7))) => pep(p(HGNC:F9))+
    # - SUBJECT RELATIONSHIP OBJECT(Statement)
    #   - +p(HGNC:VHL) -> (p(HGNC:TNF) -> bp(GOBP:"cell death"))+
    class Statement
      attr_accessor :subject, :relationship, :object

      # Creates a {Statement} with +subject+, +relationship+, and +object+.
      #
      # @param [Term] subject the subject term that is perturbed within an
      #        experiment
      # @param [#to_s] relationship the observed relationship between the
      #        {Term subject} and object (either {Term} or {Statement}).
      # @param [Term|Statement] object the object term that is measured for
      #        change within an experiment
      def initialize(subject:, relationship: nil, object: nil)
        @subject = subject
        @relationship = relationship
        @object = object
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
        [@subject, @relationship, @object].hash
      end

      def ==(other)
        return false if other == nil
        @subject == other.subject &&
        @relationship == other.relationship &&
        @object == other.object
      end

      alias_method :eql?, :'=='
    end
  end
end
