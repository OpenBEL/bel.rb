# vim: ts=2 sw=2:
=begin
%%{
  machine bel;

  action call_define_annotation {fcall define_annotation;}
  action call_define_namespace {fcall define_namespace;}
  action define_annotation {
    anno = BEL::Script::AnnotationDefinition.new(@name, @value)
    changed
    notify_observers(anno)
  }
  action define_namespace {
    ns = BEL::Script::NamespaceDefinition.new(@name, @value)
    changed
    notify_observers(ns)
  }

  include 'common.rl';

  DEFINE = /DEFINE/i;
  ANNOTATION = /ANNOTATION/i;
  NAMESPACE = /NAMESPACE/i;
  AS = /AS/i;
  URL = /URL/i;

  define_annotation :=
    SP+ IDENT >s $n %name
    SP+ AS SP+ URL SP+ STRING >s $n %val
    SP* '\n' @define_annotation @return;
  define_namespace :=
    SP+ IDENT >s $n %name
    SP+ AS SP+ URL SP+ STRING >s $n %val
    SP* '\n' @define_namespace @return;
  define_main :=
    (
      DEFINE SP+ ANNOTATION @call_define_annotation |
      DEFINE SP+ NAMESPACE @call_define_namespace
    )+;
}%%
=end

require 'observer'

module BEL
  module Script
    AnnotationDefinition = Struct.new(:prefix, :value)
    NamespaceDefinition = Struct.new(:prefix, :value)

    class Parser
      include Observable

      def initialize
        @annotations = {}
        @statement_group = nil
        %% write data;
      end

      def parse(content)
        buffer = []
        stack = []
        data = content.unpack('c*')

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
    content = (File.exists? ARGV[0]) ? File.open(ARGV[0]).read : ARGV[0]
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
