=begin
%%{
machine bel;

  include 'common.rl';
  include 'define.rl';
  include 'set.rl';
  include 'statement.rl';
  include 'term.rl';

  document_main :=
    (
		  SP* <: (
			  DEFINE_KW SP+ ANNOTATION_KW @call_define_annotation |
			  DEFINE_KW SP+ NAMESPACE_KW @call_define_namespace |
			  SET_KW @call_set |
			  COMMENT ^NL+ >s $n NL %comment |
			  UNSET_KW @call_unset |
			  ^('\r' | '\n' | '#' | 'D' | 'S' | 'U') >{fpc -= 1;} >statement_init >call_statement |
			  NL @newline
			)
    )+;
}%%
=end

require_relative 'language'
require_relative 'namespace'
require_relative 'nanopub'
require_relative 'nonblocking_io_wrapper'

module BEL
  module Script

    class << self

      MAX_LENGTH = 1024 * 128 # 128K

      # Parse BEL Script +content+ into an enumerator of objects.
      #
			# @param [String, IO] content the BEL Script data to parse
			# @param [Hash]       namespaces the
			#        {BEL::Namespace::NamespaceDefinition} to use when matching
			#				 prefixes in BEL statements; defaults to empty meaning use the
			#				 +DEFINE NAMESPACE+ definitions in the content
			# @return [Enumerator] the parsed objects
      def parse(content, namespaces = {})
        return nil unless content

        parser =
          if content.is_a? String
					  if !content.end_with?("\n")
							content << "\n"
						end
            Parser.new(content, namespaces)
          elsif content.respond_to? :read
            IOParser.new(content, namespaces, MAX_LENGTH)
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

      # Parse BEL Script +content+, in chunks, into an enumerator of objects.
      # The length of the chunks can be configured with +chunk_length+.
      #
			# @param  [IO]         io the BEL Script data to parse; if a {String}
			#         then {#parse} will be called instead
			# @param  [Hash]       namespaces the
			#         {BEL::Namespace::NamespaceDefinition} to use when matching
			#				  prefixes in BEL statements; defaults to empty meaning use the
			#				  +DEFINE NAMESPACE+ definitions in the content
			# @param  [Integer]    chunk_length determines how many bytes are
			#         buffered at a time when +io+ is an {IO}
			# @return [Enumerator] the parsed objects
			def parse_chunked(io, namespaces = {}, chunk_length = MAX_LENGTH)
				parser =
					if io.is_a? String
						parse(io, namespaces)
					elsif io.respond_to? :read
						IOParser.new(io, namespaces, chunk_length)
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

      def initialize(io, namespaces = {}, max_chunk_length)
        @io         = NonblockingIOWrapper.new(io, max_chunk_length)
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

				@io.each do |chunk|
					data = chunk.unpack('C*')
					p = 0
					pe = data.length

					%% write exec;
				end
      end
    end
  end
end
# vim: ts=2 sw=2:
# encoding: utf-8
