# vim: ts=2 sw=2:
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
    statement_group = BEL::Language::StatementGroup.new(@value, [])
    @annotations = {}

    changed
    notify_observers(statement_group)
  }

  action docprop {
    docprop = BEL::Language::DocumentProperty.new(@name, @value)

    changed
    notify_observers(docprop)
  }

  action annotation {
    annotation = BEL::Language::Annotation.new(@name, @value)
    @annotations.store(@name, annotation)

    changed
    notify_observers(annotation)
  }

  action unset_annotation {
    @annotations.delete(@name)
  }

  action unset_statement_group {
    statement_group.annotations = @annotations.clone()
    @annotations.clear()

    changed
    notify_observers(BEL::Language::UnsetStatementGroup.new(statement_group.name))
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
      IDENT >s $n %name %unset_annotation NL @return |
      STATEMENT_GROUP_KW @unset_statement_group NL @return
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
