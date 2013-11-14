=begin
%%{
machine bel;

  action call_term {fcall term;}
  action out_term {puts 'out_term'; puts "#{@term}";}
  action term_init {
    @term_stack = []
  }
  action term_fx {
    fx = buffer.map(&:chr).join().to_sym
    @term_stack.push(BEL::Script::Term.new(fx, []))
    pfx = nil
    pbuf = []
  }
  action term_arg {
    val = pbuf.map(&:chr).join()
    if not val.empty?
      @term_stack.last << BEL::Script::Parameter.new(pfx, val)
    end
    pbuf = []
    pfx = nil
  }
  action term_pop {
    @term = @term_stack.pop
    if not @term_stack.empty?
      @term_stack.last << @term
    end
  }
  action pbuf {pbuf << fc}
  action pns {
    pfx = pbuf.map(&:chr).join()
    pbuf = []
  }

  include 'common.rl';
  
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

  term :=
    FUNCTION >s $n %term_fx '(' SP* 
    (
      (IDENT $pbuf ':')? @pns (STRING $pbuf | IDENT $pbuf) %term_arg |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @call_term
    )
    (
      SP* ',' SP* 
      (
        (IDENT $pbuf ':')? @pns (STRING $pbuf | IDENT $pbuf) %term_arg |
        FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @call_term
      )
    )* ')' @term_pop @return;

  term_main :=
    (
      '\n' |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @term_init @call_term '\n' @out_term
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
