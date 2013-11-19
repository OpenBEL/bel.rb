=begin
%%{
  machine bel;

  action call_statement {fcall statement;}
  action statement {
    @statement = @statement_stack.pop
    @statement.annotations = @annotations.clone()

    if @statement_group
      statement_group.statements << @statement
    end

    changed
    notify_observers(@statement)
  }
  action statement_init {
    @statement = BEL::Script::Statement.new()
    @statement_stack = [@statement]
  }
  action statement_subject {
    @statement_stack.last.subject = @term

    changed
    notify_observers(@term)
  }
  action statement_oterm {
    @statement_stack.last.object = @term

    changed
    notify_observers(@term)
  }
  action statement_ostmt {
    nested = BEL::Script::Statement.new()
    @statement_stack.last.object = nested
    @statement_stack.push nested
  }
  action statement_pop {
    @statement = @statement_stack.pop
  }
  action rels {@relbuffer = []}
  action reln {@relbuffer << fc}
  action rele {
    rel = @relbuffer.map(&:chr).join()
    @statement_stack.last.rel = rel.to_sym
  }

  include 'common.rl';
  include 'set.rl';
  include 'term.rl';

  RELATIONSHIP = ('increases'|'->'|'decreases'|'-|'|'directlyIncreases'|'=>'|                                                       
                  'directlyDecreases'|'=|'|'causesNoChange'|
                  'positiveCorrelation'|'negativeCorrelation'|
                  'translatedTo'|'>>'|'transcribedTo'|':>'|'isA'|
                  'subProcessOf'|'rateLimitingStepOf'|'biomarkerFor'|
                  'prognosticBiomarkerFor'|'orthologous'|'analogous'|
                  'association'|'--'|'hasMembers'|'hasComponents'|
                  'hasMember'|'hasComponent');

  statement :=
    FUNCTION >{n = 0} ${n += 1} @{fpc -= n} %{fpc -= n} @term_init @call_term SP* %statement_subject '\n'? @statement @return
    RELATIONSHIP >rels $reln %rele SP+
    (
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} %{fpc -= n} @term_init @call_term %statement_oterm SP* ')'? @return
      |
      '(' @statement_ostmt @call_statement %statement_pop
    ) %statement '\n' @{n = 0} @return;
  
  statement_main :=
    (
      '\n' |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @statement_init @call_statement
    )+;
}%%
=end

module BEL
  Parameter = Struct.new(:ns, :value)
  Term = Struct.new(:fx, :args) do
    def <<(item)
      self.args << item
    end
  end
  Statement = Struct.new(:subject, :rel, :object, :annotations, :comment) do
      def subject_only?
        !rel 
      end  
      def simple?
        object.is_a? TermDefinition
      end  
      def nested?
        object.is_a? StatementDefinition
      end
  end
end

class Parser

  def initialize
    @items = []
    %% write data;
  end

  def exec(input)
    buffer = []
    stack = []
    data = input.read.unpack('c*')

    %% write init;
    %% write exec;
  end
end
Parser.new.exec(ARGV[0] ? File.open(ARGV[0]) : $stdin)
