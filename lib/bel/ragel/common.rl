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

  # basic tokens
  EQL = '=';
  NL = '\n';
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
              'products'|'list');
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
  IDENT = [a-zA-Z0-9]+ >s $n %name;
  STRING = ('"' ([^"] | '\\\"')* '"') >s $n %val;
  LIST = '{' @lists SP*
         (STRING | IDENT) $listn SP*
         (',' @liste SP* (STRING | IDENT) $listn SP*)*
         '}' @liste @listv;
}%%
=end
