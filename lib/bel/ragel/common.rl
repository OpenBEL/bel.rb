=begin
%%{
machine bel;

  action return {fret;}
  action hold {fhold;}

  action s {
    buffer = []
  }

  action n {
    buffer << fc
  }

  action name {
    @name = buffer.pack('C*').force_encoding('utf-8')
  }

  action val {
    if buffer[0] == 34 && buffer[-1] == 34
      buffer = buffer[1...-1]
    end

    tmp_value = buffer.pack('C*').force_encoding('utf-8')
    tmp_value.gsub!('\"', '"')
    @value = tmp_value
  }

  action lists {
    listvals = []
    listbuffer = []
  }

  action listn {
    listbuffer << fc
  }

  action liste {
    if listbuffer[0] == 34 && listbuffer[-1] == 34
      listbuffer = listbuffer[1...-1]
    end
    tmp_listvalue = listbuffer.pack('C*').force_encoding('utf-8')
    tmp_listvalue.gsub!('\"', '"')

    listvals << tmp_listvalue
    listbuffer = []
  }

  action listv {
    @value = listvals
  }

  action newline {
    yield BEL::Language::NEW_LINE
  }

  action comment {
    comment_text = buffer.pack('C*').force_encoding('utf-8')
    comment = BEL::Language::Comment.new(comment_text)

    yield comment
  }

  # basic tokens
  EQL = '=';
  NL = '\r\n' | '\n';
  COMMENT = '#';
  SP = ' ' | '\t';

  # keywords
  ANNOTATION_KW = /ANNOTATION/i;
  AS_KW = /AS/i;
  DEFINE_KW = /DEFINE/i;
  DOC_KW = /DOCUMENT/i;
  DOC_PROPS = (/Name/i | /Description/i | /Version/i |
               /Copyright/i | /Authors/i | /Licenses/i |
               /ContactInfo/i);
  FUNCTION = ('proteinAbundance'|'p'|'rnaAbundance'|'r'|'abundance'|'a'|
              'microRNAAbundance'|'m'|'geneAbundance'|'g'|
              'biologicalProcess'|'bp'|'pathology'|'path'|
              'complexAbundance'|'complex'|'translocation'|'tloc'|
              'cellSecretion'|'sec'|'cellSurfaceExpression'|'surf'|
              'reaction'|'rxn'|'compositeAbundance'|'composite'|
              'fusion'|'fus'|'degradation'|'deg'|
              'molecularActivity'|'act'|'catalyticActivity'|'cat'|
              'kinaseActivity'|'kin'|'phosphataseActivity'|'phos'|
              'peptidaseActivity'|'pep'|'ribosylationActivity'|'ribo'|
              'transcriptionalActivity'|'tscript'|
              'transportActivity'|'tport'|'gtpBoundActivity'|'gtp'|
              'chaperoneActivity'|'chap'|'proteinModification'|'pmod'|
              'substitution'|'sub'|'truncation'|'trunc'|'reactants'|
              'products'|'list') >s $n %name;
  LIST_KW = /LIST/i;
  NAMESPACE_KW = /NAMESPACE/i;
  PATTERN_KW = /PATTERN/i;
  RELATIONSHIP = ('increases'|'->'|'decreases'|'-|'|'directlyIncreases'|
                  '=>'|'directlyDecreases'|'=|'|'causesNoChange'|
                  'positiveCorrelation'|'negativeCorrelation'|
                  'translatedTo'|'>>'|'transcribedTo'|':>'|'isA'|
                  'subProcessOf'|'rateLimitingStepOf'|'biomarkerFor'|
                  'prognosticBiomarkerFor'|'orthologous'|'analogous'|
                  'association'|'--'|'hasMembers'|'hasComponents'|
                  'hasMember'|'hasComponent');
  SET_KW = /SET/i;
  STATEMENT_GROUP_KW = /STATEMENT_GROUP/i;
  UNSET_KW = /UNSET/i;
  URL_KW = /URL/i;

  # expressions
  IDENT = [a-zA-Z0-9_]+;
  STRING = ('"' ('\\\"' | [^"])** '"') >s $n %val;
  LIST = '{' @lists SP*
         (STRING | IDENT) $listn SP*
         (',' @liste SP* (STRING | IDENT) $listn SP*)*
         '}' @liste @listv;

  common_main :=
    (FUNCTION | STRING NL)+;
}%%
=end

if __FILE__ == $0
  require_relative 'language'

  class Parser

    def initialize
      @items = []
      %% write data;
    end

    def exec(input)
      buffer = []
      stack = []
      data = input.read.unpack('C*')

      %% write init;
      %% write exec;
    end
  end
  Parser.new.exec(ARGV[0] ? File.open(ARGV[0], 'r:UTF-8') : $stdin)
end
# vim: ts=2 sw=2:
# encoding: utf-8
