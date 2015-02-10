=begin
%%{
machine bel;

  action call_term {fcall term;}
  action term {
    yield @term
  }
  action term_init {
    @term_stack = []
  }
  action term_fx {
    fx = @name.to_sym
    @term_stack.push(BEL::Language::Term.new(fx, []))
    pfx = nil
    pbuf = []
  }
  action term_arg {
    val = pbuf.map(&:chr).join()
    if not val.empty?
      if val.start_with? '"' and val.end_with? '"'
        val = val.strip()[1...-1]
      end

      ns = nil
      if pfx
        fail SyntaxError, "The namespace prefix #{pfx} was not defined" if not @namespaces[pfx.to_sym]
        ns = @namespaces[pfx.to_sym]
      end

      param = BEL::Language::Parameter.new(ns, val)
      @term_stack.last << param

      yield param
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

  term :=
    (
      SP* (IDENT $pbuf ':')? @pns SP* (STRING $pbuf | IDENT $pbuf) %term_arg |
      SP* FUNCTION '(' @term_fx @call_term
    )
    (
      SP* ',' SP* 
      (
        (IDENT $pbuf ':')? @pns (STRING $pbuf | IDENT $pbuf) %term_arg |
        FUNCTION '(' @term_fx @call_term
      )
    )* SP* ')' >term_pop >term @{n = 0} @return;

  term_main :=
    (
      FUNCTION '(' @term_init @term_fx @call_term NL @term
    )+;
}%%
=end

require 'observer'
require_relative 'language'

module BEL
  module Script
    class Parser
      include Observable

      def initialize
        @annotations = {}
        @statement_group = nil
        %% write data;
      end

      def parse(content)
        eof = :ignored
        buffer = []
        stack = []
        data = content.unpack('C*')

        if block_given?
          observer = Observer.new(&Proc.new)
          self.add_observer(observer)
        end

        %% write init;
        %% write exec;

        if block_given?
          self.delete_observer(observer)
        end
      end
    end

    private

    class Observer
      include Observable

      def initialize(&block)
        @block = block
      end

      def update(obj)
        @block.call(obj)
      end
    end
  end
end

# intended for direct testing
if __FILE__ == $0
  require 'bel'

  if ARGV[0]
    content = (File.exists? ARGV[0]) ? File.open(ARGV[0], 'r:UTF-8').read : ARGV[0]
  else
    content = $stdin.read
  end

  class DefaultObserver
    def update(obj)
      puts obj
    end
  end

  parser = BEL::Script::Parser.new
  parser.add_observer(DefaultObserver.new)
  parser.parse(content) 
end
# vim: ts=2 sw=2:
# encoding: utf-8
