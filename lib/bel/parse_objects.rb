# vim: ts=2 sw=2:
require 'singleton'

module BEL
  module Script
    class Newline
      include Singleton
      def to_s
        ""
      end
    end
    Comment = Struct.new(:text) do
      def to_s
        %Q{##{self.text}}
      end
    end
    DocumentProperty = Struct.new(:name, :value) do
      def to_s
        value = self.value
        if NonWordMatcher.match value
          value = %Q{"#{value}"}
        end
        %Q{SET DOCUMENT #{self.name} = #{value}}
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
            value.gsub! '"', '\"'
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

    private
  end
end
