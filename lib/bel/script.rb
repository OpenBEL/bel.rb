# vim: ts=2 sw=2:
require_relative 'grammar/lexer.rb'
require_relative 'grammar/parser.rb'

module BEL
  module Script
    DocumentProperty            = Struct.new(:property, :value) 
    NamespaceDefinition         = Struct.new(:keyword, :url, :default?)   
    AnnotationListDefinition    = Struct.new(:keyword, :values)
    AnnotationPatternDefinition = Struct.new(:keyword, :pattern)
    AnnotationUrlDefinition     = Struct.new(:keyword, :url)
    SetStatementGroup           = Struct.new(:name)
    UnsetStatementGroup         = Struct.new(:name)
    SetAnnotation               = Struct.new(:keyword, :value)
    ParameterDefinition         = Struct.new(:namespace, :value)
    TermDefinition              = Struct.new(:function, :arguments)
    StatementDefinition         = Struct.new(:subject, :rel, :object,
                                             :comment) do
      def subject_only?
        !rel
      end
      def simple?
        object.is_a? TermDefinition
      end
      def nested?
        object.is_a? StatementDefinition
      end
    end

    module Parser

      def self.parse(source)
        return nil if not source

        antlr_parser = BEL::Script::Parser::Parser.new(source)
        if block_given? then
          yield from_tree(antlr_parser.document.tree)
        else
          from_tree(antlr_parser.document.tree)
        end
      end

      def self.parse_record(source)
        return nil if not source

        BEL::Script::Parser::Parser.new(source)
        if block_given?
          source.each_line do |line|
            antlr_parser = BEL::Script::Parser::Parser.new(line)
            record_ret = antlr_parser.record
            if record_ret.tree.length > 0
              yield from_tree(record_ret.tree)
            end
          end
        else
          parsed_lines = []
          source.each_line do |line|
            line.tr!("\r\n", '')
            antlr_parser = BEL::Script::Parser::Parser.new(line)
            record_ret = antlr_parser.record
            if record_ret.tree.length > 0
              parsed_lines << from_tree(record_ret.tree)
            end
          end
          return parsed_lines
        end
      end

      private

      def self.from_tree(tree)
        case tree.name
        when 'DOCDEF'
          tree.children.map { |x| from_tree(x) }
        when 'DOCSET_ID'
          BEL::Script::DocumentProperty.new(
            tree.children[0].text,
            tree.children[1].text)
        when 'DOCSET_QV'
          value = tree.children[1].text[1...-1]
          BEL::Script::DocumentProperty.new(
            tree.children[0].text,
            value)
        when 'DOCSET_LIST'
          values = tree.children[1].text[1...-1].split(' ,')
          BEL::Script::DocumentProperty.new(
            tree.children[0].text,
            values)
        when 'NSDEF'
          BEL::Script::NamespaceDefinition.new(
            tree.children[0].text,
            tree.children[1].text,
            false)
        when 'DFLT_NSDEF'
          BEL::Script::NamespaceDefinition.new(
            tree.children[0].text,
            tree.children[1].text,
            true)
        when 'ANNO_DEF_LIST'
          values = tree.children[1].text[1...-1].split(' ,')
          BEL::Script::AnnotationListDefinition.new(
            tree.children[0].text,
            values)
        when 'ANNO_DEF_PTRN'
          BEL::Script::AnnotationListDefinition.new(
            tree.children[0].text,
            tree.children[1].text)
        when 'ANNO_DEF_URL'
          BEL::Script::AnnotationListDefinition.new(
            tree.children[0].text,
            tree.children[1].text)
        when 'ANNO_SET_ID'
          BEL::Script::SetAnnotation.new(
            tree.children[0].text,
            tree.children[1].text)
        when 'ANNO_SET_LIST'
          values = tree.children[1].text[1...-1].split(' ,')
          BEL::Script::SetAnnotation.new(
            tree.children[0].text,
            values)
        when 'ANNO_SET_QV'
          BEL::Script::SetAnnotation.new(
            tree.children[0].text,
            tree.children[1].text)
        when 'SG_SET_ID'
          BEL::Script::SetStatementGroup.new(tree.children[0].text)
        when 'SG_SET_QV'
          value = tree.children[0].text[1...-1]
          BEL::Script::SetStatementGroup.new(value)
        when 'PARAM_DEF_ID'
          if tree.children.length == 2
            BEL::Script::ParameterDefinition.new(
              tree.children[0].text,
              tree.children[1].text)
          else
            BEL::Script::ParameterDefinition.new(
              nil,
              tree.children[0].text)
          end
        when 'PARAM_DEF_QV'
          if tree.children.length == 2
            value = tree.children[1].text[1...-1]
            BEL::Script::ParameterDefinition.new(
              tree.children[0].text,
              value)
          else
            value = tree.children[0].text[1...-1]
            BEL::Script::ParameterDefinition.new(
              nil,
              value)
          end
        when 'TERMDEF'
          func = tree.children[0].text
          args = tree.children[1..-1].map { |x| from_tree(x) }
          BEL::Script::TermDefinition.new(func, args)
        when 'STMTDEF'
          comment = nil
          if tree.children[0].text.start_with? '//'
            comment = tree.children[0].text[2..-1]
            tree.children.shift
          end

          if tree.children.length == 1
            sub = from_tree(tree.children[0])
            BEL::Script::StatementDefinition.new(sub, nil, nil, comment)
          else
            sub = from_tree(tree.children[0])
            rel = tree.children[1].text
            obj = from_tree(tree.children[2])
            BEL::Script::StatementDefinition.new(
              sub,
              rel,
              obj,
              comment)
          end
        when 'UNSET_SG'
          BEL::Script::UnsetStatementGroup.new('')
        else
          nil
        end
      end
    end
  end
end
