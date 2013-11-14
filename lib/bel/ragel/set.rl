=begin
%%{
  machine bel;

  action call_set {fcall set;}
  action call_unset {fcall unset;}
  action sg_start {
    statement_group = BEL::Script::StatementGroup.new(@name, [])
    @annotations = {}
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
  action out_unset_annotation {
    @annotations.delete(@name)
  }
  action out_unset_statement_group {
    statement_group.annotations = annotations.clone()
    @annotations.clear()
  }
  action lists {
    listvals = []
    listbuffer = []
  }
  action listn {listbuffer << fc}
  action liste {
    listvals << listbuffer.map(&:chr).join()
    listbuffer = []
  }
  action listv {@value = listvals}

  include 'common.rl';

  SET = /SET/i;
  UNSET = /UNSET/i;
  DOC = /DOCUMENT/i;
  DOC_PROPS = (/Name/i | /Description/i | /Version/i |
               /Copyright/i | /Authors/i | /Licenses/i |
               /ContactInfo/i);
  STATEMENT_GROUP = /STATEMENT_GROUP/i;

  statement_group =
    SP+ STATEMENT_GROUP SP+ '='
    SP+ (STRING | IDENT) >s $n %val %sg_start SP* '\n' @return;
  docprop = 
    SP+ DOC SP+ DOC_PROPS >s $n %name SP+ '='
    SP+ (STRING | IDENT) >s $n %val %docprop SP* '\n' @return;
  annotation =
    SP+ IDENT >s $n %name SP+ '=' SP+
    (
      STRING >s $n %val |
      IDENT >s $n %val  |
      (
        '{' @lists SP*
          (STRING | IDENT) $listn SP*
          (',' @liste SP* (STRING | IDENT) $listn SP*)*
        '}' @liste @listv
      )
    ) %annotation SP* '\n' @return;

  set :=
    (statement_group | docprop | annotation);
  unset :=
    SP+
    (
      IDENT >s $n %out_unset_annotation '\n' @return |
      STATEMENT_GROUP %out_unset_statement_group '\n' @return
    );
  set_main :=
    (
      '\n' |
      SET @call_set |
      UNSET @call_unset
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

