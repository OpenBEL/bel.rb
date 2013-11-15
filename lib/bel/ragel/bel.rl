# vim: ts=2 sw=2:
=begin
%%{
machine bel;

  include 'common.rl';
  include 'set.rl';
  include 'term.rl';
  include 'statement.rl';

  document_main :=
    (
      '\n' |
      '#' [^\n]+ '\n' @{puts 'doc comment'} |
      SET @call_set |
      UNSET @call_unset |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n}
      @statement_init @call_statement
    )+;
}%%
=end

require 'observer'

module BEL
  module Script
    DocumentProperty = Struct.new(:name, :value)
    Annotation = Struct.new(:name, :value)
    Parameter = Struct.new(:ns, :value)
    Term = Struct.new(:fx, :args) do
      def <<(item)
        self.args << item
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
    end
    StatementGroup = Struct.new(:name, :statements, :annotations)

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
