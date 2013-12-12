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
    SP+ IDENT SP+ AS_KW SP+
    (
      (LIST_KW SP+ LIST SP* NL @define_annotation_list @return) |
      (PATTERN_KW SP+ STRING SP* NL @define_annotation_pattern @return) |
      (URL_KW SP+ STRING SP * NL @define_annotation_url @return)
    );
  define_namespace :=
    SP+ IDENT SP+ AS_KW SP+ URL_KW SP+ STRING SP* NL
    @define_namespace @return;
  define_main :=
    (
      DEFINE_KW SP+ ANNOTATION_KW @call_define_annotation |
      DEFINE_KW SP+ NAMESPACE_KW @call_define_namespace
    )+;
}%%
=end

require 'observer'

module BEL
  module Script
    DocumentProperty = Struct.new(:name, :value) do
      def to_s
        %Q{SET DOCUMENT #{self.name} = "#{self.value}"}
      end
    end
    AnnotationDefinition = Struct.new(:type, :prefix, :value) do
      def to_s
        case self.type
        when :list
          %Q{DEFINE ANNOTATION #{self.prefix} AS LIST {#{self.value.join(',')}}}
        when :pattern
          %Q{DEFINE ANNOTATION #{self.prefix} AS PATTERN "#{self.value}"}
        when :url
          %Q{DEFINE ANNOTATION #{self.prefix} AS URL "#{self.value}"}
        end
      end
    end
    NamespaceDefinition = Struct.new(:prefix, :value) do
      def to_s
        %Q{DEFINE NAMESPACE #{self.prefix} AS URL "#{self.value}"}
      end
    end
    Annotation = Struct.new(:name, :value) do
      def to_s
        if self.value.respond_to? :each
          value = "{#{self.value.join(',')}}"
        else
          value = self.value
          if NonWordMatcher.match value
            value = %Q{"#{value}"}
          end
        end
        "SET #{self.name} = #{value}"
      end
    end
    Parameter = Struct.new(:ns, :value) do
      NonWordMatcher = Regexp.compile(/[^0-9a-zA-Z]/)
      def to_s
        prepped_value = value
        if NonWordMatcher.match value
          prepped_value = %Q{"#{value}"}
        end
        "#{self.ns ? self.ns + ':' : ''}#{prepped_value}"
      end
    end
    Term = Struct.new(:fx, :args) do
      def <<(item)
        self.args << item
      end
      def to_s
        "#{self.fx}(#{[args].flatten.join(',')})"
      end
    end
    Statement = Struct.new(:subject, :rel, :object, :annotations, :comment) do
        def subject_only?
          !rel
        end
        def simple?
          object.is_a? Term
        end
        def nested?
          object.is_a? Statement
        end
        def to_s
          lbl = case
          when subject_only?
            subject.to_s
          when simple?
            "#{subject.to_s} #{rel} #{object.to_s}"
          when nested?
            "#{subject.to_s} #{rel} (#{object.to_s})"
          end
          comment ? lbl + ' //' + comment : lbl
        end
    end
    StatementGroup = Struct.new(:name, :statements, :annotations) do
      def to_s
        name = self.name
        if NonWordMatcher.match name
          name = %Q{"#{name}"}
        end
        %Q{SET STATEMENT_GROUP = #{name}}
      end
    end
    UnsetStatementGroup = Struct.new(:name) do
      def to_s
        %Q{UNSET STATEMENT_GROUP}
      end
    end

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
