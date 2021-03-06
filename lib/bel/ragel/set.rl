=begin
%%{
  machine bel;

  action call_set {
    fcall set;
  }

  action call_unset {
    fcall unset;
  }

  action sg_start {
    @statement_group = BEL::Language::StatementGroup.new(@value, [])
    @annotations = {}

    yield @statement_group
  }

  action docprop {
    docprop = BEL::Language::DocumentProperty.new(@name, @value)

    yield docprop
  }

  action annotation {
    annotation = BEL::Language::Annotation.new(@name, @value)
    @annotations.store(@name, annotation)

    yield annotation
  }

  action unset_annotation {
    @annotations.delete(@name)
    yield BEL::Language::UnsetAnnotation.new(@name)
  }

  action unset_statement_group {
    @statement_group.annotations = @annotations.clone()
    @annotations.clear()

    yield BEL::Language::UnsetStatementGroup.new(@statement_group.name)
  }

  include 'common.rl';

  statement_group =
    SP+ STATEMENT_GROUP_KW SP* EQL SP* (STRING | IDENT >s $n %val)
    %sg_start SP* NL @return;
  docprop = 
    SP+ DOC_KW SP+ DOC_PROPS >s $n %name SP* EQL SP* (STRING | IDENT >s $n %val)
     SP* NL @docprop @return;
  annotation =
    SP+ IDENT >s $n %name SP* EQL SP* (STRING | IDENT >s $n %val | LIST)
    SP* NL @annotation @return;

  set :=
    (statement_group | docprop | annotation);
  unset :=
    SP+
    (
      STATEMENT_GROUP_KW @unset_statement_group SP* NL @return |
      (IDENT - STATEMENT_GROUP_KW) >s $n %name %unset_annotation SP* NL @return
    );
  set_main :=
    (
      NL |
      SET_KW @call_set |
      UNSET_KW @call_unset
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
# vim: ts=2 sw=2:
# encoding: utf-8
