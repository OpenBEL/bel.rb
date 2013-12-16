# vim: ts=2 sw=2:
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
    anno = BEL::Script::AnnotationDefinition.new(:list, @name, @value)
    changed
    notify_observers(anno)
  }

  action define_annotation_pattern {
    anno = BEL::Script::AnnotationDefinition.new(:pattern, @name, @value)
    changed
    notify_observers(anno)
  }

  action define_annotation_url {
    anno = BEL::Script::AnnotationDefinition.new(:url, @name, @value)
    changed
    notify_observers(anno)
  }

  action define_namespace {
    ns = BEL::Script::NamespaceDefinition.new(@name, @value)
    changed
    notify_observers(ns)
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
require_relative 'parse_objects'

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
