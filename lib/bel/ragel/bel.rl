# vim: ts=2 sw=2:
=begin
%%{
machine bel;

  include 'common.rl';
  include 'define.rl';
  include 'set.rl';
  include 'term.rl';
  include 'statement.rl';

  document_main :=
    (
      NL |
      '#' ^NL+ NL |
      DEFINE_KW SP+ ANNOTATION_KW @call_define_annotation |
      DEFINE_KW SP+ NAMESPACE_KW @call_define_namespace |
      SET_KW @call_set |
      UNSET_KW @call_unset |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n;} %{fpc -= n;}
      @statement_init @call_statement
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
          value = %Q{"#{self.value}"}
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
          case
          when subject_only?
            subject.to_s
          when simple?
            "#{subject.to_s} #{rel} #{object.to_s}"
          when nested?
            "#{subject.to_s} #{rel} (#{object.to_s})"
          end
        end
    end
    StatementGroup = Struct.new(:name, :statements, :annotations) do
      def to_s
        %Q{SET STATEMENT_GROUP = "#{self.name}"}
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
      if not obj.respond_to? :fx
        puts obj
      end
    end
  end

  parser = BEL::Script::Parser.new
  parser.add_observer(DefaultObserver.new)
  parser.parse(content) 
end
