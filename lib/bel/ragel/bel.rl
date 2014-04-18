=begin
%%{
machine bel;

  include 'common.rl';
  include 'define.rl';
  include 'set.rl';
  include 'term.rl';
  include 'statement.rl';

  # TODO
  # - allow EOF for end of record
  document_main :=
    (
      NL @newline |
      COMMENT ^NL+ >s $n NL %comment |
      DEFINE_KW SP+ ANNOTATION_KW @call_define_annotation |
      DEFINE_KW SP+ NAMESPACE_KW @call_define_namespace |
      SET_KW @call_set |
      UNSET_KW @call_unset |
      ^(NL | '#' | 'D' | 'S' | 'U') >{fpc -= 1;} >statement_init >call_statement
    )+;
}%%
=end

require 'observer'
require_relative 'language'
require_relative 'namespace'

module BEL
  module Script
    class Parser
      include Observable

      def initialize(namespaces = {})
        @namespaces = namespaces
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
