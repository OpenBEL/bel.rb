=begin
%%{
  machine bel;

  action call_set {
    fcall set;
  }

  action call_unset {
    fcall unset;
  }

  action sg_start {
    statement_group = BEL::Script::StatementGroup.new(@value, [])
    @annotations = {}

    changed
    notify_observers(statement_group)
  }

  action docprop {
    docprop = BEL::Script::DocumentProperty.new(@name, @value)

    changed
    notify_observers(docprop)
  }

  action annotation {
    annotation = BEL::Script::Annotation.new(@name, @value)
    @annotations.store(@name, annotation)

    changed
    notify_observers(annotation)
  }

  action unset_annotation {
    @annotations.delete(@name)
  }

  action unset_statement_group {
    statement_group.annotations = @annotations.clone()
    @annotations.clear()

    changed
    notify_observers(BEL::Script::UnsetStatementGroup.new(statement_group.name))
  }

  include 'common.rl';

  statement_group =
    SP+ STATEMENT_GROUP_KW SP+ EQL SP+ (STRING | IDENT)
    %sg_start SP* NL @return;
  docprop = 
    SP+ DOC_KW SP+ DOC_PROPS SP+ EQL SP+ (STRING | IDENT)
    %docprop SP* NL @return;
  annotation =
    SP+ IDENT SP+ EQL SP+ ( STRING | IDENT | LIST)
    %annotation SP* NL @return;

  set :=
    (statement_group | docprop | annotation);
  unset :=
    SP+
    (
      IDENT %unset_annotation NL @return |
      STATEMENT_GROUP_KW %unset_statement_group NL @return
    );
  set_main :=
    (
      NL |
      SET_KW @call_set |
      UNSET_KW @call_unset
    )+;
}%%
=end

module BEL
  DocumentProperty = Struct.new(:name, :value)
  Annotation = Struct.new(:name, :value)
  StatementGroup = Struct.new(:name, :statements, :annotations)
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

