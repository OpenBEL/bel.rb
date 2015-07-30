=begin
%%{
  machine bel;

  action call_define_annotation {
    fcall define_annotation;
  }

  action call_define_namespace {
    fcall define_namespace;
  }

  action define_annotation_list {
    anno = BEL::Language::AnnotationDefinition.new(:list, @name, @value)
    yield anno
  }

  action define_annotation_pattern {
    anno = BEL::Language::AnnotationDefinition.new(:pattern, @name, @value)
    yield anno
  }

  action define_annotation_url {
    anno = BEL::Language::AnnotationDefinition.new(:url, @name, @value)
    yield anno
  }

  action define_namespace {
    prefix = @name.to_sym
		@namespaces[prefix] =
			begin
				BEL::Namespace.const_get(prefix)
			rescue NameError
				uri = BEL::Namespace::DEFAULT_URI
				BEL::Namespace::NamespaceDefinition.new(
					prefix,
					@value,
					uri
				)
			end

    yield @namespaces[prefix]
  }

  include 'common.rl';

  define_annotation :=
    SP+ IDENT >s $n %name SP+ AS_KW SP+
    (
      (LIST_KW SP+ LIST SP* NL @define_annotation_list @return) |
      (PATTERN_KW SP+ STRING SP* NL @define_annotation_pattern @return) |
      (URL_KW SP+ STRING SP* NL @define_annotation_url @return)
    );
  define_namespace :=
    SP+ IDENT >s $n %name SP+ AS_KW SP+ URL_KW SP+ STRING SP* NL
    @define_namespace @return;
  define_main :=
    (
      DEFINE_KW SP+ ANNOTATION_KW @call_define_annotation |
      DEFINE_KW SP+ NAMESPACE_KW @call_define_namespace
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
