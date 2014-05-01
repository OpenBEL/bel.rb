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

    class << self
      def parse(content, namespaces = {})
        if block_given?
          Parser.new(content, namespaces).each do |obj|
            yield obj
          end
        else
          Parser.new(content, namespaces)
        end
      end
    end

    private

    class Parser
      include Enumerable

      def initialize(content, namespaces = {})
        @content = content
        @namespaces =
          case namespaces
          when ResourceIndex
            Hash[namespaces.namespaces.map { |ns| [ns.prefix, ns] }]
          when Hash
            namespaces
          end
        @annotations = {}
        @statement_group = nil
        %% write data;
      end

      def each
        eof = :ignored
        buffer = []
        stack = []
        data = @content.unpack('C*')

        %% write init;
        %% write exec;
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
