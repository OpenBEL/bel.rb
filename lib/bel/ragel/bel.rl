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

require_relative 'language'
require_relative 'namespace'
require_relative 'evidence_model'
require_relative 'nonblocking_io_wrapper'

module BEL
  module Script

    class << self
      def parse(content, namespaces = {})
        return nil unless content

        parser =
          if content.is_a? String
					  if !content.end_with?("\n")
							content << "\n"
						end
            Parser.new(content, namespaces)
          elsif content.respond_to? :read
            IOParser.new(content, namespaces)
          else
            nil
          end

        unless parser
          fail ArgumentError, "content: expected string or io-like"
        end

        if block_given?
          parser.each do |obj|
            yield obj
          end
        else
          if parser.respond_to? :lazy
            parser.lazy
          else
            parser
          end
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
          when BEL::Namespace::ResourceIndex
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

    class IOParser
      include Enumerable

      MAX_LENGTH = 1024 * 128 # 128K

      def initialize(io, namespaces = {})
        @io         = NonblockingIOWrapper.new(io, MAX_LENGTH)
        @namespaces =
          case namespaces
          when BEL::Namespace::ResourceIndex
            Hash[namespaces.namespaces.map { |ns| [ns.prefix, ns] }]
          when Hash
            namespaces
          end
        @annotations = {}
        @statement_group = nil
        %% write data;
      end

      def each
        pe = :ignored
        eof = :ignored
        buffer = []
        stack = []

        %% write init;

        leftover = []
        my_ts = nil
        my_te = nil
        
				@io.each do |chunk|
					data = leftover + chunk.unpack('c*')
					p = 0
					pe = data.length
					%% write exec;
					if my_ts
						leftover = data[my_ts..-1]
						my_te = my_te - my_ts if my_te
						my_ts = 0
					else
						leftover = []
					end
				end
      end
    end
  end
end

if __FILE__ == $0
  namespaces = BEL::Namespace::DEFAULT_NAMESPACES.map { |ns|
    [ns.prefix, ns]
  }.to_h

  if ARGV[0]
    File.open(ARGV[0], 'r:UTF-8') do |f|
      BEL::Script.parse(f, namespaces).each do |obj|
        puts obj
      end
    end
  else
    BEL::Script.parse($stdin, namespaces).each do |obj|
      puts obj
    end
  end
end
# vim: ts=2 sw=2:
# encoding: utf-8
