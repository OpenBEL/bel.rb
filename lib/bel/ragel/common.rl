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
    @name = buffer.map(&:chr).join()
  }

  action val {
    if buffer[0] == 34 && buffer[-1] == 34
      buffer = buffer[1...-1]
    end
    @value = buffer.map(&:chr).join().gsub '\"', '"'
  }

  action lists {
    listvals = []
    listbuffer = []
  }

  action listn {
    listbuffer << fc
  }

  action liste {
    listvals << listbuffer.map(&:chr).join()
    listbuffer = []
  }

  action listv {
    @value = listvals
  }

  action newline {
    changed
    notify_observers(BEL::Language::NEW_LINE)
  }

  action comment {
    comment_text = buffer.map(&:chr).join()
    comment = BEL::Language::Comment.new(comment_text)

    changed
    notify_observers(comment)
  }

  # basic tokens
  EQL = '=';
  NL = '\n' | '\r' '\n'?;
  COMMENT = '#';
  SP = ' ';

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
  STRING = ('"' ('\\\"' | [^"])* '"') >s $n %val;
  LIST = '{' @lists SP*
         (STRING | IDENT) $listn SP*
         (',' @liste SP* (STRING | IDENT) $listn SP*)*
         '}' @liste @listv;

  common_main :=
    (FUNCTION | STRING NL)+;
}%%
=end

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
