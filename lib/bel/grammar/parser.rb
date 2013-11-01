#!/usr/bin/env ruby
# vim: ts=2 sw=2:
#
# BELScript_v1.g
# --
# Generated using ANTLR version: 3.5
# Ruby runtime library version: 1.10.0
# Input grammar file: BELScript_v1.g
# Generated at: 2013-10-31 08:40:24
#

# ~~~> start load path setup
this_directory = File.expand_path( File.dirname( __FILE__ ) )
$LOAD_PATH.unshift( this_directory ) unless $LOAD_PATH.include?( this_directory )

antlr_load_failed = proc do
  load_path = $LOAD_PATH.map { |dir| '  - ' << dir }.join( $/ )
  raise LoadError, <<-END.strip!

Failed to load the ANTLR3 runtime library (version 1.10.0):

Ensure the library has been installed on your system and is available
on the load path. If rubygems is available on your system, this can
be done with the command:

  gem install antlr3

Current load path:
#{ load_path }

  END
end

defined?( ANTLR3 ) or begin

  # 1: try to load the ruby antlr3 runtime library from the system path
  require 'antlr3'

rescue LoadError

  # 2: try to load rubygems if it isn't already loaded
  defined?( Gem ) or begin
    require 'rubygems'
  rescue LoadError
    antlr_load_failed.call
  end

  # 3: try to activate the antlr3 gem
  begin
    defined?( gem ) and gem( 'antlr3', '~> 1.10.0' )
  rescue Gem::LoadError
    antlr_load_failed.call
  end

  require 'antlr3'

end
# <~~~ end load path setup

module BEL
  module Script
    module Parser
      # TokenData defines all of the token type integer values
      # as constants, which will be included in all
      # ANTLR-generated recognizers.
      const_defined?( :TokenData ) or TokenData = ANTLR3::TokenScheme.new

      module TokenData

        # define the token constants
        define_tokens( :EOF => -1, :T__64 => 64, :T__65 => 65, :T__66 => 66, 
                       :T__67 => 67, :T__68 => 68, :T__69 => 69, :T__70 => 70, 
                       :T__71 => 71, :T__72 => 72, :T__73 => 73, :T__74 => 74, 
                       :T__75 => 75, :T__76 => 76, :T__77 => 77, :T__78 => 78, 
                       :T__79 => 79, :T__80 => 80, :T__81 => 81, :T__82 => 82, 
                       :T__83 => 83, :T__84 => 84, :T__85 => 85, :T__86 => 86, 
                       :T__87 => 87, :T__88 => 88, :T__89 => 89, :T__90 => 90, 
                       :T__91 => 91, :T__92 => 92, :T__93 => 93, :T__94 => 94, 
                       :T__95 => 95, :T__96 => 96, :T__97 => 97, :T__98 => 98, 
                       :T__99 => 99, :T__100 => 100, :T__101 => 101, :T__102 => 102, 
                       :T__103 => 103, :T__104 => 104, :T__105 => 105, :T__106 => 106, 
                       :T__107 => 107, :T__108 => 108, :T__109 => 109, :T__110 => 110, 
                       :T__111 => 111, :T__112 => 112, :T__113 => 113, :T__114 => 114, 
                       :T__115 => 115, :T__116 => 116, :T__117 => 117, :T__118 => 118, 
                       :T__119 => 119, :T__120 => 120, :T__121 => 121, :T__122 => 122, 
                       :T__123 => 123, :T__124 => 124, :T__125 => 125, :T__126 => 126, 
                       :T__127 => 127, :T__128 => 128, :T__129 => 129, :T__130 => 130, 
                       :T__131 => 131, :T__132 => 132, :T__133 => 133, :T__134 => 134, 
                       :T__135 => 135, :T__136 => 136, :T__137 => 137, :T__138 => 138, 
                       :T__139 => 139, :T__140 => 140, :T__141 => 141, :T__142 => 142, 
                       :T__143 => 143, :T__144 => 144, :T__145 => 145, :T__146 => 146, 
                       :T__147 => 147, :T__148 => 148, :T__149 => 149, :T__150 => 150, 
                       :ANNO_DEF_LIST => 4, :ANNO_DEF_PTRN => 5, :ANNO_DEF_URL => 6, 
                       :ANNO_SET_ID => 7, :ANNO_SET_LIST => 8, :ANNO_SET_QV => 9, 
                       :COLON => 10, :COMMA => 11, :DFLT_NSDEF => 12, :DIGIT => 13, 
                       :DOCDEF => 14, :DOCSET_ID => 15, :DOCSET_LIST => 16, 
                       :DOCSET_QV => 17, :DOCUMENT_COMMENT => 18, :EQ => 19, 
                       :ESCAPE_SEQUENCE => 20, :HEX_DIGIT => 21, :IDENT_LIST => 22, 
                       :KWRD_ANNO => 23, :KWRD_AS => 24, :KWRD_AUTHORS => 25, 
                       :KWRD_CONTACTINFO => 26, :KWRD_COPYRIGHT => 27, :KWRD_DEFINE => 28, 
                       :KWRD_DESC => 29, :KWRD_DFLT => 30, :KWRD_DISCLAIMER => 31, 
                       :KWRD_DOCUMENT => 32, :KWRD_LICENSES => 33, :KWRD_LIST => 34, 
                       :KWRD_NAME => 35, :KWRD_NS => 36, :KWRD_PATTERN => 37, 
                       :KWRD_SET => 38, :KWRD_STMT_GROUP => 39, :KWRD_UNSET => 40, 
                       :KWRD_URL => 41, :KWRD_VERSION => 42, :LETTER => 43, 
                       :LP => 44, :NEWLINE => 45, :NSDEF => 46, :OBJECT_IDENT => 47, 
                       :OCTAL_ESCAPE => 48, :PARAM_DEF_ID => 49, :PARAM_DEF_QV => 50, 
                       :QUOTED_VALUE => 51, :RP => 52, :SG_SET_ID => 53, :SG_SET_QV => 54, 
                       :STATEMENT_COMMENT => 55, :STMTDEF => 56, :TERMDEF => 57, 
                       :UNICODE_ESCAPE => 58, :UNSET_ID => 59, :UNSET_ID_LIST => 60, 
                       :UNSET_SG => 61, :VALUE_LIST => 62, :WS => 63 )


        # register the proper human-readable name or literal value
        # for each token type
        #
        # this is necessary because anonymous tokens, which are
        # created from literal values in the grammar, do not
        # have descriptive names
        register_names( "ANNO_DEF_LIST", "ANNO_DEF_PTRN", "ANNO_DEF_URL", "ANNO_SET_ID", 
                        "ANNO_SET_LIST", "ANNO_SET_QV", "COLON", "COMMA", "DFLT_NSDEF", 
                        "DIGIT", "DOCDEF", "DOCSET_ID", "DOCSET_LIST", "DOCSET_QV", 
                        "DOCUMENT_COMMENT", "EQ", "ESCAPE_SEQUENCE", "HEX_DIGIT", 
                        "IDENT_LIST", "KWRD_ANNO", "KWRD_AS", "KWRD_AUTHORS", 
                        "KWRD_CONTACTINFO", "KWRD_COPYRIGHT", "KWRD_DEFINE", 
                        "KWRD_DESC", "KWRD_DFLT", "KWRD_DISCLAIMER", "KWRD_DOCUMENT", 
                        "KWRD_LICENSES", "KWRD_LIST", "KWRD_NAME", "KWRD_NS", 
                        "KWRD_PATTERN", "KWRD_SET", "KWRD_STMT_GROUP", "KWRD_UNSET", 
                        "KWRD_URL", "KWRD_VERSION", "LETTER", "LP", "NEWLINE", 
                        "NSDEF", "OBJECT_IDENT", "OCTAL_ESCAPE", "PARAM_DEF_ID", 
                        "PARAM_DEF_QV", "QUOTED_VALUE", "RP", "SG_SET_ID", "SG_SET_QV", 
                        "STATEMENT_COMMENT", "STMTDEF", "TERMDEF", "UNICODE_ESCAPE", 
                        "UNSET_ID", "UNSET_ID_LIST", "UNSET_SG", "VALUE_LIST", 
                        "WS", "'--'", "'->'", "'-|'", "':>'", "'=>'", "'=|'", 
                        "'>>'", "'a'", "'abundance'", "'act'", "'analogous'", 
                        "'association'", "'biologicalProcess'", "'biomarkerFor'", 
                        "'bp'", "'cat'", "'catalyticActivity'", "'causesNoChange'", 
                        "'cellSecretion'", "'cellSurfaceExpression'", "'chap'", 
                        "'chaperoneActivity'", "'complex'", "'complexAbundance'", 
                        "'composite'", "'compositeAbundance'", "'decreases'", 
                        "'deg'", "'degradation'", "'directlyDecreases'", "'directlyIncreases'", 
                        "'fus'", "'fusion'", "'g'", "'geneAbundance'", "'gtp'", 
                        "'gtpBoundActivity'", "'hasComponent'", "'hasComponents'", 
                        "'hasMember'", "'hasMembers'", "'increases'", "'isA'", 
                        "'kin'", "'kinaseActivity'", "'list'", "'m'", "'microRNAAbundance'", 
                        "'molecularActivity'", "'negativeCorrelation'", "'orthologous'", 
                        "'p'", "'path'", "'pathology'", "'pep'", "'peptidaseActivity'", 
                        "'phos'", "'phosphataseActivity'", "'pmod'", "'positiveCorrelation'", 
                        "'products'", "'prognosticBiomarkerFor'", "'proteinAbundance'", 
                        "'proteinModification'", "'r'", "'rateLimitingStepOf'", 
                        "'reactants'", "'reaction'", "'ribo'", "'ribosylationActivity'", 
                        "'rnaAbundance'", "'rxn'", "'sec'", "'sub'", "'subProcessOf'", 
                        "'substitution'", "'surf'", "'tloc'", "'tport'", "'transcribedTo'", 
                        "'transcriptionalActivity'", "'translatedTo'", "'translocation'", 
                        "'transportActivity'", "'trunc'", "'truncation'", "'tscript'" )


      end


      class Parser < ANTLR3::Parser
        @grammar_home = BEL::Script::Parser
        include ANTLR3::ASTBuilder

        RULE_METHODS = [ :document, :record, :set_doc_expr, :set_document, :set_sg_expr, 
                         :set_statement_group, :set_annotation, :unset_statement_group, 
                         :unset, :define_namespace, :define_anno_expr, :define_annotation, 
                         :document_property, :argument, :term, :statement, :ns_prefix, 
                         :param, :function, :relationship, :eq_clause ].freeze

        include TokenData

        begin
          generated_using( "BELScript_v1.g", "3.5", "1.10.0" )
        rescue NoMethodError => error
          # ignore
        end

        def initialize( input, options = {} )
          super( input, options )
        end
        # - - - - - - - - - - - - Rules - - - - - - - - - - - - -
        DocumentReturnValue = define_return_scope

        #
        # parser rule document
        #
        # (in BELScript_v1.g)
        # 67:1: document : ( NEWLINE | DOCUMENT_COMMENT | record )+ EOF -> ^( DOCDEF ( record )+ ) ;
        #
        def document
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 1 )


          return_value = DocumentReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          __NEWLINE1__ = nil
          __DOCUMENT_COMMENT2__ = nil
          __EOF4__ = nil
          record3 = nil


          tree_for_NEWLINE1 = nil
          tree_for_DOCUMENT_COMMENT2 = nil
          tree_for_EOF4 = nil
          stream_DOCUMENT_COMMENT = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token DOCUMENT_COMMENT" )
          stream_NEWLINE = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token NEWLINE" )
          stream_EOF = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token EOF" )
          stream_record = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule record" )
          begin
          # at line 68:9: ( NEWLINE | DOCUMENT_COMMENT | record )+ EOF
          # at file 68:9: ( NEWLINE | DOCUMENT_COMMENT | record )+
          match_count_1 = 0
          while true
            alt_1 = 4
            case look_1 = @input.peek( 1 )
            when NEWLINE then alt_1 = 1
            when DOCUMENT_COMMENT then alt_1 = 2
            when KWRD_DEFINE, KWRD_SET, KWRD_UNSET, T__71, T__72, T__73, T__76, T__78, T__79, T__80, T__82, T__83, T__84, T__85, T__86, T__87, T__88, T__89, T__91, T__92, T__95, T__96, T__97, T__98, T__99, T__100, T__107, T__108, T__109, T__110, T__111, T__112, T__115, T__116, T__117, T__118, T__119, T__120, T__121, T__122, T__124, T__126, T__127, T__128, T__130, T__131, T__132, T__133, T__134, T__135, T__136, T__137, T__139, T__140, T__141, T__142, T__144, T__146, T__147, T__148, T__149, T__150 then alt_1 = 3
            end
            case alt_1
            when 1
              # at line 68:10: NEWLINE
              __NEWLINE1__ = match( NEWLINE, TOKENS_FOLLOWING_NEWLINE_IN_document_327 )
              stream_NEWLINE.add( __NEWLINE1__ )


            when 2
              # at line 68:20: DOCUMENT_COMMENT
              __DOCUMENT_COMMENT2__ = match( DOCUMENT_COMMENT, TOKENS_FOLLOWING_DOCUMENT_COMMENT_IN_document_331 )
              stream_DOCUMENT_COMMENT.add( __DOCUMENT_COMMENT2__ )


            when 3
              # at line 68:39: record
              @state.following.push( TOKENS_FOLLOWING_record_IN_document_335 )
              record3 = record
              @state.following.pop
              stream_record.add( record3.tree )


            else
              match_count_1 > 0 and break
              eee = EarlyExit(1)


              raise eee
            end
            match_count_1 += 1
          end


          __EOF4__ = match( EOF, TOKENS_FOLLOWING_EOF_IN_document_339 )
          stream_EOF.add( __EOF4__ )

          # AST Rewrite
          # elements: record
          # token labels: 
          # rule labels: return_value
          # token list labels: 
          # rule list labels: 
          # wildcard labels: 
          return_value.tree = root_0
          stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

          root_0 = @adaptor.create_flat_list
          # 68:52: -> ^( DOCDEF ( record )+ )
          # at line 69:9: ^( DOCDEF ( record )+ )
          root_1 = @adaptor.create_flat_list
          root_1 = @adaptor.become_root( @adaptor.create_from_type( DOCDEF, "DOCDEF" ), root_1 )

          # at line 69:18: ( record )+
          stream_record.has_next? or raise ANTLR3::RewriteEarlyExit

          while stream_record.has_next?
            @adaptor.add_child( root_1, stream_record.next_tree )

          end
          stream_record.reset

          @adaptor.add_child( root_0, root_1 )




          return_value.tree = root_0



          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 1 )


          end

          return return_value
        end

        RecordReturnValue = define_return_scope

        #
        # parser rule record
        #
        # (in BELScript_v1.g)
        # 72:1: record : ( define_namespace | define_annotation | set_annotation | set_document | set_statement_group | unset_statement_group | unset | statement );
        #
        def record
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 2 )


          return_value = RecordReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          define_namespace5 = nil
          define_annotation6 = nil
          set_annotation7 = nil
          set_document8 = nil
          set_statement_group9 = nil
          unset_statement_group10 = nil
          unset11 = nil
          statement12 = nil



          begin
          # at line 73:5: ( define_namespace | define_annotation | set_annotation | set_document | set_statement_group | unset_statement_group | unset | statement )
          alt_2 = 8
          alt_2 = @dfa2.predict( @input )
          case alt_2
          when 1
            root_0 = @adaptor.create_flat_list


            # at line 73:9: define_namespace
            @state.following.push( TOKENS_FOLLOWING_define_namespace_IN_record_375 )
            define_namespace5 = define_namespace
            @state.following.pop
            @adaptor.add_child( root_0, define_namespace5.tree )


          when 2
            root_0 = @adaptor.create_flat_list


            # at line 74:9: define_annotation
            @state.following.push( TOKENS_FOLLOWING_define_annotation_IN_record_385 )
            define_annotation6 = define_annotation
            @state.following.pop
            @adaptor.add_child( root_0, define_annotation6.tree )


          when 3
            root_0 = @adaptor.create_flat_list


            # at line 75:9: set_annotation
            @state.following.push( TOKENS_FOLLOWING_set_annotation_IN_record_395 )
            set_annotation7 = set_annotation
            @state.following.pop
            @adaptor.add_child( root_0, set_annotation7.tree )


          when 4
            root_0 = @adaptor.create_flat_list


            # at line 76:9: set_document
            @state.following.push( TOKENS_FOLLOWING_set_document_IN_record_405 )
            set_document8 = set_document
            @state.following.pop
            @adaptor.add_child( root_0, set_document8.tree )


          when 5
            root_0 = @adaptor.create_flat_list


            # at line 77:9: set_statement_group
            @state.following.push( TOKENS_FOLLOWING_set_statement_group_IN_record_415 )
            set_statement_group9 = set_statement_group
            @state.following.pop
            @adaptor.add_child( root_0, set_statement_group9.tree )


          when 6
            root_0 = @adaptor.create_flat_list


            # at line 78:9: unset_statement_group
            @state.following.push( TOKENS_FOLLOWING_unset_statement_group_IN_record_425 )
            unset_statement_group10 = unset_statement_group
            @state.following.pop
            @adaptor.add_child( root_0, unset_statement_group10.tree )


          when 7
            root_0 = @adaptor.create_flat_list


            # at line 79:9: unset
            @state.following.push( TOKENS_FOLLOWING_unset_IN_record_435 )
            unset11 = unset
            @state.following.pop
            @adaptor.add_child( root_0, unset11.tree )


          when 8
            root_0 = @adaptor.create_flat_list


            # at line 80:9: statement
            @state.following.push( TOKENS_FOLLOWING_statement_IN_record_445 )
            statement12 = statement
            @state.following.pop
            @adaptor.add_child( root_0, statement12.tree )


          end
          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 2 )


          end

          return return_value
        end

        SetDocExprReturnValue = define_return_scope

        #
        # parser rule set_doc_expr
        #
        # (in BELScript_v1.g)
        # 83:1: set_doc_expr : KWRD_SET ( WS )* KWRD_DOCUMENT ( WS )* ;
        #
        def set_doc_expr
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 3 )


          return_value = SetDocExprReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          __KWRD_SET13__ = nil
          __WS14__ = nil
          __KWRD_DOCUMENT15__ = nil
          __WS16__ = nil


          tree_for_KWRD_SET13 = nil
          tree_for_WS14 = nil
          tree_for_KWRD_DOCUMENT15 = nil
          tree_for_WS16 = nil

          begin
          root_0 = @adaptor.create_flat_list


          # at line 84:9: KWRD_SET ( WS )* KWRD_DOCUMENT ( WS )*
          __KWRD_SET13__ = match( KWRD_SET, TOKENS_FOLLOWING_KWRD_SET_IN_set_doc_expr_464 )
          tree_for_KWRD_SET13 = @adaptor.create_with_payload( __KWRD_SET13__ )
          @adaptor.add_child( root_0, tree_for_KWRD_SET13 )


          # at line 84:18: ( WS )*
          while true # decision 3
            alt_3 = 2
            look_3_0 = @input.peek( 1 )

            if ( look_3_0 == WS )
              alt_3 = 1

            end
            case alt_3
            when 1
              # at line 84:18: WS
              __WS14__ = match( WS, TOKENS_FOLLOWING_WS_IN_set_doc_expr_466 )
              tree_for_WS14 = @adaptor.create_with_payload( __WS14__ )
              @adaptor.add_child( root_0, tree_for_WS14 )



            else
              break # out of loop for decision 3
            end
          end # loop for decision 3

          __KWRD_DOCUMENT15__ = match( KWRD_DOCUMENT, TOKENS_FOLLOWING_KWRD_DOCUMENT_IN_set_doc_expr_469 )
          tree_for_KWRD_DOCUMENT15 = @adaptor.create_with_payload( __KWRD_DOCUMENT15__ )
          @adaptor.add_child( root_0, tree_for_KWRD_DOCUMENT15 )


          # at line 84:36: ( WS )*
          while true # decision 4
            alt_4 = 2
            look_4_0 = @input.peek( 1 )

            if ( look_4_0 == WS )
              alt_4 = 1

            end
            case alt_4
            when 1
              # at line 84:36: WS
              __WS16__ = match( WS, TOKENS_FOLLOWING_WS_IN_set_doc_expr_471 )
              tree_for_WS16 = @adaptor.create_with_payload( __WS16__ )
              @adaptor.add_child( root_0, tree_for_WS16 )



            else
              break # out of loop for decision 4
            end
          end # loop for decision 4


          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 3 )


          end

          return return_value
        end

        SetDocumentReturnValue = define_return_scope

        #
        # parser rule set_document
        #
        # (in BELScript_v1.g)
        # 87:1: set_document : ( set_doc_expr document_property eq_clause val= QUOTED_VALUE -> ^( DOCSET_QV document_property $val) | set_doc_expr document_property eq_clause val= VALUE_LIST -> ^( DOCSET_LIST document_property $val) | set_doc_expr document_property eq_clause val= OBJECT_IDENT -> ^( DOCSET_ID document_property $val) );
        #
        def set_document
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 4 )


          return_value = SetDocumentReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          val = nil
          set_doc_expr17 = nil
          document_property18 = nil
          eq_clause19 = nil
          set_doc_expr20 = nil
          document_property21 = nil
          eq_clause22 = nil
          set_doc_expr23 = nil
          document_property24 = nil
          eq_clause25 = nil


          tree_for_val = nil
          stream_OBJECT_IDENT = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token OBJECT_IDENT" )
          stream_QUOTED_VALUE = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token QUOTED_VALUE" )
          stream_VALUE_LIST = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token VALUE_LIST" )
          stream_set_doc_expr = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule set_doc_expr" )
          stream_eq_clause = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule eq_clause" )
          stream_document_property = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule document_property" )
          begin
          # at line 88:5: ( set_doc_expr document_property eq_clause val= QUOTED_VALUE -> ^( DOCSET_QV document_property $val) | set_doc_expr document_property eq_clause val= VALUE_LIST -> ^( DOCSET_LIST document_property $val) | set_doc_expr document_property eq_clause val= OBJECT_IDENT -> ^( DOCSET_ID document_property $val) )
          alt_5 = 3
          alt_5 = @dfa5.predict( @input )
          case alt_5
          when 1
            # at line 88:9: set_doc_expr document_property eq_clause val= QUOTED_VALUE
            @state.following.push( TOKENS_FOLLOWING_set_doc_expr_IN_set_document_491 )
            set_doc_expr17 = set_doc_expr
            @state.following.pop
            stream_set_doc_expr.add( set_doc_expr17.tree )

            @state.following.push( TOKENS_FOLLOWING_document_property_IN_set_document_493 )
            document_property18 = document_property
            @state.following.pop
            stream_document_property.add( document_property18.tree )

            @state.following.push( TOKENS_FOLLOWING_eq_clause_IN_set_document_495 )
            eq_clause19 = eq_clause
            @state.following.pop
            stream_eq_clause.add( eq_clause19.tree )

            val = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_set_document_499 )
            stream_QUOTED_VALUE.add( val )

            # AST Rewrite
            # elements: val, document_property
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 88:67: -> ^( DOCSET_QV document_property $val)
            # at line 89:9: ^( DOCSET_QV document_property $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( DOCSET_QV, "DOCSET_QV" ), root_1 )

            @adaptor.add_child( root_1, stream_document_property.next_tree )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          when 2
            # at line 90:9: set_doc_expr document_property eq_clause val= VALUE_LIST
            @state.following.push( TOKENS_FOLLOWING_set_doc_expr_IN_set_document_528 )
            set_doc_expr20 = set_doc_expr
            @state.following.pop
            stream_set_doc_expr.add( set_doc_expr20.tree )

            @state.following.push( TOKENS_FOLLOWING_document_property_IN_set_document_530 )
            document_property21 = document_property
            @state.following.pop
            stream_document_property.add( document_property21.tree )

            @state.following.push( TOKENS_FOLLOWING_eq_clause_IN_set_document_532 )
            eq_clause22 = eq_clause
            @state.following.pop
            stream_eq_clause.add( eq_clause22.tree )

            val = match( VALUE_LIST, TOKENS_FOLLOWING_VALUE_LIST_IN_set_document_536 )
            stream_VALUE_LIST.add( val )

            # AST Rewrite
            # elements: val, document_property
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 90:65: -> ^( DOCSET_LIST document_property $val)
            # at line 91:9: ^( DOCSET_LIST document_property $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( DOCSET_LIST, "DOCSET_LIST" ), root_1 )

            @adaptor.add_child( root_1, stream_document_property.next_tree )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          when 3
            # at line 92:9: set_doc_expr document_property eq_clause val= OBJECT_IDENT
            @state.following.push( TOKENS_FOLLOWING_set_doc_expr_IN_set_document_565 )
            set_doc_expr23 = set_doc_expr
            @state.following.pop
            stream_set_doc_expr.add( set_doc_expr23.tree )

            @state.following.push( TOKENS_FOLLOWING_document_property_IN_set_document_567 )
            document_property24 = document_property
            @state.following.pop
            stream_document_property.add( document_property24.tree )

            @state.following.push( TOKENS_FOLLOWING_eq_clause_IN_set_document_569 )
            eq_clause25 = eq_clause
            @state.following.pop
            stream_eq_clause.add( eq_clause25.tree )

            val = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_document_573 )
            stream_OBJECT_IDENT.add( val )

            # AST Rewrite
            # elements: val, document_property
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 92:67: -> ^( DOCSET_ID document_property $val)
            # at line 93:9: ^( DOCSET_ID document_property $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( DOCSET_ID, "DOCSET_ID" ), root_1 )

            @adaptor.add_child( root_1, stream_document_property.next_tree )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          end
          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 4 )


          end

          return return_value
        end

        SetSgExprReturnValue = define_return_scope

        #
        # parser rule set_sg_expr
        #
        # (in BELScript_v1.g)
        # 96:1: set_sg_expr : KWRD_SET ( WS )* KWRD_STMT_GROUP ;
        #
        def set_sg_expr
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 5 )


          return_value = SetSgExprReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          __KWRD_SET26__ = nil
          __WS27__ = nil
          __KWRD_STMT_GROUP28__ = nil


          tree_for_KWRD_SET26 = nil
          tree_for_WS27 = nil
          tree_for_KWRD_STMT_GROUP28 = nil

          begin
          root_0 = @adaptor.create_flat_list


          # at line 97:9: KWRD_SET ( WS )* KWRD_STMT_GROUP
          __KWRD_SET26__ = match( KWRD_SET, TOKENS_FOLLOWING_KWRD_SET_IN_set_sg_expr_611 )
          tree_for_KWRD_SET26 = @adaptor.create_with_payload( __KWRD_SET26__ )
          @adaptor.add_child( root_0, tree_for_KWRD_SET26 )


          # at line 97:18: ( WS )*
          while true # decision 6
            alt_6 = 2
            look_6_0 = @input.peek( 1 )

            if ( look_6_0 == WS )
              alt_6 = 1

            end
            case alt_6
            when 1
              # at line 97:18: WS
              __WS27__ = match( WS, TOKENS_FOLLOWING_WS_IN_set_sg_expr_613 )
              tree_for_WS27 = @adaptor.create_with_payload( __WS27__ )
              @adaptor.add_child( root_0, tree_for_WS27 )



            else
              break # out of loop for decision 6
            end
          end # loop for decision 6

          __KWRD_STMT_GROUP28__ = match( KWRD_STMT_GROUP, TOKENS_FOLLOWING_KWRD_STMT_GROUP_IN_set_sg_expr_616 )
          tree_for_KWRD_STMT_GROUP28 = @adaptor.create_with_payload( __KWRD_STMT_GROUP28__ )
          @adaptor.add_child( root_0, tree_for_KWRD_STMT_GROUP28 )



          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 5 )


          end

          return return_value
        end

        SetStatementGroupReturnValue = define_return_scope

        #
        # parser rule set_statement_group
        #
        # (in BELScript_v1.g)
        # 100:1: set_statement_group : ( set_sg_expr eq_clause val= QUOTED_VALUE -> ^( SG_SET_QV $val) | set_sg_expr eq_clause val= OBJECT_IDENT -> ^( SG_SET_ID $val) );
        #
        def set_statement_group
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 6 )


          return_value = SetStatementGroupReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          val = nil
          set_sg_expr29 = nil
          eq_clause30 = nil
          set_sg_expr31 = nil
          eq_clause32 = nil


          tree_for_val = nil
          stream_OBJECT_IDENT = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token OBJECT_IDENT" )
          stream_QUOTED_VALUE = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token QUOTED_VALUE" )
          stream_eq_clause = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule eq_clause" )
          stream_set_sg_expr = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule set_sg_expr" )
          begin
          # at line 101:5: ( set_sg_expr eq_clause val= QUOTED_VALUE -> ^( SG_SET_QV $val) | set_sg_expr eq_clause val= OBJECT_IDENT -> ^( SG_SET_ID $val) )
          alt_7 = 2
          alt_7 = @dfa7.predict( @input )
          case alt_7
          when 1
            # at line 101:9: set_sg_expr eq_clause val= QUOTED_VALUE
            @state.following.push( TOKENS_FOLLOWING_set_sg_expr_IN_set_statement_group_635 )
            set_sg_expr29 = set_sg_expr
            @state.following.pop
            stream_set_sg_expr.add( set_sg_expr29.tree )

            @state.following.push( TOKENS_FOLLOWING_eq_clause_IN_set_statement_group_637 )
            eq_clause30 = eq_clause
            @state.following.pop
            stream_eq_clause.add( eq_clause30.tree )

            val = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_set_statement_group_641 )
            stream_QUOTED_VALUE.add( val )

            # AST Rewrite
            # elements: val
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 101:48: -> ^( SG_SET_QV $val)
            # at line 101:51: ^( SG_SET_QV $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( SG_SET_QV, "SG_SET_QV" ), root_1 )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          when 2
            # at line 102:9: set_sg_expr eq_clause val= OBJECT_IDENT
            @state.following.push( TOKENS_FOLLOWING_set_sg_expr_IN_set_statement_group_660 )
            set_sg_expr31 = set_sg_expr
            @state.following.pop
            stream_set_sg_expr.add( set_sg_expr31.tree )

            @state.following.push( TOKENS_FOLLOWING_eq_clause_IN_set_statement_group_662 )
            eq_clause32 = eq_clause
            @state.following.pop
            stream_eq_clause.add( eq_clause32.tree )

            val = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_statement_group_666 )
            stream_OBJECT_IDENT.add( val )

            # AST Rewrite
            # elements: val
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 102:48: -> ^( SG_SET_ID $val)
            # at line 102:51: ^( SG_SET_ID $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( SG_SET_ID, "SG_SET_ID" ), root_1 )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          end
          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 6 )


          end

          return return_value
        end

        SetAnnotationReturnValue = define_return_scope

        #
        # parser rule set_annotation
        #
        # (in BELScript_v1.g)
        # 105:1: set_annotation : ( KWRD_SET OBJECT_IDENT eq_clause val= QUOTED_VALUE -> ^( ANNO_SET_QV OBJECT_IDENT $val) | KWRD_SET OBJECT_IDENT eq_clause val= VALUE_LIST -> ^( ANNO_SET_LIST OBJECT_IDENT $val) | KWRD_SET OBJECT_IDENT eq_clause val= OBJECT_IDENT -> ^( ANNO_SET_ID OBJECT_IDENT $val) );
        #
        def set_annotation
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 7 )


          return_value = SetAnnotationReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          val = nil
          __KWRD_SET33__ = nil
          __OBJECT_IDENT34__ = nil
          __KWRD_SET36__ = nil
          __OBJECT_IDENT37__ = nil
          __KWRD_SET39__ = nil
          __OBJECT_IDENT40__ = nil
          eq_clause35 = nil
          eq_clause38 = nil
          eq_clause41 = nil


          tree_for_val = nil
          tree_for_KWRD_SET33 = nil
          tree_for_OBJECT_IDENT34 = nil
          tree_for_KWRD_SET36 = nil
          tree_for_OBJECT_IDENT37 = nil
          tree_for_KWRD_SET39 = nil
          tree_for_OBJECT_IDENT40 = nil
          stream_OBJECT_IDENT = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token OBJECT_IDENT" )
          stream_QUOTED_VALUE = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token QUOTED_VALUE" )
          stream_VALUE_LIST = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token VALUE_LIST" )
          stream_KWRD_SET = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_SET" )
          stream_eq_clause = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule eq_clause" )
          begin
          # at line 106:5: ( KWRD_SET OBJECT_IDENT eq_clause val= QUOTED_VALUE -> ^( ANNO_SET_QV OBJECT_IDENT $val) | KWRD_SET OBJECT_IDENT eq_clause val= VALUE_LIST -> ^( ANNO_SET_LIST OBJECT_IDENT $val) | KWRD_SET OBJECT_IDENT eq_clause val= OBJECT_IDENT -> ^( ANNO_SET_ID OBJECT_IDENT $val) )
          alt_8 = 3
          alt_8 = @dfa8.predict( @input )
          case alt_8
          when 1
            # at line 106:9: KWRD_SET OBJECT_IDENT eq_clause val= QUOTED_VALUE
            __KWRD_SET33__ = match( KWRD_SET, TOKENS_FOLLOWING_KWRD_SET_IN_set_annotation_694 )
            stream_KWRD_SET.add( __KWRD_SET33__ )

            __OBJECT_IDENT34__ = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_annotation_696 )
            stream_OBJECT_IDENT.add( __OBJECT_IDENT34__ )

            @state.following.push( TOKENS_FOLLOWING_eq_clause_IN_set_annotation_698 )
            eq_clause35 = eq_clause
            @state.following.pop
            stream_eq_clause.add( eq_clause35.tree )

            val = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_set_annotation_702 )
            stream_QUOTED_VALUE.add( val )

            # AST Rewrite
            # elements: OBJECT_IDENT, val
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 106:58: -> ^( ANNO_SET_QV OBJECT_IDENT $val)
            # at line 107:9: ^( ANNO_SET_QV OBJECT_IDENT $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( ANNO_SET_QV, "ANNO_SET_QV" ), root_1 )

            @adaptor.add_child( root_1, stream_OBJECT_IDENT.next_node )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          when 2
            # at line 108:9: KWRD_SET OBJECT_IDENT eq_clause val= VALUE_LIST
            __KWRD_SET36__ = match( KWRD_SET, TOKENS_FOLLOWING_KWRD_SET_IN_set_annotation_731 )
            stream_KWRD_SET.add( __KWRD_SET36__ )

            __OBJECT_IDENT37__ = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_annotation_733 )
            stream_OBJECT_IDENT.add( __OBJECT_IDENT37__ )

            @state.following.push( TOKENS_FOLLOWING_eq_clause_IN_set_annotation_735 )
            eq_clause38 = eq_clause
            @state.following.pop
            stream_eq_clause.add( eq_clause38.tree )

            val = match( VALUE_LIST, TOKENS_FOLLOWING_VALUE_LIST_IN_set_annotation_739 )
            stream_VALUE_LIST.add( val )

            # AST Rewrite
            # elements: OBJECT_IDENT, val
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 108:56: -> ^( ANNO_SET_LIST OBJECT_IDENT $val)
            # at line 109:9: ^( ANNO_SET_LIST OBJECT_IDENT $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( ANNO_SET_LIST, "ANNO_SET_LIST" ), root_1 )

            @adaptor.add_child( root_1, stream_OBJECT_IDENT.next_node )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          when 3
            # at line 110:9: KWRD_SET OBJECT_IDENT eq_clause val= OBJECT_IDENT
            __KWRD_SET39__ = match( KWRD_SET, TOKENS_FOLLOWING_KWRD_SET_IN_set_annotation_768 )
            stream_KWRD_SET.add( __KWRD_SET39__ )

            __OBJECT_IDENT40__ = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_annotation_770 )
            stream_OBJECT_IDENT.add( __OBJECT_IDENT40__ )

            @state.following.push( TOKENS_FOLLOWING_eq_clause_IN_set_annotation_772 )
            eq_clause41 = eq_clause
            @state.following.pop
            stream_eq_clause.add( eq_clause41.tree )

            val = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_annotation_776 )
            stream_OBJECT_IDENT.add( val )

            # AST Rewrite
            # elements: val, OBJECT_IDENT
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 110:58: -> ^( ANNO_SET_ID OBJECT_IDENT $val)
            # at line 111:9: ^( ANNO_SET_ID OBJECT_IDENT $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( ANNO_SET_ID, "ANNO_SET_ID" ), root_1 )

            @adaptor.add_child( root_1, stream_OBJECT_IDENT.next_node )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          end
          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 7 )


          end

          return return_value
        end

        UnsetStatementGroupReturnValue = define_return_scope

        #
        # parser rule unset_statement_group
        #
        # (in BELScript_v1.g)
        # 114:1: unset_statement_group : KWRD_UNSET KWRD_STMT_GROUP -> ^( UNSET_SG ) ;
        #
        def unset_statement_group
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 8 )


          return_value = UnsetStatementGroupReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          __KWRD_UNSET42__ = nil
          __KWRD_STMT_GROUP43__ = nil


          tree_for_KWRD_UNSET42 = nil
          tree_for_KWRD_STMT_GROUP43 = nil
          stream_KWRD_UNSET = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_UNSET" )
          stream_KWRD_STMT_GROUP = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_STMT_GROUP" )

          begin
          # at line 115:9: KWRD_UNSET KWRD_STMT_GROUP
          __KWRD_UNSET42__ = match( KWRD_UNSET, TOKENS_FOLLOWING_KWRD_UNSET_IN_unset_statement_group_814 )
          stream_KWRD_UNSET.add( __KWRD_UNSET42__ )

          __KWRD_STMT_GROUP43__ = match( KWRD_STMT_GROUP, TOKENS_FOLLOWING_KWRD_STMT_GROUP_IN_unset_statement_group_816 )
          stream_KWRD_STMT_GROUP.add( __KWRD_STMT_GROUP43__ )

          # AST Rewrite
          # elements: 
          # token labels: 
          # rule labels: return_value
          # token list labels: 
          # rule list labels: 
          # wildcard labels: 
          return_value.tree = root_0
          stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

          root_0 = @adaptor.create_flat_list
          # 115:36: -> ^( UNSET_SG )
          # at line 115:39: ^( UNSET_SG )
          root_1 = @adaptor.create_flat_list
          root_1 = @adaptor.become_root( @adaptor.create_from_type( UNSET_SG, "UNSET_SG" ), root_1 )

          @adaptor.add_child( root_0, root_1 )




          return_value.tree = root_0



          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 8 )


          end

          return return_value
        end

        UnsetReturnValue = define_return_scope

        #
        # parser rule unset
        #
        # (in BELScript_v1.g)
        # 118:1: unset : ( KWRD_UNSET val= OBJECT_IDENT -> ^( UNSET_ID $val) | KWRD_UNSET val= IDENT_LIST -> ^( UNSET_ID_LIST $val) );
        #
        def unset
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 9 )


          return_value = UnsetReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          val = nil
          __KWRD_UNSET44__ = nil
          __KWRD_UNSET45__ = nil


          tree_for_val = nil
          tree_for_KWRD_UNSET44 = nil
          tree_for_KWRD_UNSET45 = nil
          stream_OBJECT_IDENT = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token OBJECT_IDENT" )
          stream_KWRD_UNSET = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_UNSET" )
          stream_IDENT_LIST = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token IDENT_LIST" )

          begin
          # at line 119:5: ( KWRD_UNSET val= OBJECT_IDENT -> ^( UNSET_ID $val) | KWRD_UNSET val= IDENT_LIST -> ^( UNSET_ID_LIST $val) )
          alt_9 = 2
          look_9_0 = @input.peek( 1 )

          if ( look_9_0 == KWRD_UNSET )
            look_9_1 = @input.peek( 2 )

            if ( look_9_1 == OBJECT_IDENT )
              alt_9 = 1
            elsif ( look_9_1 == IDENT_LIST )
              alt_9 = 2
            else
              raise NoViableAlternative( "", 9, 1 )

            end
          else
            raise NoViableAlternative( "", 9, 0 )

          end
          case alt_9
          when 1
            # at line 119:9: KWRD_UNSET val= OBJECT_IDENT
            __KWRD_UNSET44__ = match( KWRD_UNSET, TOKENS_FOLLOWING_KWRD_UNSET_IN_unset_841 )
            stream_KWRD_UNSET.add( __KWRD_UNSET44__ )

            val = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_unset_845 )
            stream_OBJECT_IDENT.add( val )

            # AST Rewrite
            # elements: val
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 119:37: -> ^( UNSET_ID $val)
            # at line 119:40: ^( UNSET_ID $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( UNSET_ID, "UNSET_ID" ), root_1 )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          when 2
            # at line 120:9: KWRD_UNSET val= IDENT_LIST
            __KWRD_UNSET45__ = match( KWRD_UNSET, TOKENS_FOLLOWING_KWRD_UNSET_IN_unset_864 )
            stream_KWRD_UNSET.add( __KWRD_UNSET45__ )

            val = match( IDENT_LIST, TOKENS_FOLLOWING_IDENT_LIST_IN_unset_868 )
            stream_IDENT_LIST.add( val )

            # AST Rewrite
            # elements: val
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 120:35: -> ^( UNSET_ID_LIST $val)
            # at line 120:38: ^( UNSET_ID_LIST $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( UNSET_ID_LIST, "UNSET_ID_LIST" ), root_1 )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          end
          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 9 )


          end

          return return_value
        end

        DefineNamespaceReturnValue = define_return_scope

        #
        # parser rule define_namespace
        #
        # (in BELScript_v1.g)
        # 123:1: define_namespace : ( KWRD_DEFINE KWRD_DFLT KWRD_NS OBJECT_IDENT KWRD_AS KWRD_URL QUOTED_VALUE -> ^( DFLT_NSDEF OBJECT_IDENT QUOTED_VALUE ) | KWRD_DEFINE KWRD_NS OBJECT_IDENT KWRD_AS KWRD_URL QUOTED_VALUE -> ^( NSDEF OBJECT_IDENT QUOTED_VALUE ) );
        #
        def define_namespace
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 10 )


          return_value = DefineNamespaceReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          __KWRD_DEFINE46__ = nil
          __KWRD_DFLT47__ = nil
          __KWRD_NS48__ = nil
          __OBJECT_IDENT49__ = nil
          __KWRD_AS50__ = nil
          __KWRD_URL51__ = nil
          __QUOTED_VALUE52__ = nil
          __KWRD_DEFINE53__ = nil
          __KWRD_NS54__ = nil
          __OBJECT_IDENT55__ = nil
          __KWRD_AS56__ = nil
          __KWRD_URL57__ = nil
          __QUOTED_VALUE58__ = nil


          tree_for_KWRD_DEFINE46 = nil
          tree_for_KWRD_DFLT47 = nil
          tree_for_KWRD_NS48 = nil
          tree_for_OBJECT_IDENT49 = nil
          tree_for_KWRD_AS50 = nil
          tree_for_KWRD_URL51 = nil
          tree_for_QUOTED_VALUE52 = nil
          tree_for_KWRD_DEFINE53 = nil
          tree_for_KWRD_NS54 = nil
          tree_for_OBJECT_IDENT55 = nil
          tree_for_KWRD_AS56 = nil
          tree_for_KWRD_URL57 = nil
          tree_for_QUOTED_VALUE58 = nil
          stream_KWRD_DFLT = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_DFLT" )
          stream_KWRD_DEFINE = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_DEFINE" )
          stream_OBJECT_IDENT = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token OBJECT_IDENT" )
          stream_QUOTED_VALUE = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token QUOTED_VALUE" )
          stream_KWRD_NS = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_NS" )
          stream_KWRD_URL = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_URL" )
          stream_KWRD_AS = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_AS" )

          begin
          # at line 124:5: ( KWRD_DEFINE KWRD_DFLT KWRD_NS OBJECT_IDENT KWRD_AS KWRD_URL QUOTED_VALUE -> ^( DFLT_NSDEF OBJECT_IDENT QUOTED_VALUE ) | KWRD_DEFINE KWRD_NS OBJECT_IDENT KWRD_AS KWRD_URL QUOTED_VALUE -> ^( NSDEF OBJECT_IDENT QUOTED_VALUE ) )
          alt_10 = 2
          look_10_0 = @input.peek( 1 )

          if ( look_10_0 == KWRD_DEFINE )
            look_10_1 = @input.peek( 2 )

            if ( look_10_1 == KWRD_DFLT )
              alt_10 = 1
            elsif ( look_10_1 == KWRD_NS )
              alt_10 = 2
            else
              raise NoViableAlternative( "", 10, 1 )

            end
          else
            raise NoViableAlternative( "", 10, 0 )

          end
          case alt_10
          when 1
            # at line 124:9: KWRD_DEFINE KWRD_DFLT KWRD_NS OBJECT_IDENT KWRD_AS KWRD_URL QUOTED_VALUE
            __KWRD_DEFINE46__ = match( KWRD_DEFINE, TOKENS_FOLLOWING_KWRD_DEFINE_IN_define_namespace_896 )
            stream_KWRD_DEFINE.add( __KWRD_DEFINE46__ )

            __KWRD_DFLT47__ = match( KWRD_DFLT, TOKENS_FOLLOWING_KWRD_DFLT_IN_define_namespace_898 )
            stream_KWRD_DFLT.add( __KWRD_DFLT47__ )

            __KWRD_NS48__ = match( KWRD_NS, TOKENS_FOLLOWING_KWRD_NS_IN_define_namespace_900 )
            stream_KWRD_NS.add( __KWRD_NS48__ )

            __OBJECT_IDENT49__ = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_define_namespace_902 )
            stream_OBJECT_IDENT.add( __OBJECT_IDENT49__ )

            __KWRD_AS50__ = match( KWRD_AS, TOKENS_FOLLOWING_KWRD_AS_IN_define_namespace_904 )
            stream_KWRD_AS.add( __KWRD_AS50__ )

            __KWRD_URL51__ = match( KWRD_URL, TOKENS_FOLLOWING_KWRD_URL_IN_define_namespace_906 )
            stream_KWRD_URL.add( __KWRD_URL51__ )

            __QUOTED_VALUE52__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_define_namespace_908 )
            stream_QUOTED_VALUE.add( __QUOTED_VALUE52__ )

            # AST Rewrite
            # elements: OBJECT_IDENT, QUOTED_VALUE
            # token labels: 
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 124:82: -> ^( DFLT_NSDEF OBJECT_IDENT QUOTED_VALUE )
            # at line 125:9: ^( DFLT_NSDEF OBJECT_IDENT QUOTED_VALUE )
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( DFLT_NSDEF, "DFLT_NSDEF" ), root_1 )

            @adaptor.add_child( root_1, stream_OBJECT_IDENT.next_node )

            @adaptor.add_child( root_1, stream_QUOTED_VALUE.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          when 2
            # at line 126:9: KWRD_DEFINE KWRD_NS OBJECT_IDENT KWRD_AS KWRD_URL QUOTED_VALUE
            __KWRD_DEFINE53__ = match( KWRD_DEFINE, TOKENS_FOLLOWING_KWRD_DEFINE_IN_define_namespace_936 )
            stream_KWRD_DEFINE.add( __KWRD_DEFINE53__ )

            __KWRD_NS54__ = match( KWRD_NS, TOKENS_FOLLOWING_KWRD_NS_IN_define_namespace_938 )
            stream_KWRD_NS.add( __KWRD_NS54__ )

            __OBJECT_IDENT55__ = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_define_namespace_940 )
            stream_OBJECT_IDENT.add( __OBJECT_IDENT55__ )

            __KWRD_AS56__ = match( KWRD_AS, TOKENS_FOLLOWING_KWRD_AS_IN_define_namespace_942 )
            stream_KWRD_AS.add( __KWRD_AS56__ )

            __KWRD_URL57__ = match( KWRD_URL, TOKENS_FOLLOWING_KWRD_URL_IN_define_namespace_944 )
            stream_KWRD_URL.add( __KWRD_URL57__ )

            __QUOTED_VALUE58__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_define_namespace_946 )
            stream_QUOTED_VALUE.add( __QUOTED_VALUE58__ )

            # AST Rewrite
            # elements: OBJECT_IDENT, QUOTED_VALUE
            # token labels: 
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 126:72: -> ^( NSDEF OBJECT_IDENT QUOTED_VALUE )
            # at line 127:9: ^( NSDEF OBJECT_IDENT QUOTED_VALUE )
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( NSDEF, "NSDEF" ), root_1 )

            @adaptor.add_child( root_1, stream_OBJECT_IDENT.next_node )

            @adaptor.add_child( root_1, stream_QUOTED_VALUE.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          end
          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 10 )


          end

          return return_value
        end

        DefineAnnoExprReturnValue = define_return_scope

        #
        # parser rule define_anno_expr
        #
        # (in BELScript_v1.g)
        # 130:1: define_anno_expr : KWRD_DEFINE ( WS )* KWRD_ANNO ( WS )* ;
        #
        def define_anno_expr
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 11 )


          return_value = DefineAnnoExprReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          __KWRD_DEFINE59__ = nil
          __WS60__ = nil
          __KWRD_ANNO61__ = nil
          __WS62__ = nil


          tree_for_KWRD_DEFINE59 = nil
          tree_for_WS60 = nil
          tree_for_KWRD_ANNO61 = nil
          tree_for_WS62 = nil

          begin
          root_0 = @adaptor.create_flat_list


          # at line 131:9: KWRD_DEFINE ( WS )* KWRD_ANNO ( WS )*
          __KWRD_DEFINE59__ = match( KWRD_DEFINE, TOKENS_FOLLOWING_KWRD_DEFINE_IN_define_anno_expr_983 )
          tree_for_KWRD_DEFINE59 = @adaptor.create_with_payload( __KWRD_DEFINE59__ )
          @adaptor.add_child( root_0, tree_for_KWRD_DEFINE59 )


          # at line 131:21: ( WS )*
          while true # decision 11
            alt_11 = 2
            look_11_0 = @input.peek( 1 )

            if ( look_11_0 == WS )
              alt_11 = 1

            end
            case alt_11
            when 1
              # at line 131:21: WS
              __WS60__ = match( WS, TOKENS_FOLLOWING_WS_IN_define_anno_expr_985 )
              tree_for_WS60 = @adaptor.create_with_payload( __WS60__ )
              @adaptor.add_child( root_0, tree_for_WS60 )



            else
              break # out of loop for decision 11
            end
          end # loop for decision 11

          __KWRD_ANNO61__ = match( KWRD_ANNO, TOKENS_FOLLOWING_KWRD_ANNO_IN_define_anno_expr_988 )
          tree_for_KWRD_ANNO61 = @adaptor.create_with_payload( __KWRD_ANNO61__ )
          @adaptor.add_child( root_0, tree_for_KWRD_ANNO61 )


          # at line 131:35: ( WS )*
          while true # decision 12
            alt_12 = 2
            look_12_0 = @input.peek( 1 )

            if ( look_12_0 == WS )
              alt_12 = 1

            end
            case alt_12
            when 1
              # at line 131:35: WS
              __WS62__ = match( WS, TOKENS_FOLLOWING_WS_IN_define_anno_expr_990 )
              tree_for_WS62 = @adaptor.create_with_payload( __WS62__ )
              @adaptor.add_child( root_0, tree_for_WS62 )



            else
              break # out of loop for decision 12
            end
          end # loop for decision 12


          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 11 )


          end

          return return_value
        end

        DefineAnnotationReturnValue = define_return_scope

        #
        # parser rule define_annotation
        #
        # (in BELScript_v1.g)
        # 134:1: define_annotation : ( define_anno_expr OBJECT_IDENT KWRD_AS KWRD_LIST val= VALUE_LIST -> ^( ANNO_DEF_LIST OBJECT_IDENT $val) | define_anno_expr OBJECT_IDENT KWRD_AS KWRD_URL val= QUOTED_VALUE -> ^( ANNO_DEF_URL OBJECT_IDENT $val) | define_anno_expr OBJECT_IDENT KWRD_AS KWRD_PATTERN val= QUOTED_VALUE -> ^( ANNO_DEF_PTRN OBJECT_IDENT $val) );
        #
        def define_annotation
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 12 )


          return_value = DefineAnnotationReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          val = nil
          __OBJECT_IDENT64__ = nil
          __KWRD_AS65__ = nil
          __KWRD_LIST66__ = nil
          __OBJECT_IDENT68__ = nil
          __KWRD_AS69__ = nil
          __KWRD_URL70__ = nil
          __OBJECT_IDENT72__ = nil
          __KWRD_AS73__ = nil
          __KWRD_PATTERN74__ = nil
          define_anno_expr63 = nil
          define_anno_expr67 = nil
          define_anno_expr71 = nil


          tree_for_val = nil
          tree_for_OBJECT_IDENT64 = nil
          tree_for_KWRD_AS65 = nil
          tree_for_KWRD_LIST66 = nil
          tree_for_OBJECT_IDENT68 = nil
          tree_for_KWRD_AS69 = nil
          tree_for_KWRD_URL70 = nil
          tree_for_OBJECT_IDENT72 = nil
          tree_for_KWRD_AS73 = nil
          tree_for_KWRD_PATTERN74 = nil
          stream_OBJECT_IDENT = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token OBJECT_IDENT" )
          stream_KWRD_LIST = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_LIST" )
          stream_KWRD_PATTERN = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_PATTERN" )
          stream_QUOTED_VALUE = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token QUOTED_VALUE" )
          stream_KWRD_URL = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_URL" )
          stream_KWRD_AS = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token KWRD_AS" )
          stream_VALUE_LIST = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token VALUE_LIST" )
          stream_define_anno_expr = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule define_anno_expr" )
          begin
          # at line 135:5: ( define_anno_expr OBJECT_IDENT KWRD_AS KWRD_LIST val= VALUE_LIST -> ^( ANNO_DEF_LIST OBJECT_IDENT $val) | define_anno_expr OBJECT_IDENT KWRD_AS KWRD_URL val= QUOTED_VALUE -> ^( ANNO_DEF_URL OBJECT_IDENT $val) | define_anno_expr OBJECT_IDENT KWRD_AS KWRD_PATTERN val= QUOTED_VALUE -> ^( ANNO_DEF_PTRN OBJECT_IDENT $val) )
          alt_13 = 3
          alt_13 = @dfa13.predict( @input )
          case alt_13
          when 1
            # at line 135:9: define_anno_expr OBJECT_IDENT KWRD_AS KWRD_LIST val= VALUE_LIST
            @state.following.push( TOKENS_FOLLOWING_define_anno_expr_IN_define_annotation_1010 )
            define_anno_expr63 = define_anno_expr
            @state.following.pop
            stream_define_anno_expr.add( define_anno_expr63.tree )

            __OBJECT_IDENT64__ = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_define_annotation_1012 )
            stream_OBJECT_IDENT.add( __OBJECT_IDENT64__ )

            __KWRD_AS65__ = match( KWRD_AS, TOKENS_FOLLOWING_KWRD_AS_IN_define_annotation_1014 )
            stream_KWRD_AS.add( __KWRD_AS65__ )

            __KWRD_LIST66__ = match( KWRD_LIST, TOKENS_FOLLOWING_KWRD_LIST_IN_define_annotation_1016 )
            stream_KWRD_LIST.add( __KWRD_LIST66__ )

            val = match( VALUE_LIST, TOKENS_FOLLOWING_VALUE_LIST_IN_define_annotation_1020 )
            stream_VALUE_LIST.add( val )

            # AST Rewrite
            # elements: val, OBJECT_IDENT
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 135:72: -> ^( ANNO_DEF_LIST OBJECT_IDENT $val)
            # at line 136:9: ^( ANNO_DEF_LIST OBJECT_IDENT $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( ANNO_DEF_LIST, "ANNO_DEF_LIST" ), root_1 )

            @adaptor.add_child( root_1, stream_OBJECT_IDENT.next_node )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          when 2
            # at line 137:9: define_anno_expr OBJECT_IDENT KWRD_AS KWRD_URL val= QUOTED_VALUE
            @state.following.push( TOKENS_FOLLOWING_define_anno_expr_IN_define_annotation_1049 )
            define_anno_expr67 = define_anno_expr
            @state.following.pop
            stream_define_anno_expr.add( define_anno_expr67.tree )

            __OBJECT_IDENT68__ = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_define_annotation_1051 )
            stream_OBJECT_IDENT.add( __OBJECT_IDENT68__ )

            __KWRD_AS69__ = match( KWRD_AS, TOKENS_FOLLOWING_KWRD_AS_IN_define_annotation_1053 )
            stream_KWRD_AS.add( __KWRD_AS69__ )

            __KWRD_URL70__ = match( KWRD_URL, TOKENS_FOLLOWING_KWRD_URL_IN_define_annotation_1055 )
            stream_KWRD_URL.add( __KWRD_URL70__ )

            val = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_define_annotation_1059 )
            stream_QUOTED_VALUE.add( val )

            # AST Rewrite
            # elements: val, OBJECT_IDENT
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 137:73: -> ^( ANNO_DEF_URL OBJECT_IDENT $val)
            # at line 138:9: ^( ANNO_DEF_URL OBJECT_IDENT $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( ANNO_DEF_URL, "ANNO_DEF_URL" ), root_1 )

            @adaptor.add_child( root_1, stream_OBJECT_IDENT.next_node )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          when 3
            # at line 139:9: define_anno_expr OBJECT_IDENT KWRD_AS KWRD_PATTERN val= QUOTED_VALUE
            @state.following.push( TOKENS_FOLLOWING_define_anno_expr_IN_define_annotation_1088 )
            define_anno_expr71 = define_anno_expr
            @state.following.pop
            stream_define_anno_expr.add( define_anno_expr71.tree )

            __OBJECT_IDENT72__ = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_define_annotation_1090 )
            stream_OBJECT_IDENT.add( __OBJECT_IDENT72__ )

            __KWRD_AS73__ = match( KWRD_AS, TOKENS_FOLLOWING_KWRD_AS_IN_define_annotation_1092 )
            stream_KWRD_AS.add( __KWRD_AS73__ )

            __KWRD_PATTERN74__ = match( KWRD_PATTERN, TOKENS_FOLLOWING_KWRD_PATTERN_IN_define_annotation_1094 )
            stream_KWRD_PATTERN.add( __KWRD_PATTERN74__ )

            val = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_define_annotation_1098 )
            stream_QUOTED_VALUE.add( val )

            # AST Rewrite
            # elements: OBJECT_IDENT, val
            # token labels: val
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_val = token_stream( "token val", val )
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 139:77: -> ^( ANNO_DEF_PTRN OBJECT_IDENT $val)
            # at line 140:9: ^( ANNO_DEF_PTRN OBJECT_IDENT $val)
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( ANNO_DEF_PTRN, "ANNO_DEF_PTRN" ), root_1 )

            @adaptor.add_child( root_1, stream_OBJECT_IDENT.next_node )

            @adaptor.add_child( root_1, stream_val.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          end
          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 12 )


          end

          return return_value
        end

        DocumentPropertyReturnValue = define_return_scope

        #
        # parser rule document_property
        #
        # (in BELScript_v1.g)
        # 143:1: document_property : ( KWRD_AUTHORS | KWRD_CONTACTINFO | KWRD_COPYRIGHT | KWRD_DESC | KWRD_DISCLAIMER | KWRD_LICENSES | KWRD_NAME | KWRD_VERSION );
        #
        def document_property
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 13 )


          return_value = DocumentPropertyReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          set75 = nil


          tree_for_set75 = nil

          begin
          root_0 = @adaptor.create_flat_list


          # at line 
          set75 = @input.look

          if @input.peek( 1 ).between?( KWRD_AUTHORS, KWRD_COPYRIGHT ) || @input.peek(1) == KWRD_DESC || @input.peek(1) == KWRD_DISCLAIMER || @input.peek(1) == KWRD_LICENSES || @input.peek(1) == KWRD_NAME || @input.peek(1) == KWRD_VERSION
            @input.consume
            @adaptor.add_child( root_0, @adaptor.create_with_payload( set75 ) )

            @state.error_recovery = false

          else
            mse = MismatchedSet( nil )
            raise mse

          end



          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 13 )


          end

          return return_value
        end

        ArgumentReturnValue = define_return_scope

        #
        # parser rule argument
        #
        # (in BELScript_v1.g)
        # 154:1: argument : ( ( COMMA )? term -> term | ( COMMA )? param -> param );
        #
        def argument
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 14 )


          return_value = ArgumentReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          __COMMA76__ = nil
          __COMMA78__ = nil
          term77 = nil
          param79 = nil


          tree_for_COMMA76 = nil
          tree_for_COMMA78 = nil
          stream_COMMA = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token COMMA" )
          stream_param = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule param" )
          stream_term = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule term" )
          begin
          # at line 155:5: ( ( COMMA )? term -> term | ( COMMA )? param -> param )
          alt_16 = 2
          case look_16 = @input.peek( 1 )
          when COMMA then look_16_1 = @input.peek( 2 )

          if ( look_16_1.between?( T__71, T__73 ) || look_16_1 == T__76 || look_16_1.between?( T__78, T__80 ) || look_16_1.between?( T__82, T__89 ) || look_16_1.between?( T__91, T__92 ) || look_16_1.between?( T__95, T__100 ) || look_16_1.between?( T__107, T__112 ) || look_16_1.between?( T__115, T__122 ) || look_16_1 == T__124 || look_16_1.between?( T__126, T__128 ) || look_16_1.between?( T__130, T__137 ) || look_16_1.between?( T__139, T__142 ) || look_16_1 == T__144 || look_16_1.between?( T__146, T__150 ) )
            alt_16 = 1
          elsif ( look_16_1 == OBJECT_IDENT || look_16_1 == QUOTED_VALUE )
            alt_16 = 2
          else
            raise NoViableAlternative( "", 16, 1 )

          end
          when T__71, T__72, T__73, T__76, T__78, T__79, T__80, T__82, T__83, T__84, T__85, T__86, T__87, T__88, T__89, T__91, T__92, T__95, T__96, T__97, T__98, T__99, T__100, T__107, T__108, T__109, T__110, T__111, T__112, T__115, T__116, T__117, T__118, T__119, T__120, T__121, T__122, T__124, T__126, T__127, T__128, T__130, T__131, T__132, T__133, T__134, T__135, T__136, T__137, T__139, T__140, T__141, T__142, T__144, T__146, T__147, T__148, T__149, T__150 then alt_16 = 1
          when OBJECT_IDENT, QUOTED_VALUE then alt_16 = 2
          else
            raise NoViableAlternative( "", 16, 0 )

          end
          case alt_16
          when 1
            # at line 155:9: ( COMMA )? term
            # at line 155:9: ( COMMA )?
            alt_14 = 2
            look_14_0 = @input.peek( 1 )

            if ( look_14_0 == COMMA )
              alt_14 = 1
            end
            case alt_14
            when 1
              # at line 155:9: COMMA
              __COMMA76__ = match( COMMA, TOKENS_FOLLOWING_COMMA_IN_argument_1225 )
              stream_COMMA.add( __COMMA76__ )


            end
            @state.following.push( TOKENS_FOLLOWING_term_IN_argument_1228 )
            term77 = term
            @state.following.pop
            stream_term.add( term77.tree )

            # AST Rewrite
            # elements: term
            # token labels: 
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 155:21: -> term
            @adaptor.add_child( root_0, stream_term.next_tree )




            return_value.tree = root_0



          when 2
            # at line 156:9: ( COMMA )? param
            # at line 156:9: ( COMMA )?
            alt_15 = 2
            look_15_0 = @input.peek( 1 )

            if ( look_15_0 == COMMA )
              alt_15 = 1
            end
            case alt_15
            when 1
              # at line 156:9: COMMA
              __COMMA78__ = match( COMMA, TOKENS_FOLLOWING_COMMA_IN_argument_1242 )
              stream_COMMA.add( __COMMA78__ )


            end
            @state.following.push( TOKENS_FOLLOWING_param_IN_argument_1245 )
            param79 = param
            @state.following.pop
            stream_param.add( param79.tree )

            # AST Rewrite
            # elements: param
            # token labels: 
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 156:22: -> param
            @adaptor.add_child( root_0, stream_param.next_tree )




            return_value.tree = root_0



          end
          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 14 )


          end

          return return_value
        end

        TermReturnValue = define_return_scope

        #
        # parser rule term
        #
        # (in BELScript_v1.g)
        # 159:1: term : function LP ( argument )* RP -> ^( TERMDEF function ( argument )* ) ;
        #
        def term
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 15 )


          return_value = TermReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          __LP81__ = nil
          __RP83__ = nil
          function80 = nil
          argument82 = nil


          tree_for_LP81 = nil
          tree_for_RP83 = nil
          stream_RP = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token RP" )
          stream_LP = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token LP" )
          stream_argument = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule argument" )
          stream_function = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule function" )
          begin
          # at line 160:9: function LP ( argument )* RP
          @state.following.push( TOKENS_FOLLOWING_function_IN_term_1268 )
          function80 = function
          @state.following.pop
          stream_function.add( function80.tree )

          __LP81__ = match( LP, TOKENS_FOLLOWING_LP_IN_term_1270 )
          stream_LP.add( __LP81__ )

          # at line 160:21: ( argument )*
          while true # decision 17
            alt_17 = 2
            look_17_0 = @input.peek( 1 )

            if ( look_17_0 == COMMA || look_17_0 == OBJECT_IDENT || look_17_0 == QUOTED_VALUE || look_17_0.between?( T__71, T__73 ) || look_17_0 == T__76 || look_17_0.between?( T__78, T__80 ) || look_17_0.between?( T__82, T__89 ) || look_17_0.between?( T__91, T__92 ) || look_17_0.between?( T__95, T__100 ) || look_17_0.between?( T__107, T__112 ) || look_17_0.between?( T__115, T__122 ) || look_17_0 == T__124 || look_17_0.between?( T__126, T__128 ) || look_17_0.between?( T__130, T__137 ) || look_17_0.between?( T__139, T__142 ) || look_17_0 == T__144 || look_17_0.between?( T__146, T__150 ) )
              alt_17 = 1

            end
            case alt_17
            when 1
              # at line 160:22: argument
              @state.following.push( TOKENS_FOLLOWING_argument_IN_term_1273 )
              argument82 = argument
              @state.following.pop
              stream_argument.add( argument82.tree )


            else
              break # out of loop for decision 17
            end
          end # loop for decision 17

          __RP83__ = match( RP, TOKENS_FOLLOWING_RP_IN_term_1277 )
          stream_RP.add( __RP83__ )

          # AST Rewrite
          # elements: argument, function
          # token labels: 
          # rule labels: return_value
          # token list labels: 
          # rule list labels: 
          # wildcard labels: 
          return_value.tree = root_0
          stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

          root_0 = @adaptor.create_flat_list
          # 160:36: -> ^( TERMDEF function ( argument )* )
          # at line 161:9: ^( TERMDEF function ( argument )* )
          root_1 = @adaptor.create_flat_list
          root_1 = @adaptor.become_root( @adaptor.create_from_type( TERMDEF, "TERMDEF" ), root_1 )

          @adaptor.add_child( root_1, stream_function.next_tree )

          # at line 161:28: ( argument )*
          while stream_argument.has_next?
            @adaptor.add_child( root_1, stream_argument.next_tree )

          end

          stream_argument.reset();

          @adaptor.add_child( root_0, root_1 )




          return_value.tree = root_0



          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 15 )


          end

          return return_value
        end

        StatementReturnValue = define_return_scope

        #
        # parser rule statement
        #
        # (in BELScript_v1.g)
        # 166:1: statement : subject= term (rel= relationship ( LP obj_sub= term obj_rel= relationship obj_obj= term RP |obj= term ) )? (comment= STATEMENT_COMMENT )? -> ^( STMTDEF ( $comment)? $subject ( $rel)? ( $obj)? ( $obj_sub)? ( $obj_rel)? ( $obj_obj)? ) ;
        #
        def statement
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 16 )


          return_value = StatementReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          comment = nil
          __LP84__ = nil
          __RP85__ = nil
          subject = nil
          rel = nil
          obj_sub = nil
          obj_rel = nil
          obj_obj = nil
          obj = nil


          tree_for_comment = nil
          tree_for_LP84 = nil
          tree_for_RP85 = nil
          stream_RP = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token RP" )
          stream_STATEMENT_COMMENT = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token STATEMENT_COMMENT" )
          stream_LP = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token LP" )
          stream_relationship = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule relationship" )
          stream_term = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule term" )
          begin
          # at line 167:9: subject= term (rel= relationship ( LP obj_sub= term obj_rel= relationship obj_obj= term RP |obj= term ) )? (comment= STATEMENT_COMMENT )?
          @state.following.push( TOKENS_FOLLOWING_term_IN_statement_1319 )
          subject = term
          @state.following.pop
          stream_term.add( subject.tree )

          # at line 167:22: (rel= relationship ( LP obj_sub= term obj_rel= relationship obj_obj= term RP |obj= term ) )?
          alt_19 = 2
          look_19_0 = @input.peek( 1 )

          if ( look_19_0.between?( T__64, T__70 ) || look_19_0.between?( T__74, T__75 ) || look_19_0 == T__77 || look_19_0 == T__81 || look_19_0 == T__90 || look_19_0.between?( T__93, T__94 ) || look_19_0.between?( T__101, T__106 ) || look_19_0.between?( T__113, T__114 ) || look_19_0 == T__123 || look_19_0 == T__125 || look_19_0 == T__129 || look_19_0 == T__138 || look_19_0 == T__143 || look_19_0 == T__145 )
            alt_19 = 1
          end
          case alt_19
          when 1
            # at line 167:23: rel= relationship ( LP obj_sub= term obj_rel= relationship obj_obj= term RP |obj= term )
            @state.following.push( TOKENS_FOLLOWING_relationship_IN_statement_1324 )
            rel = relationship
            @state.following.pop
            stream_relationship.add( rel.tree )

            # at line 167:40: ( LP obj_sub= term obj_rel= relationship obj_obj= term RP |obj= term )
            alt_18 = 2
            look_18_0 = @input.peek( 1 )

            if ( look_18_0 == LP )
              alt_18 = 1
            elsif ( look_18_0.between?( T__71, T__73 ) || look_18_0 == T__76 || look_18_0.between?( T__78, T__80 ) || look_18_0.between?( T__82, T__89 ) || look_18_0.between?( T__91, T__92 ) || look_18_0.between?( T__95, T__100 ) || look_18_0.between?( T__107, T__112 ) || look_18_0.between?( T__115, T__122 ) || look_18_0 == T__124 || look_18_0.between?( T__126, T__128 ) || look_18_0.between?( T__130, T__137 ) || look_18_0.between?( T__139, T__142 ) || look_18_0 == T__144 || look_18_0.between?( T__146, T__150 ) )
              alt_18 = 2
            else
              raise NoViableAlternative( "", 18, 0 )

            end
            case alt_18
            when 1
              # at line 167:41: LP obj_sub= term obj_rel= relationship obj_obj= term RP
              __LP84__ = match( LP, TOKENS_FOLLOWING_LP_IN_statement_1327 )
              stream_LP.add( __LP84__ )

              @state.following.push( TOKENS_FOLLOWING_term_IN_statement_1331 )
              obj_sub = term
              @state.following.pop
              stream_term.add( obj_sub.tree )

              @state.following.push( TOKENS_FOLLOWING_relationship_IN_statement_1335 )
              obj_rel = relationship
              @state.following.pop
              stream_relationship.add( obj_rel.tree )

              @state.following.push( TOKENS_FOLLOWING_term_IN_statement_1339 )
              obj_obj = term
              @state.following.pop
              stream_term.add( obj_obj.tree )

              __RP85__ = match( RP, TOKENS_FOLLOWING_RP_IN_statement_1341 )
              stream_RP.add( __RP85__ )


            when 2
              # at line 167:96: obj= term
              @state.following.push( TOKENS_FOLLOWING_term_IN_statement_1347 )
              obj = term
              @state.following.pop
              stream_term.add( obj.tree )


            end

          end
          # at line 167:115: (comment= STATEMENT_COMMENT )?
          alt_20 = 2
          look_20_0 = @input.peek( 1 )

          if ( look_20_0 == STATEMENT_COMMENT )
            alt_20 = 1
          end
          case alt_20
          when 1
            # at line 167:115: comment= STATEMENT_COMMENT
            comment = match( STATEMENT_COMMENT, TOKENS_FOLLOWING_STATEMENT_COMMENT_IN_statement_1354 )
            stream_STATEMENT_COMMENT.add( comment )


          end
          # AST Rewrite
          # elements: subject, comment, obj_sub, obj, obj_rel, obj_obj, rel
          # token labels: comment
          # rule labels: obj_obj, obj_sub, return_value, subject, obj, rel, obj_rel
          # token list labels: 
          # rule list labels: 
          # wildcard labels: 
          return_value.tree = root_0
          stream_comment = token_stream( "token comment", comment )
          stream_obj_obj = obj_obj ? subtree_stream( "rule obj_obj", obj_obj.tree ) : subtree_stream( "token obj_obj" )
          stream_obj_sub = obj_sub ? subtree_stream( "rule obj_sub", obj_sub.tree ) : subtree_stream( "token obj_sub" )
          stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )
          stream_subject = subject ? subtree_stream( "rule subject", subject.tree ) : subtree_stream( "token subject" )
          stream_obj = obj ? subtree_stream( "rule obj", obj.tree ) : subtree_stream( "token obj" )
          stream_rel = rel ? subtree_stream( "rule rel", rel.tree ) : subtree_stream( "token rel" )
          stream_obj_rel = obj_rel ? subtree_stream( "rule obj_rel", obj_rel.tree ) : subtree_stream( "token obj_rel" )

          root_0 = @adaptor.create_flat_list
          # 167:135: -> ^( STMTDEF ( $comment)? $subject ( $rel)? ( $obj)? ( $obj_sub)? ( $obj_rel)? ( $obj_obj)? )
          # at line 168:9: ^( STMTDEF ( $comment)? $subject ( $rel)? ( $obj)? ( $obj_sub)? ( $obj_rel)? ( $obj_obj)? )
          root_1 = @adaptor.create_flat_list
          root_1 = @adaptor.become_root( @adaptor.create_from_type( STMTDEF, "STMTDEF" ), root_1 )

          # at line 168:20: ( $comment)?
          if stream_comment.has_next?
            @adaptor.add_child( root_1, stream_comment.next_node )

          end

          stream_comment.reset();

          @adaptor.add_child( root_1, stream_subject.next_tree )

          # at line 168:39: ( $rel)?
          if stream_rel.has_next?
            @adaptor.add_child( root_1, stream_rel.next_tree )

          end

          stream_rel.reset();

          # at line 168:45: ( $obj)?
          if stream_obj.has_next?
            @adaptor.add_child( root_1, stream_obj.next_tree )

          end

          stream_obj.reset();

          # at line 168:51: ( $obj_sub)?
          if stream_obj_sub.has_next?
            @adaptor.add_child( root_1, stream_obj_sub.next_tree )

          end

          stream_obj_sub.reset();

          # at line 168:61: ( $obj_rel)?
          if stream_obj_rel.has_next?
            @adaptor.add_child( root_1, stream_obj_rel.next_tree )

          end

          stream_obj_rel.reset();

          # at line 168:71: ( $obj_obj)?
          if stream_obj_obj.has_next?
            @adaptor.add_child( root_1, stream_obj_obj.next_tree )

          end

          stream_obj_obj.reset();

          @adaptor.add_child( root_0, root_1 )




          return_value.tree = root_0



          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 16 )


          end

          return return_value
        end

        NsPrefixReturnValue = define_return_scope

        #
        # parser rule ns_prefix
        #
        # (in BELScript_v1.g)
        # 171:1: ns_prefix : OBJECT_IDENT COLON !;
        #
        def ns_prefix
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 17 )


          return_value = NsPrefixReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          __OBJECT_IDENT86__ = nil
          __COLON87__ = nil


          tree_for_OBJECT_IDENT86 = nil
          tree_for_COLON87 = nil

          begin
          root_0 = @adaptor.create_flat_list


          # at line 172:9: OBJECT_IDENT COLON !
          __OBJECT_IDENT86__ = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_ns_prefix_1415 )
          tree_for_OBJECT_IDENT86 = @adaptor.create_with_payload( __OBJECT_IDENT86__ )
          @adaptor.add_child( root_0, tree_for_OBJECT_IDENT86 )


          __COLON87__ = match( COLON, TOKENS_FOLLOWING_COLON_IN_ns_prefix_1417 )

          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 17 )


          end

          return return_value
        end

        ParamReturnValue = define_return_scope

        #
        # parser rule param
        #
        # (in BELScript_v1.g)
        # 175:1: param : ( ( ns_prefix )? OBJECT_IDENT -> ^( PARAM_DEF_ID ( ns_prefix )? OBJECT_IDENT ) | ( ns_prefix )? QUOTED_VALUE -> ^( PARAM_DEF_QV ( ns_prefix )? QUOTED_VALUE ) );
        #
        def param
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 18 )


          return_value = ParamReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          __OBJECT_IDENT89__ = nil
          __QUOTED_VALUE91__ = nil
          ns_prefix88 = nil
          ns_prefix90 = nil


          tree_for_OBJECT_IDENT89 = nil
          tree_for_QUOTED_VALUE91 = nil
          stream_OBJECT_IDENT = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token OBJECT_IDENT" )
          stream_QUOTED_VALUE = ANTLR3::AST::RewriteRuleTokenStream.new( @adaptor, "token QUOTED_VALUE" )
          stream_ns_prefix = ANTLR3::AST::RewriteRuleSubtreeStream.new( @adaptor, "rule ns_prefix" )
          begin
          # at line 176:5: ( ( ns_prefix )? OBJECT_IDENT -> ^( PARAM_DEF_ID ( ns_prefix )? OBJECT_IDENT ) | ( ns_prefix )? QUOTED_VALUE -> ^( PARAM_DEF_QV ( ns_prefix )? QUOTED_VALUE ) )
          alt_23 = 2
          look_23_0 = @input.peek( 1 )

          if ( look_23_0 == OBJECT_IDENT )
            look_23_1 = @input.peek( 2 )

            if ( look_23_1 == COLON )
              look_23_3 = @input.peek( 3 )

              if ( look_23_3 == OBJECT_IDENT )
                alt_23 = 1
              elsif ( look_23_3 == QUOTED_VALUE )
                alt_23 = 2
              else
                raise NoViableAlternative( "", 23, 3 )

              end
            elsif ( look_23_1 == COMMA || look_23_1 == OBJECT_IDENT || look_23_1.between?( QUOTED_VALUE, RP ) || look_23_1.between?( T__71, T__73 ) || look_23_1 == T__76 || look_23_1.between?( T__78, T__80 ) || look_23_1.between?( T__82, T__89 ) || look_23_1.between?( T__91, T__92 ) || look_23_1.between?( T__95, T__100 ) || look_23_1.between?( T__107, T__112 ) || look_23_1.between?( T__115, T__122 ) || look_23_1 == T__124 || look_23_1.between?( T__126, T__128 ) || look_23_1.between?( T__130, T__137 ) || look_23_1.between?( T__139, T__142 ) || look_23_1 == T__144 || look_23_1.between?( T__146, T__150 ) )
              alt_23 = 1
            else
              raise NoViableAlternative( "", 23, 1 )

            end
          elsif ( look_23_0 == QUOTED_VALUE )
            alt_23 = 2
          else
            raise NoViableAlternative( "", 23, 0 )

          end
          case alt_23
          when 1
            # at line 176:9: ( ns_prefix )? OBJECT_IDENT
            # at line 176:9: ( ns_prefix )?
            alt_21 = 2
            look_21_0 = @input.peek( 1 )

            if ( look_21_0 == OBJECT_IDENT )
              look_21_1 = @input.peek( 2 )

              if ( look_21_1 == COLON )
                alt_21 = 1
              end
            end
            case alt_21
            when 1
              # at line 176:9: ns_prefix
              @state.following.push( TOKENS_FOLLOWING_ns_prefix_IN_param_1437 )
              ns_prefix88 = ns_prefix
              @state.following.pop
              stream_ns_prefix.add( ns_prefix88.tree )


            end
            __OBJECT_IDENT89__ = match( OBJECT_IDENT, TOKENS_FOLLOWING_OBJECT_IDENT_IN_param_1440 )
            stream_OBJECT_IDENT.add( __OBJECT_IDENT89__ )

            # AST Rewrite
            # elements: OBJECT_IDENT, ns_prefix
            # token labels: 
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 176:33: -> ^( PARAM_DEF_ID ( ns_prefix )? OBJECT_IDENT )
            # at line 176:36: ^( PARAM_DEF_ID ( ns_prefix )? OBJECT_IDENT )
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( PARAM_DEF_ID, "PARAM_DEF_ID" ), root_1 )

            # at line 176:51: ( ns_prefix )?
            if stream_ns_prefix.has_next?
              @adaptor.add_child( root_1, stream_ns_prefix.next_tree )

            end

            stream_ns_prefix.reset();

            @adaptor.add_child( root_1, stream_OBJECT_IDENT.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          when 2
            # at line 177:9: ( ns_prefix )? QUOTED_VALUE
            # at line 177:9: ( ns_prefix )?
            alt_22 = 2
            look_22_0 = @input.peek( 1 )

            if ( look_22_0 == OBJECT_IDENT )
              alt_22 = 1
            end
            case alt_22
            when 1
              # at line 177:9: ns_prefix
              @state.following.push( TOKENS_FOLLOWING_ns_prefix_IN_param_1461 )
              ns_prefix90 = ns_prefix
              @state.following.pop
              stream_ns_prefix.add( ns_prefix90.tree )


            end
            __QUOTED_VALUE91__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_param_1464 )
            stream_QUOTED_VALUE.add( __QUOTED_VALUE91__ )

            # AST Rewrite
            # elements: QUOTED_VALUE, ns_prefix
            # token labels: 
            # rule labels: return_value
            # token list labels: 
            # rule list labels: 
            # wildcard labels: 
            return_value.tree = root_0
            stream_return_value = return_value ? subtree_stream( "rule return_value", return_value.tree ) : subtree_stream( "token return_value" )

            root_0 = @adaptor.create_flat_list
            # 177:33: -> ^( PARAM_DEF_QV ( ns_prefix )? QUOTED_VALUE )
            # at line 177:36: ^( PARAM_DEF_QV ( ns_prefix )? QUOTED_VALUE )
            root_1 = @adaptor.create_flat_list
            root_1 = @adaptor.become_root( @adaptor.create_from_type( PARAM_DEF_QV, "PARAM_DEF_QV" ), root_1 )

            # at line 177:51: ( ns_prefix )?
            if stream_ns_prefix.has_next?
              @adaptor.add_child( root_1, stream_ns_prefix.next_tree )

            end

            stream_ns_prefix.reset();

            @adaptor.add_child( root_1, stream_QUOTED_VALUE.next_node )

            @adaptor.add_child( root_0, root_1 )




            return_value.tree = root_0



          end
          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 18 )


          end

          return return_value
        end

        FunctionReturnValue = define_return_scope :r

        #
        # parser rule function
        #
        # (in BELScript_v1.g)
        # 180:1: function returns [r] : (fv= 'proteinAbundance' |fv= 'p' |fv= 'rnaAbundance' |fv= 'r' |fv= 'abundance' |fv= 'a' |fv= 'microRNAAbundance' |fv= 'm' |fv= 'geneAbundance' |fv= 'g' |fv= 'biologicalProcess' |fv= 'bp' |fv= 'pathology' |fv= 'path' |fv= 'complexAbundance' |fv= 'complex' |fv= 'translocation' |fv= 'tloc' |fv= 'cellSecretion' |fv= 'sec' |fv= 'cellSurfaceExpression' |fv= 'surf' |fv= 'reaction' |fv= 'rxn' |fv= 'compositeAbundance' |fv= 'composite' |fv= 'fusion' |fv= 'fus' |fv= 'degradation' |fv= 'deg' |fv= 'molecularActivity' |fv= 'act' |fv= 'catalyticActivity' |fv= 'cat' |fv= 'kinaseActivity' |fv= 'kin' |fv= 'phosphataseActivity' |fv= 'phos' |fv= 'peptidaseActivity' |fv= 'pep' |fv= 'ribosylationActivity' |fv= 'ribo' |fv= 'transcriptionalActivity' |fv= 'tscript' |fv= 'transportActivity' |fv= 'tport' |fv= 'gtpBoundActivity' |fv= 'gtp' |fv= 'chaperoneActivity' |fv= 'chap' |fv= 'proteinModification' |fv= 'pmod' |fv= 'substitution' |fv= 'sub' |fv= 'truncation' |fv= 'trunc' |fv= 'reactants' |fv= 'products' |fv= 'list' );
        #
        def function
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 19 )


          return_value = FunctionReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          fv = nil


          tree_for_fv = nil

          begin
          # at line 181:5: (fv= 'proteinAbundance' |fv= 'p' |fv= 'rnaAbundance' |fv= 'r' |fv= 'abundance' |fv= 'a' |fv= 'microRNAAbundance' |fv= 'm' |fv= 'geneAbundance' |fv= 'g' |fv= 'biologicalProcess' |fv= 'bp' |fv= 'pathology' |fv= 'path' |fv= 'complexAbundance' |fv= 'complex' |fv= 'translocation' |fv= 'tloc' |fv= 'cellSecretion' |fv= 'sec' |fv= 'cellSurfaceExpression' |fv= 'surf' |fv= 'reaction' |fv= 'rxn' |fv= 'compositeAbundance' |fv= 'composite' |fv= 'fusion' |fv= 'fus' |fv= 'degradation' |fv= 'deg' |fv= 'molecularActivity' |fv= 'act' |fv= 'catalyticActivity' |fv= 'cat' |fv= 'kinaseActivity' |fv= 'kin' |fv= 'phosphataseActivity' |fv= 'phos' |fv= 'peptidaseActivity' |fv= 'pep' |fv= 'ribosylationActivity' |fv= 'ribo' |fv= 'transcriptionalActivity' |fv= 'tscript' |fv= 'transportActivity' |fv= 'tport' |fv= 'gtpBoundActivity' |fv= 'gtp' |fv= 'chaperoneActivity' |fv= 'chap' |fv= 'proteinModification' |fv= 'pmod' |fv= 'substitution' |fv= 'sub' |fv= 'truncation' |fv= 'trunc' |fv= 'reactants' |fv= 'products' |fv= 'list' )
          alt_24 = 59
          case look_24 = @input.peek( 1 )
          when T__126 then alt_24 = 1
          when T__115 then alt_24 = 2
          when T__134 then alt_24 = 3
          when T__128 then alt_24 = 4
          when T__72 then alt_24 = 5
          when T__71 then alt_24 = 6
          when T__111 then alt_24 = 7
          when T__110 then alt_24 = 8
          when T__98 then alt_24 = 9
          when T__97 then alt_24 = 10
          when T__76 then alt_24 = 11
          when T__78 then alt_24 = 12
          when T__117 then alt_24 = 13
          when T__116 then alt_24 = 14
          when T__87 then alt_24 = 15
          when T__86 then alt_24 = 16
          when T__146 then alt_24 = 17
          when T__141 then alt_24 = 18
          when T__82 then alt_24 = 19
          when T__136 then alt_24 = 20
          when T__83 then alt_24 = 21
          when T__140 then alt_24 = 22
          when T__131 then alt_24 = 23
          when T__135 then alt_24 = 24
          when T__89 then alt_24 = 25
          when T__88 then alt_24 = 26
          when T__96 then alt_24 = 27
          when T__95 then alt_24 = 28
          when T__92 then alt_24 = 29
          when T__91 then alt_24 = 30
          when T__112 then alt_24 = 31
          when T__73 then alt_24 = 32
          when T__80 then alt_24 = 33
          when T__79 then alt_24 = 34
          when T__108 then alt_24 = 35
          when T__107 then alt_24 = 36
          when T__121 then alt_24 = 37
          when T__120 then alt_24 = 38
          when T__119 then alt_24 = 39
          when T__118 then alt_24 = 40
          when T__133 then alt_24 = 41
          when T__132 then alt_24 = 42
          when T__144 then alt_24 = 43
          when T__150 then alt_24 = 44
          when T__147 then alt_24 = 45
          when T__142 then alt_24 = 46
          when T__100 then alt_24 = 47
          when T__99 then alt_24 = 48
          when T__85 then alt_24 = 49
          when T__84 then alt_24 = 50
          when T__127 then alt_24 = 51
          when T__122 then alt_24 = 52
          when T__139 then alt_24 = 53
          when T__137 then alt_24 = 54
          when T__149 then alt_24 = 55
          when T__148 then alt_24 = 56
          when T__130 then alt_24 = 57
          when T__124 then alt_24 = 58
          when T__109 then alt_24 = 59
          else
            raise NoViableAlternative( "", 24, 0 )

          end
          case alt_24
          when 1
            root_0 = @adaptor.create_flat_list


            # at line 181:9: fv= 'proteinAbundance'
            fv = match( T__126, TOKENS_FOLLOWING_T__126_IN_function_1500 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "p"
            # <-- action


          when 2
            root_0 = @adaptor.create_flat_list


            # at line 182:9: fv= 'p'
            fv = match( T__115, TOKENS_FOLLOWING_T__115_IN_function_1524 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "p"
            # <-- action


          when 3
            root_0 = @adaptor.create_flat_list


            # at line 183:9: fv= 'rnaAbundance'
            fv = match( T__134, TOKENS_FOLLOWING_T__134_IN_function_1563 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "r"
            # <-- action


          when 4
            root_0 = @adaptor.create_flat_list


            # at line 184:9: fv= 'r'
            fv = match( T__128, TOKENS_FOLLOWING_T__128_IN_function_1591 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "r"
            # <-- action


          when 5
            root_0 = @adaptor.create_flat_list


            # at line 185:9: fv= 'abundance'
            fv = match( T__72, TOKENS_FOLLOWING_T__72_IN_function_1630 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "a"
            # <-- action


          when 6
            root_0 = @adaptor.create_flat_list


            # at line 186:9: fv= 'a'
            fv = match( T__71, TOKENS_FOLLOWING_T__71_IN_function_1661 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "a"
            # <-- action


          when 7
            root_0 = @adaptor.create_flat_list


            # at line 187:9: fv= 'microRNAAbundance'
            fv = match( T__111, TOKENS_FOLLOWING_T__111_IN_function_1700 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "m"
            # <-- action


          when 8
            root_0 = @adaptor.create_flat_list


            # at line 188:9: fv= 'm'
            fv = match( T__110, TOKENS_FOLLOWING_T__110_IN_function_1723 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "m"
            # <-- action


          when 9
            root_0 = @adaptor.create_flat_list


            # at line 189:9: fv= 'geneAbundance'
            fv = match( T__98, TOKENS_FOLLOWING_T__98_IN_function_1762 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "g"
            # <-- action


          when 10
            root_0 = @adaptor.create_flat_list


            # at line 190:9: fv= 'g'
            fv = match( T__97, TOKENS_FOLLOWING_T__97_IN_function_1789 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "g"
            # <-- action


          when 11
            root_0 = @adaptor.create_flat_list


            # at line 191:9: fv= 'biologicalProcess'
            fv = match( T__76, TOKENS_FOLLOWING_T__76_IN_function_1828 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "bp"
            # <-- action


          when 12
            root_0 = @adaptor.create_flat_list


            # at line 192:9: fv= 'bp'
            fv = match( T__78, TOKENS_FOLLOWING_T__78_IN_function_1851 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "bp"
            # <-- action


          when 13
            root_0 = @adaptor.create_flat_list


            # at line 193:9: fv= 'pathology'
            fv = match( T__117, TOKENS_FOLLOWING_T__117_IN_function_1889 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "path"
            # <-- action


          when 14
            root_0 = @adaptor.create_flat_list


            # at line 194:9: fv= 'path'
            fv = match( T__116, TOKENS_FOLLOWING_T__116_IN_function_1920 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "path"
            # <-- action


          when 15
            root_0 = @adaptor.create_flat_list


            # at line 195:9: fv= 'complexAbundance'
            fv = match( T__87, TOKENS_FOLLOWING_T__87_IN_function_1956 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "complex"
            # <-- action


          when 16
            root_0 = @adaptor.create_flat_list


            # at line 196:9: fv= 'complex'
            fv = match( T__86, TOKENS_FOLLOWING_T__86_IN_function_1980 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "complex"
            # <-- action


          when 17
            root_0 = @adaptor.create_flat_list


            # at line 197:9: fv= 'translocation'
            fv = match( T__146, TOKENS_FOLLOWING_T__146_IN_function_2013 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "tloc"
            # <-- action


          when 18
            root_0 = @adaptor.create_flat_list


            # at line 198:9: fv= 'tloc'
            fv = match( T__141, TOKENS_FOLLOWING_T__141_IN_function_2040 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "tloc"
            # <-- action


          when 19
            root_0 = @adaptor.create_flat_list


            # at line 199:9: fv= 'cellSecretion'
            fv = match( T__82, TOKENS_FOLLOWING_T__82_IN_function_2076 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "sec"
            # <-- action


          when 20
            root_0 = @adaptor.create_flat_list


            # at line 200:9: fv= 'sec'
            fv = match( T__136, TOKENS_FOLLOWING_T__136_IN_function_2103 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "sec"
            # <-- action


          when 21
            root_0 = @adaptor.create_flat_list


            # at line 201:9: fv= 'cellSurfaceExpression'
            fv = match( T__83, TOKENS_FOLLOWING_T__83_IN_function_2140 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "surf"
            # <-- action


          when 22
            root_0 = @adaptor.create_flat_list


            # at line 202:9: fv= 'surf'
            fv = match( T__140, TOKENS_FOLLOWING_T__140_IN_function_2159 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "surf"
            # <-- action


          when 23
            root_0 = @adaptor.create_flat_list


            # at line 203:9: fv= 'reaction'
            fv = match( T__131, TOKENS_FOLLOWING_T__131_IN_function_2195 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "rxn"
            # <-- action


          when 24
            root_0 = @adaptor.create_flat_list


            # at line 204:9: fv= 'rxn'
            fv = match( T__135, TOKENS_FOLLOWING_T__135_IN_function_2227 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "rxn"
            # <-- action


          when 25
            root_0 = @adaptor.create_flat_list


            # at line 205:9: fv= 'compositeAbundance'
            fv = match( T__89, TOKENS_FOLLOWING_T__89_IN_function_2264 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "composite"
            # <-- action


          when 26
            root_0 = @adaptor.create_flat_list


            # at line 206:9: fv= 'composite'
            fv = match( T__88, TOKENS_FOLLOWING_T__88_IN_function_2286 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "composite"
            # <-- action


          when 27
            root_0 = @adaptor.create_flat_list


            # at line 207:9: fv= 'fusion'
            fv = match( T__96, TOKENS_FOLLOWING_T__96_IN_function_2317 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "fus"
            # <-- action


          when 28
            root_0 = @adaptor.create_flat_list


            # at line 208:9: fv= 'fus'
            fv = match( T__95, TOKENS_FOLLOWING_T__95_IN_function_2351 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "fus"
            # <-- action


          when 29
            root_0 = @adaptor.create_flat_list


            # at line 209:9: fv= 'degradation'
            fv = match( T__92, TOKENS_FOLLOWING_T__92_IN_function_2388 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "deg"
            # <-- action


          when 30
            root_0 = @adaptor.create_flat_list


            # at line 210:9: fv= 'deg'
            fv = match( T__91, TOKENS_FOLLOWING_T__91_IN_function_2417 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "deg"
            # <-- action


          when 31
            root_0 = @adaptor.create_flat_list


            # at line 211:9: fv= 'molecularActivity'
            fv = match( T__112, TOKENS_FOLLOWING_T__112_IN_function_2454 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "act"
            # <-- action


          when 32
            root_0 = @adaptor.create_flat_list


            # at line 212:9: fv= 'act'
            fv = match( T__73, TOKENS_FOLLOWING_T__73_IN_function_2477 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "act"
            # <-- action


          when 33
            root_0 = @adaptor.create_flat_list


            # at line 213:9: fv= 'catalyticActivity'
            fv = match( T__80, TOKENS_FOLLOWING_T__80_IN_function_2514 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "cat"
            # <-- action


          when 34
            root_0 = @adaptor.create_flat_list


            # at line 214:9: fv= 'cat'
            fv = match( T__79, TOKENS_FOLLOWING_T__79_IN_function_2537 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "cat"
            # <-- action


          when 35
            root_0 = @adaptor.create_flat_list


            # at line 215:9: fv= 'kinaseActivity'
            fv = match( T__108, TOKENS_FOLLOWING_T__108_IN_function_2574 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "kin"
            # <-- action


          when 36
            root_0 = @adaptor.create_flat_list


            # at line 216:9: fv= 'kin'
            fv = match( T__107, TOKENS_FOLLOWING_T__107_IN_function_2600 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "kin"
            # <-- action


          when 37
            root_0 = @adaptor.create_flat_list


            # at line 217:9: fv= 'phosphataseActivity'
            fv = match( T__121, TOKENS_FOLLOWING_T__121_IN_function_2637 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "phos"
            # <-- action


          when 38
            root_0 = @adaptor.create_flat_list


            # at line 218:9: fv= 'phos'
            fv = match( T__120, TOKENS_FOLLOWING_T__120_IN_function_2658 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "phos"
            # <-- action


          when 39
            root_0 = @adaptor.create_flat_list


            # at line 219:9: fv= 'peptidaseActivity'
            fv = match( T__119, TOKENS_FOLLOWING_T__119_IN_function_2694 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "pep"
            # <-- action


          when 40
            root_0 = @adaptor.create_flat_list


            # at line 220:9: fv= 'pep'
            fv = match( T__118, TOKENS_FOLLOWING_T__118_IN_function_2717 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "pep"
            # <-- action


          when 41
            root_0 = @adaptor.create_flat_list


            # at line 221:9: fv= 'ribosylationActivity'
            fv = match( T__133, TOKENS_FOLLOWING_T__133_IN_function_2754 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "ribo"
            # <-- action


          when 42
            root_0 = @adaptor.create_flat_list


            # at line 222:9: fv= 'ribo'
            fv = match( T__132, TOKENS_FOLLOWING_T__132_IN_function_2774 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "ribo"
            # <-- action


          when 43
            root_0 = @adaptor.create_flat_list


            # at line 223:9: fv= 'transcriptionalActivity'
            fv = match( T__144, TOKENS_FOLLOWING_T__144_IN_function_2810 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "tscript"
            # <-- action


          when 44
            root_0 = @adaptor.create_flat_list


            # at line 224:9: fv= 'tscript'
            fv = match( T__150, TOKENS_FOLLOWING_T__150_IN_function_2827 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "tscript"
            # <-- action


          when 45
            root_0 = @adaptor.create_flat_list


            # at line 225:9: fv= 'transportActivity'
            fv = match( T__147, TOKENS_FOLLOWING_T__147_IN_function_2860 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "tport"
            # <-- action


          when 46
            root_0 = @adaptor.create_flat_list


            # at line 226:9: fv= 'tport'
            fv = match( T__142, TOKENS_FOLLOWING_T__142_IN_function_2883 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "tport"
            # <-- action


          when 47
            root_0 = @adaptor.create_flat_list


            # at line 227:9: fv= 'gtpBoundActivity'
            fv = match( T__100, TOKENS_FOLLOWING_T__100_IN_function_2918 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "gtp"
            # <-- action


          when 48
            root_0 = @adaptor.create_flat_list


            # at line 228:9: fv= 'gtp'
            fv = match( T__99, TOKENS_FOLLOWING_T__99_IN_function_2942 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "gtp"
            # <-- action


          when 49
            root_0 = @adaptor.create_flat_list


            # at line 229:9: fv= 'chaperoneActivity'
            fv = match( T__85, TOKENS_FOLLOWING_T__85_IN_function_2979 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "chap"
            # <-- action


          when 50
            root_0 = @adaptor.create_flat_list


            # at line 230:9: fv= 'chap'
            fv = match( T__84, TOKENS_FOLLOWING_T__84_IN_function_3002 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "chap"
            # <-- action


          when 51
            root_0 = @adaptor.create_flat_list


            # at line 231:9: fv= 'proteinModification'
            fv = match( T__127, TOKENS_FOLLOWING_T__127_IN_function_3038 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "pmod"
            # <-- action


          when 52
            root_0 = @adaptor.create_flat_list


            # at line 232:9: fv= 'pmod'
            fv = match( T__122, TOKENS_FOLLOWING_T__122_IN_function_3059 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "pmod"
            # <-- action


          when 53
            root_0 = @adaptor.create_flat_list


            # at line 233:9: fv= 'substitution'
            fv = match( T__139, TOKENS_FOLLOWING_T__139_IN_function_3095 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "sub"
            # <-- action


          when 54
            root_0 = @adaptor.create_flat_list


            # at line 234:9: fv= 'sub'
            fv = match( T__137, TOKENS_FOLLOWING_T__137_IN_function_3123 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "sub"
            # <-- action


          when 55
            root_0 = @adaptor.create_flat_list


            # at line 235:9: fv= 'truncation'
            fv = match( T__149, TOKENS_FOLLOWING_T__149_IN_function_3160 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "trunc"
            # <-- action


          when 56
            root_0 = @adaptor.create_flat_list


            # at line 236:9: fv= 'trunc'
            fv = match( T__148, TOKENS_FOLLOWING_T__148_IN_function_3190 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "trunc"
            # <-- action


          when 57
            root_0 = @adaptor.create_flat_list


            # at line 237:9: fv= 'reactants'
            fv = match( T__130, TOKENS_FOLLOWING_T__130_IN_function_3225 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "reactants"
            # <-- action


          when 58
            root_0 = @adaptor.create_flat_list


            # at line 238:9: fv= 'products'
            fv = match( T__124, TOKENS_FOLLOWING_T__124_IN_function_3256 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "products"
            # <-- action


          when 59
            root_0 = @adaptor.create_flat_list


            # at line 239:9: fv= 'list'
            fv = match( T__109, TOKENS_FOLLOWING_T__109_IN_function_3288 )
            tree_for_fv = @adaptor.create_with_payload( fv )
            @adaptor.add_child( root_0, tree_for_fv )



            # --> action
            return_value.r =  "list"
            # <-- action


          end
          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 19 )


          end

          return return_value
        end

        RelationshipReturnValue = define_return_scope :r

        #
        # parser rule relationship
        #
        # (in BELScript_v1.g)
        # 242:1: relationship returns [r] : (rv= 'increases' |rv= '->' |rv= 'decreases' |rv= '-|' |rv= 'directlyIncreases' |rv= '=>' |rv= 'directlyDecreases' |rv= '=|' |rv= 'causesNoChange' |rv= 'positiveCorrelation' |rv= 'negativeCorrelation' |rv= 'translatedTo' |rv= '>>' |rv= 'transcribedTo' |rv= ':>' |rv= 'isA' |rv= 'subProcessOf' |rv= 'rateLimitingStepOf' |rv= 'biomarkerFor' |rv= 'prognosticBiomarkerFor' |rv= 'orthologous' |rv= 'analogous' |rv= 'association' |rv= '--' |rv= 'hasMembers' |rv= 'hasComponents' |rv= 'hasMember' |rv= 'hasComponent' );
        #
        def relationship
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 20 )


          return_value = RelationshipReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          rv = nil


          tree_for_rv = nil

          begin
          # at line 243:5: (rv= 'increases' |rv= '->' |rv= 'decreases' |rv= '-|' |rv= 'directlyIncreases' |rv= '=>' |rv= 'directlyDecreases' |rv= '=|' |rv= 'causesNoChange' |rv= 'positiveCorrelation' |rv= 'negativeCorrelation' |rv= 'translatedTo' |rv= '>>' |rv= 'transcribedTo' |rv= ':>' |rv= 'isA' |rv= 'subProcessOf' |rv= 'rateLimitingStepOf' |rv= 'biomarkerFor' |rv= 'prognosticBiomarkerFor' |rv= 'orthologous' |rv= 'analogous' |rv= 'association' |rv= '--' |rv= 'hasMembers' |rv= 'hasComponents' |rv= 'hasMember' |rv= 'hasComponent' )
          alt_25 = 28
          case look_25 = @input.peek( 1 )
          when T__105 then alt_25 = 1
          when T__65 then alt_25 = 2
          when T__90 then alt_25 = 3
          when T__66 then alt_25 = 4
          when T__94 then alt_25 = 5
          when T__68 then alt_25 = 6
          when T__93 then alt_25 = 7
          when T__69 then alt_25 = 8
          when T__81 then alt_25 = 9
          when T__123 then alt_25 = 10
          when T__113 then alt_25 = 11
          when T__145 then alt_25 = 12
          when T__70 then alt_25 = 13
          when T__143 then alt_25 = 14
          when T__67 then alt_25 = 15
          when T__106 then alt_25 = 16
          when T__138 then alt_25 = 17
          when T__129 then alt_25 = 18
          when T__77 then alt_25 = 19
          when T__125 then alt_25 = 20
          when T__114 then alt_25 = 21
          when T__74 then alt_25 = 22
          when T__75 then alt_25 = 23
          when T__64 then alt_25 = 24
          when T__104 then alt_25 = 25
          when T__102 then alt_25 = 26
          when T__103 then alt_25 = 27
          when T__101 then alt_25 = 28
          else
            raise NoViableAlternative( "", 25, 0 )

          end
          case alt_25
          when 1
            root_0 = @adaptor.create_flat_list


            # at line 243:9: rv= 'increases'
            rv = match( T__105, TOKENS_FOLLOWING_T__105_IN_relationship_3337 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "increases"
            # <-- action


          when 2
            root_0 = @adaptor.create_flat_list


            # at line 244:9: rv= '->'
            rv = match( T__65, TOKENS_FOLLOWING_T__65_IN_relationship_3368 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "increases"
            # <-- action


          when 3
            root_0 = @adaptor.create_flat_list


            # at line 245:9: rv= 'decreases'
            rv = match( T__90, TOKENS_FOLLOWING_T__90_IN_relationship_3406 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "decreases"
            # <-- action


          when 4
            root_0 = @adaptor.create_flat_list


            # at line 246:9: rv= '-|'
            rv = match( T__66, TOKENS_FOLLOWING_T__66_IN_relationship_3437 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "decreases"
            # <-- action


          when 5
            root_0 = @adaptor.create_flat_list


            # at line 247:9: rv= 'directlyIncreases'
            rv = match( T__94, TOKENS_FOLLOWING_T__94_IN_relationship_3475 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "directlyIncreases"
            # <-- action


          when 6
            root_0 = @adaptor.create_flat_list


            # at line 248:9: rv= '=>'
            rv = match( T__68, TOKENS_FOLLOWING_T__68_IN_relationship_3498 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "directlyIncreases"
            # <-- action


          when 7
            root_0 = @adaptor.create_flat_list


            # at line 249:9: rv= 'directlyDecreases'
            rv = match( T__93, TOKENS_FOLLOWING_T__93_IN_relationship_3536 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "directlyDecreases"
            # <-- action


          when 8
            root_0 = @adaptor.create_flat_list


            # at line 250:9: rv= '=|'
            rv = match( T__69, TOKENS_FOLLOWING_T__69_IN_relationship_3559 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "directlyDecreases"
            # <-- action


          when 9
            root_0 = @adaptor.create_flat_list


            # at line 251:9: rv= 'causesNoChange'
            rv = match( T__81, TOKENS_FOLLOWING_T__81_IN_relationship_3597 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "causesNoChange"
            # <-- action


          when 10
            root_0 = @adaptor.create_flat_list


            # at line 252:9: rv= 'positiveCorrelation'
            rv = match( T__123, TOKENS_FOLLOWING_T__123_IN_relationship_3623 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "positiveCorrelation"
            # <-- action


          when 11
            root_0 = @adaptor.create_flat_list


            # at line 253:9: rv= 'negativeCorrelation'
            rv = match( T__113, TOKENS_FOLLOWING_T__113_IN_relationship_3644 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "negativeCorrelation"
            # <-- action


          when 12
            root_0 = @adaptor.create_flat_list


            # at line 254:9: rv= 'translatedTo'
            rv = match( T__145, TOKENS_FOLLOWING_T__145_IN_relationship_3665 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "translatedTo"
            # <-- action


          when 13
            root_0 = @adaptor.create_flat_list


            # at line 255:9: rv= '>>'
            rv = match( T__70, TOKENS_FOLLOWING_T__70_IN_relationship_3693 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "translatedTo"
            # <-- action


          when 14
            root_0 = @adaptor.create_flat_list


            # at line 256:9: rv= 'transcribedTo'
            rv = match( T__143, TOKENS_FOLLOWING_T__143_IN_relationship_3731 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "transcribedTo"
            # <-- action


          when 15
            root_0 = @adaptor.create_flat_list


            # at line 257:9: rv= ':>'
            rv = match( T__67, TOKENS_FOLLOWING_T__67_IN_relationship_3758 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "transcribedTo"
            # <-- action


          when 16
            root_0 = @adaptor.create_flat_list


            # at line 258:9: rv= 'isA'
            rv = match( T__106, TOKENS_FOLLOWING_T__106_IN_relationship_3796 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "isA"
            # <-- action


          when 17
            root_0 = @adaptor.create_flat_list


            # at line 259:9: rv= 'subProcessOf'
            rv = match( T__138, TOKENS_FOLLOWING_T__138_IN_relationship_3833 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "subProcessOf"
            # <-- action


          when 18
            root_0 = @adaptor.create_flat_list


            # at line 260:9: rv= 'rateLimitingStepOf'
            rv = match( T__129, TOKENS_FOLLOWING_T__129_IN_relationship_3861 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "rateLimitingStepOf"
            # <-- action


          when 19
            root_0 = @adaptor.create_flat_list


            # at line 261:9: rv= 'biomarkerFor'
            rv = match( T__77, TOKENS_FOLLOWING_T__77_IN_relationship_3883 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "biomarkerFor"
            # <-- action


          when 20
            root_0 = @adaptor.create_flat_list


            # at line 262:9: rv= 'prognosticBiomarkerFor'
            rv = match( T__125, TOKENS_FOLLOWING_T__125_IN_relationship_3911 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "prognosticBiomarkerFor"
            # <-- action


          when 21
            root_0 = @adaptor.create_flat_list


            # at line 263:9: rv= 'orthologous'
            rv = match( T__114, TOKENS_FOLLOWING_T__114_IN_relationship_3929 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "orthologous"
            # <-- action


          when 22
            root_0 = @adaptor.create_flat_list


            # at line 264:9: rv= 'analogous'
            rv = match( T__74, TOKENS_FOLLOWING_T__74_IN_relationship_3958 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "analogous"
            # <-- action


          when 23
            root_0 = @adaptor.create_flat_list


            # at line 265:9: rv= 'association'
            rv = match( T__75, TOKENS_FOLLOWING_T__75_IN_relationship_3989 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "association"
            # <-- action


          when 24
            root_0 = @adaptor.create_flat_list


            # at line 266:9: rv= '--'
            rv = match( T__64, TOKENS_FOLLOWING_T__64_IN_relationship_4018 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "association"
            # <-- action


          when 25
            root_0 = @adaptor.create_flat_list


            # at line 267:9: rv= 'hasMembers'
            rv = match( T__104, TOKENS_FOLLOWING_T__104_IN_relationship_4056 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "hasMembers"
            # <-- action


          when 26
            root_0 = @adaptor.create_flat_list


            # at line 268:9: rv= 'hasComponents'
            rv = match( T__102, TOKENS_FOLLOWING_T__102_IN_relationship_4086 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "hasComponents"
            # <-- action


          when 27
            root_0 = @adaptor.create_flat_list


            # at line 269:9: rv= 'hasMember'
            rv = match( T__103, TOKENS_FOLLOWING_T__103_IN_relationship_4113 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "hasMember"
            # <-- action


          when 28
            root_0 = @adaptor.create_flat_list


            # at line 270:9: rv= 'hasComponent'
            rv = match( T__101, TOKENS_FOLLOWING_T__101_IN_relationship_4144 )
            tree_for_rv = @adaptor.create_with_payload( rv )
            @adaptor.add_child( root_0, tree_for_rv )



            # --> action
             return_value.r =  "hasComponent"
            # <-- action


          end
          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 20 )


          end

          return return_value
        end

        EqClauseReturnValue = define_return_scope

        #
        # parser rule eq_clause
        #
        # (in BELScript_v1.g)
        # 273:1: eq_clause : ( WS )* EQ ( WS )* ;
        #
        def eq_clause
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 21 )


          return_value = EqClauseReturnValue.new

          # $rule.start = the first token seen before matching
          return_value.start = @input.look


          root_0 = nil

          __WS92__ = nil
          __EQ93__ = nil
          __WS94__ = nil


          tree_for_WS92 = nil
          tree_for_EQ93 = nil
          tree_for_WS94 = nil

          begin
          root_0 = @adaptor.create_flat_list


          # at line 274:9: ( WS )* EQ ( WS )*
          # at line 274:9: ( WS )*
          while true # decision 26
            alt_26 = 2
            look_26_0 = @input.peek( 1 )

            if ( look_26_0 == WS )
              alt_26 = 1

            end
            case alt_26
            when 1
              # at line 274:9: WS
              __WS92__ = match( WS, TOKENS_FOLLOWING_WS_IN_eq_clause_4179 )
              tree_for_WS92 = @adaptor.create_with_payload( __WS92__ )
              @adaptor.add_child( root_0, tree_for_WS92 )



            else
              break # out of loop for decision 26
            end
          end # loop for decision 26

          __EQ93__ = match( EQ, TOKENS_FOLLOWING_EQ_IN_eq_clause_4182 )
          tree_for_EQ93 = @adaptor.create_with_payload( __EQ93__ )
          @adaptor.add_child( root_0, tree_for_EQ93 )


          # at line 274:16: ( WS )*
          while true # decision 27
            alt_27 = 2
            look_27_0 = @input.peek( 1 )

            if ( look_27_0 == WS )
              alt_27 = 1

            end
            case alt_27
            when 1
              # at line 274:16: WS
              __WS94__ = match( WS, TOKENS_FOLLOWING_WS_IN_eq_clause_4184 )
              tree_for_WS94 = @adaptor.create_with_payload( __WS94__ )
              @adaptor.add_child( root_0, tree_for_WS94 )



            else
              break # out of loop for decision 27
            end
          end # loop for decision 27


          # - - - - - - - rule clean up - - - - - - - -
          return_value.stop = @input.look( -1 )


          return_value.tree = @adaptor.rule_post_processing( root_0 )
          @adaptor.set_token_boundaries( return_value.tree, return_value.start, return_value.stop )


          rescue ANTLR3::Error::RecognitionError => re
            report_error(re)
            recover(re)
            return_value.tree = @adaptor.create_error_node( @input, return_value.start, @input.look(-1), re )


          ensure
            # -> uncomment the next line to manually enable rule tracing
            # trace_out( __method__, 21 )


          end

          return return_value
        end



        # - - - - - - - - - - DFA definitions - - - - - - - - - - -
        class DFA2 < ANTLR3::DFA
          EOT = unpack( 13, -1 )
          EOF = unpack( 13, -1 )
          MIN = unpack( 1, 28, 1, 23, 1, 32, 1, 22, 4, -1, 1, 32, 4, -1 )
          MAX = unpack( 1, 150, 2, 63, 1, 47, 4, -1, 1, 63, 4, -1 )
          ACCEPT = unpack( 4, -1, 1, 8, 1, 1, 1, 2, 1, 3, 1, -1, 1, 4, 1, 5, 
                           1, 6, 1, 7 )
          SPECIAL = unpack( 13, -1 )
          TRANSITION = [
            unpack( 1, 1, 9, -1, 1, 2, 1, -1, 1, 3, 30, -1, 3, 4, 2, -1, 1, 
                    4, 1, -1, 3, 4, 1, -1, 8, 4, 1, -1, 2, 4, 2, -1, 6, 4, 6, 
                    -1, 6, 4, 2, -1, 8, 4, 1, -1, 1, 4, 1, -1, 3, 4, 1, -1, 
                    8, 4, 1, -1, 4, 4, 1, -1, 1, 4, 1, -1, 5, 4 ),
            unpack( 1, 6, 6, -1, 1, 5, 5, -1, 1, 5, 26, -1, 1, 6 ),
            unpack( 1, 9, 6, -1, 1, 10, 7, -1, 1, 7, 15, -1, 1, 8 ),
            unpack( 1, 12, 16, -1, 1, 11, 7, -1, 1, 12 ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 9, 6, -1, 1, 10, 23, -1, 1, 8 ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack(  )
          ].freeze

          ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
            if a > 0 and z < 0
              MAX[ i ] %= 0x10000
            end
          end

          @decision = 2


          def description
            <<-'__dfa_description__'.strip!
              72:1: record : ( define_namespace | define_annotation | set_annotation | set_document | set_statement_group | unset_statement_group | unset | statement );
            __dfa_description__
          end

        end
        class DFA5 < ANTLR3::DFA
          EOT = unpack( 12, -1 )
          EOF = unpack( 12, -1 )
          MIN = unpack( 1, 38, 2, 32, 2, 25, 2, 19, 2, 47, 3, -1 )
          MAX = unpack( 1, 38, 8, 63, 3, -1 )
          ACCEPT = unpack( 9, -1, 1, 1, 1, 2, 1, 3 )
          SPECIAL = unpack( 12, -1 )
          TRANSITION = [
            unpack( 1, 1 ),
            unpack( 1, 3, 30, -1, 1, 2 ),
            unpack( 1, 3, 30, -1, 1, 2 ),
            unpack( 3, 5, 1, -1, 1, 5, 1, -1, 1, 5, 1, -1, 1, 5, 1, -1, 1, 
                     5, 6, -1, 1, 5, 20, -1, 1, 4 ),
            unpack( 3, 5, 1, -1, 1, 5, 1, -1, 1, 5, 1, -1, 1, 5, 1, -1, 1, 
                     5, 6, -1, 1, 5, 20, -1, 1, 4 ),
            unpack( 1, 7, 43, -1, 1, 6 ),
            unpack( 1, 7, 43, -1, 1, 6 ),
            unpack( 1, 11, 3, -1, 1, 9, 10, -1, 1, 10, 1, 8 ),
            unpack( 1, 11, 3, -1, 1, 9, 10, -1, 1, 10, 1, 8 ),
            unpack(  ),
            unpack(  ),
            unpack(  )
          ].freeze

          ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
            if a > 0 and z < 0
              MAX[ i ] %= 0x10000
            end
          end

          @decision = 5


          def description
            <<-'__dfa_description__'.strip!
              87:1: set_document : ( set_doc_expr document_property eq_clause val= QUOTED_VALUE -> ^( DOCSET_QV document_property $val) | set_doc_expr document_property eq_clause val= VALUE_LIST -> ^( DOCSET_LIST document_property $val) | set_doc_expr document_property eq_clause val= OBJECT_IDENT -> ^( DOCSET_ID document_property $val) );
            __dfa_description__
          end

        end
        class DFA7 < ANTLR3::DFA
          EOT = unpack( 9, -1 )
          EOF = unpack( 9, -1 )
          MIN = unpack( 1, 38, 2, 39, 2, 19, 2, 47, 2, -1 )
          MAX = unpack( 1, 38, 6, 63, 2, -1 )
          ACCEPT = unpack( 7, -1, 1, 1, 1, 2 )
          SPECIAL = unpack( 9, -1 )
          TRANSITION = [
            unpack( 1, 1 ),
            unpack( 1, 3, 23, -1, 1, 2 ),
            unpack( 1, 3, 23, -1, 1, 2 ),
            unpack( 1, 5, 43, -1, 1, 4 ),
            unpack( 1, 5, 43, -1, 1, 4 ),
            unpack( 1, 8, 3, -1, 1, 7, 11, -1, 1, 6 ),
            unpack( 1, 8, 3, -1, 1, 7, 11, -1, 1, 6 ),
            unpack(  ),
            unpack(  )
          ].freeze

          ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
            if a > 0 and z < 0
              MAX[ i ] %= 0x10000
            end
          end

          @decision = 7


          def description
            <<-'__dfa_description__'.strip!
              100:1: set_statement_group : ( set_sg_expr eq_clause val= QUOTED_VALUE -> ^( SG_SET_QV $val) | set_sg_expr eq_clause val= OBJECT_IDENT -> ^( SG_SET_ID $val) );
            __dfa_description__
          end

        end
        class DFA8 < ANTLR3::DFA
          EOT = unpack( 9, -1 )
          EOF = unpack( 9, -1 )
          MIN = unpack( 1, 38, 1, 47, 2, 19, 2, 47, 3, -1 )
          MAX = unpack( 1, 38, 1, 47, 4, 63, 3, -1 )
          ACCEPT = unpack( 6, -1, 1, 1, 1, 2, 1, 3 )
          SPECIAL = unpack( 9, -1 )
          TRANSITION = [
            unpack( 1, 1 ),
            unpack( 1, 2 ),
            unpack( 1, 4, 43, -1, 1, 3 ),
            unpack( 1, 4, 43, -1, 1, 3 ),
            unpack( 1, 8, 3, -1, 1, 6, 10, -1, 1, 7, 1, 5 ),
            unpack( 1, 8, 3, -1, 1, 6, 10, -1, 1, 7, 1, 5 ),
            unpack(  ),
            unpack(  ),
            unpack(  )
          ].freeze

          ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
            if a > 0 and z < 0
              MAX[ i ] %= 0x10000
            end
          end

          @decision = 8


          def description
            <<-'__dfa_description__'.strip!
              105:1: set_annotation : ( KWRD_SET OBJECT_IDENT eq_clause val= QUOTED_VALUE -> ^( ANNO_SET_QV OBJECT_IDENT $val) | KWRD_SET OBJECT_IDENT eq_clause val= VALUE_LIST -> ^( ANNO_SET_LIST OBJECT_IDENT $val) | KWRD_SET OBJECT_IDENT eq_clause val= OBJECT_IDENT -> ^( ANNO_SET_ID OBJECT_IDENT $val) );
            __dfa_description__
          end

        end
        class DFA13 < ANTLR3::DFA
          EOT = unpack( 10, -1 )
          EOF = unpack( 10, -1 )
          MIN = unpack( 1, 28, 2, 23, 2, 47, 1, 24, 1, 34, 3, -1 )
          MAX = unpack( 1, 28, 4, 63, 1, 24, 1, 41, 3, -1 )
          ACCEPT = unpack( 7, -1, 1, 1, 1, 2, 1, 3 )
          SPECIAL = unpack( 10, -1 )
          TRANSITION = [
            unpack( 1, 1 ),
            unpack( 1, 3, 39, -1, 1, 2 ),
            unpack( 1, 3, 39, -1, 1, 2 ),
            unpack( 1, 5, 15, -1, 1, 4 ),
            unpack( 1, 5, 15, -1, 1, 4 ),
            unpack( 1, 6 ),
            unpack( 1, 7, 2, -1, 1, 9, 3, -1, 1, 8 ),
            unpack(  ),
            unpack(  ),
            unpack(  )
          ].freeze

          ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
            if a > 0 and z < 0
              MAX[ i ] %= 0x10000
            end
          end

          @decision = 13


          def description
            <<-'__dfa_description__'.strip!
              134:1: define_annotation : ( define_anno_expr OBJECT_IDENT KWRD_AS KWRD_LIST val= VALUE_LIST -> ^( ANNO_DEF_LIST OBJECT_IDENT $val) | define_anno_expr OBJECT_IDENT KWRD_AS KWRD_URL val= QUOTED_VALUE -> ^( ANNO_DEF_URL OBJECT_IDENT $val) | define_anno_expr OBJECT_IDENT KWRD_AS KWRD_PATTERN val= QUOTED_VALUE -> ^( ANNO_DEF_PTRN OBJECT_IDENT $val) );
            __dfa_description__
          end

        end


        private

        def initialize_dfas
          super rescue nil
          @dfa2 = DFA2.new( self, 2 )


          @dfa5 = DFA5.new( self, 5 )


          @dfa7 = DFA7.new( self, 7 )


          @dfa8 = DFA8.new( self, 8 )


          @dfa13 = DFA13.new( self, 13 )


        end

        TOKENS_FOLLOWING_NEWLINE_IN_document_327 = Set[ 18, 28, 38, 40, 45, 71, 72, 73, 76, 78, 79, 80, 82, 83, 84, 85, 86, 87, 88, 89, 91, 92, 95, 96, 97, 98, 99, 100, 107, 108, 109, 110, 111, 112, 115, 116, 117, 118, 119, 120, 121, 122, 124, 126, 127, 128, 130, 131, 132, 133, 134, 135, 136, 137, 139, 140, 141, 142, 144, 146, 147, 148, 149, 150 ]
        TOKENS_FOLLOWING_DOCUMENT_COMMENT_IN_document_331 = Set[ 18, 28, 38, 40, 45, 71, 72, 73, 76, 78, 79, 80, 82, 83, 84, 85, 86, 87, 88, 89, 91, 92, 95, 96, 97, 98, 99, 100, 107, 108, 109, 110, 111, 112, 115, 116, 117, 118, 119, 120, 121, 122, 124, 126, 127, 128, 130, 131, 132, 133, 134, 135, 136, 137, 139, 140, 141, 142, 144, 146, 147, 148, 149, 150 ]
        TOKENS_FOLLOWING_record_IN_document_335 = Set[ 18, 28, 38, 40, 45, 71, 72, 73, 76, 78, 79, 80, 82, 83, 84, 85, 86, 87, 88, 89, 91, 92, 95, 96, 97, 98, 99, 100, 107, 108, 109, 110, 111, 112, 115, 116, 117, 118, 119, 120, 121, 122, 124, 126, 127, 128, 130, 131, 132, 133, 134, 135, 136, 137, 139, 140, 141, 142, 144, 146, 147, 148, 149, 150 ]
        TOKENS_FOLLOWING_EOF_IN_document_339 = Set[ 1 ]
        TOKENS_FOLLOWING_define_namespace_IN_record_375 = Set[ 1 ]
        TOKENS_FOLLOWING_define_annotation_IN_record_385 = Set[ 1 ]
        TOKENS_FOLLOWING_set_annotation_IN_record_395 = Set[ 1 ]
        TOKENS_FOLLOWING_set_document_IN_record_405 = Set[ 1 ]
        TOKENS_FOLLOWING_set_statement_group_IN_record_415 = Set[ 1 ]
        TOKENS_FOLLOWING_unset_statement_group_IN_record_425 = Set[ 1 ]
        TOKENS_FOLLOWING_unset_IN_record_435 = Set[ 1 ]
        TOKENS_FOLLOWING_statement_IN_record_445 = Set[ 1 ]
        TOKENS_FOLLOWING_KWRD_SET_IN_set_doc_expr_464 = Set[ 32, 63 ]
        TOKENS_FOLLOWING_WS_IN_set_doc_expr_466 = Set[ 32, 63 ]
        TOKENS_FOLLOWING_KWRD_DOCUMENT_IN_set_doc_expr_469 = Set[ 1, 63 ]
        TOKENS_FOLLOWING_WS_IN_set_doc_expr_471 = Set[ 1, 63 ]
        TOKENS_FOLLOWING_set_doc_expr_IN_set_document_491 = Set[ 25, 26, 27, 29, 31, 33, 35, 42 ]
        TOKENS_FOLLOWING_document_property_IN_set_document_493 = Set[ 19, 63 ]
        TOKENS_FOLLOWING_eq_clause_IN_set_document_495 = Set[ 51 ]
        TOKENS_FOLLOWING_QUOTED_VALUE_IN_set_document_499 = Set[ 1 ]
        TOKENS_FOLLOWING_set_doc_expr_IN_set_document_528 = Set[ 25, 26, 27, 29, 31, 33, 35, 42 ]
        TOKENS_FOLLOWING_document_property_IN_set_document_530 = Set[ 19, 63 ]
        TOKENS_FOLLOWING_eq_clause_IN_set_document_532 = Set[ 62 ]
        TOKENS_FOLLOWING_VALUE_LIST_IN_set_document_536 = Set[ 1 ]
        TOKENS_FOLLOWING_set_doc_expr_IN_set_document_565 = Set[ 25, 26, 27, 29, 31, 33, 35, 42 ]
        TOKENS_FOLLOWING_document_property_IN_set_document_567 = Set[ 19, 63 ]
        TOKENS_FOLLOWING_eq_clause_IN_set_document_569 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_document_573 = Set[ 1 ]
        TOKENS_FOLLOWING_KWRD_SET_IN_set_sg_expr_611 = Set[ 39, 63 ]
        TOKENS_FOLLOWING_WS_IN_set_sg_expr_613 = Set[ 39, 63 ]
        TOKENS_FOLLOWING_KWRD_STMT_GROUP_IN_set_sg_expr_616 = Set[ 1 ]
        TOKENS_FOLLOWING_set_sg_expr_IN_set_statement_group_635 = Set[ 19, 63 ]
        TOKENS_FOLLOWING_eq_clause_IN_set_statement_group_637 = Set[ 51 ]
        TOKENS_FOLLOWING_QUOTED_VALUE_IN_set_statement_group_641 = Set[ 1 ]
        TOKENS_FOLLOWING_set_sg_expr_IN_set_statement_group_660 = Set[ 19, 63 ]
        TOKENS_FOLLOWING_eq_clause_IN_set_statement_group_662 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_statement_group_666 = Set[ 1 ]
        TOKENS_FOLLOWING_KWRD_SET_IN_set_annotation_694 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_annotation_696 = Set[ 19, 63 ]
        TOKENS_FOLLOWING_eq_clause_IN_set_annotation_698 = Set[ 51 ]
        TOKENS_FOLLOWING_QUOTED_VALUE_IN_set_annotation_702 = Set[ 1 ]
        TOKENS_FOLLOWING_KWRD_SET_IN_set_annotation_731 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_annotation_733 = Set[ 19, 63 ]
        TOKENS_FOLLOWING_eq_clause_IN_set_annotation_735 = Set[ 62 ]
        TOKENS_FOLLOWING_VALUE_LIST_IN_set_annotation_739 = Set[ 1 ]
        TOKENS_FOLLOWING_KWRD_SET_IN_set_annotation_768 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_annotation_770 = Set[ 19, 63 ]
        TOKENS_FOLLOWING_eq_clause_IN_set_annotation_772 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_set_annotation_776 = Set[ 1 ]
        TOKENS_FOLLOWING_KWRD_UNSET_IN_unset_statement_group_814 = Set[ 39 ]
        TOKENS_FOLLOWING_KWRD_STMT_GROUP_IN_unset_statement_group_816 = Set[ 1 ]
        TOKENS_FOLLOWING_KWRD_UNSET_IN_unset_841 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_unset_845 = Set[ 1 ]
        TOKENS_FOLLOWING_KWRD_UNSET_IN_unset_864 = Set[ 22 ]
        TOKENS_FOLLOWING_IDENT_LIST_IN_unset_868 = Set[ 1 ]
        TOKENS_FOLLOWING_KWRD_DEFINE_IN_define_namespace_896 = Set[ 30 ]
        TOKENS_FOLLOWING_KWRD_DFLT_IN_define_namespace_898 = Set[ 36 ]
        TOKENS_FOLLOWING_KWRD_NS_IN_define_namespace_900 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_define_namespace_902 = Set[ 24 ]
        TOKENS_FOLLOWING_KWRD_AS_IN_define_namespace_904 = Set[ 41 ]
        TOKENS_FOLLOWING_KWRD_URL_IN_define_namespace_906 = Set[ 51 ]
        TOKENS_FOLLOWING_QUOTED_VALUE_IN_define_namespace_908 = Set[ 1 ]
        TOKENS_FOLLOWING_KWRD_DEFINE_IN_define_namespace_936 = Set[ 36 ]
        TOKENS_FOLLOWING_KWRD_NS_IN_define_namespace_938 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_define_namespace_940 = Set[ 24 ]
        TOKENS_FOLLOWING_KWRD_AS_IN_define_namespace_942 = Set[ 41 ]
        TOKENS_FOLLOWING_KWRD_URL_IN_define_namespace_944 = Set[ 51 ]
        TOKENS_FOLLOWING_QUOTED_VALUE_IN_define_namespace_946 = Set[ 1 ]
        TOKENS_FOLLOWING_KWRD_DEFINE_IN_define_anno_expr_983 = Set[ 23, 63 ]
        TOKENS_FOLLOWING_WS_IN_define_anno_expr_985 = Set[ 23, 63 ]
        TOKENS_FOLLOWING_KWRD_ANNO_IN_define_anno_expr_988 = Set[ 1, 63 ]
        TOKENS_FOLLOWING_WS_IN_define_anno_expr_990 = Set[ 1, 63 ]
        TOKENS_FOLLOWING_define_anno_expr_IN_define_annotation_1010 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_define_annotation_1012 = Set[ 24 ]
        TOKENS_FOLLOWING_KWRD_AS_IN_define_annotation_1014 = Set[ 34 ]
        TOKENS_FOLLOWING_KWRD_LIST_IN_define_annotation_1016 = Set[ 62 ]
        TOKENS_FOLLOWING_VALUE_LIST_IN_define_annotation_1020 = Set[ 1 ]
        TOKENS_FOLLOWING_define_anno_expr_IN_define_annotation_1049 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_define_annotation_1051 = Set[ 24 ]
        TOKENS_FOLLOWING_KWRD_AS_IN_define_annotation_1053 = Set[ 41 ]
        TOKENS_FOLLOWING_KWRD_URL_IN_define_annotation_1055 = Set[ 51 ]
        TOKENS_FOLLOWING_QUOTED_VALUE_IN_define_annotation_1059 = Set[ 1 ]
        TOKENS_FOLLOWING_define_anno_expr_IN_define_annotation_1088 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_define_annotation_1090 = Set[ 24 ]
        TOKENS_FOLLOWING_KWRD_AS_IN_define_annotation_1092 = Set[ 37 ]
        TOKENS_FOLLOWING_KWRD_PATTERN_IN_define_annotation_1094 = Set[ 51 ]
        TOKENS_FOLLOWING_QUOTED_VALUE_IN_define_annotation_1098 = Set[ 1 ]
        TOKENS_FOLLOWING_COMMA_IN_argument_1225 = Set[ 71, 72, 73, 76, 78, 79, 80, 82, 83, 84, 85, 86, 87, 88, 89, 91, 92, 95, 96, 97, 98, 99, 100, 107, 108, 109, 110, 111, 112, 115, 116, 117, 118, 119, 120, 121, 122, 124, 126, 127, 128, 130, 131, 132, 133, 134, 135, 136, 137, 139, 140, 141, 142, 144, 146, 147, 148, 149, 150 ]
        TOKENS_FOLLOWING_term_IN_argument_1228 = Set[ 1 ]
        TOKENS_FOLLOWING_COMMA_IN_argument_1242 = Set[ 47, 51 ]
        TOKENS_FOLLOWING_param_IN_argument_1245 = Set[ 1 ]
        TOKENS_FOLLOWING_function_IN_term_1268 = Set[ 44 ]
        TOKENS_FOLLOWING_LP_IN_term_1270 = Set[ 11, 47, 51, 52, 71, 72, 73, 76, 78, 79, 80, 82, 83, 84, 85, 86, 87, 88, 89, 91, 92, 95, 96, 97, 98, 99, 100, 107, 108, 109, 110, 111, 112, 115, 116, 117, 118, 119, 120, 121, 122, 124, 126, 127, 128, 130, 131, 132, 133, 134, 135, 136, 137, 139, 140, 141, 142, 144, 146, 147, 148, 149, 150 ]
        TOKENS_FOLLOWING_argument_IN_term_1273 = Set[ 11, 47, 51, 52, 71, 72, 73, 76, 78, 79, 80, 82, 83, 84, 85, 86, 87, 88, 89, 91, 92, 95, 96, 97, 98, 99, 100, 107, 108, 109, 110, 111, 112, 115, 116, 117, 118, 119, 120, 121, 122, 124, 126, 127, 128, 130, 131, 132, 133, 134, 135, 136, 137, 139, 140, 141, 142, 144, 146, 147, 148, 149, 150 ]
        TOKENS_FOLLOWING_RP_IN_term_1277 = Set[ 1 ]
        TOKENS_FOLLOWING_term_IN_statement_1319 = Set[ 1, 55, 64, 65, 66, 67, 68, 69, 70, 74, 75, 77, 81, 90, 93, 94, 101, 102, 103, 104, 105, 106, 113, 114, 123, 125, 129, 138, 143, 145 ]
        TOKENS_FOLLOWING_relationship_IN_statement_1324 = Set[ 44, 71, 72, 73, 76, 78, 79, 80, 82, 83, 84, 85, 86, 87, 88, 89, 91, 92, 95, 96, 97, 98, 99, 100, 107, 108, 109, 110, 111, 112, 115, 116, 117, 118, 119, 120, 121, 122, 124, 126, 127, 128, 130, 131, 132, 133, 134, 135, 136, 137, 139, 140, 141, 142, 144, 146, 147, 148, 149, 150 ]
        TOKENS_FOLLOWING_LP_IN_statement_1327 = Set[ 71, 72, 73, 76, 78, 79, 80, 82, 83, 84, 85, 86, 87, 88, 89, 91, 92, 95, 96, 97, 98, 99, 100, 107, 108, 109, 110, 111, 112, 115, 116, 117, 118, 119, 120, 121, 122, 124, 126, 127, 128, 130, 131, 132, 133, 134, 135, 136, 137, 139, 140, 141, 142, 144, 146, 147, 148, 149, 150 ]
        TOKENS_FOLLOWING_term_IN_statement_1331 = Set[ 64, 65, 66, 67, 68, 69, 70, 74, 75, 77, 81, 90, 93, 94, 101, 102, 103, 104, 105, 106, 113, 114, 123, 125, 129, 138, 143, 145 ]
        TOKENS_FOLLOWING_relationship_IN_statement_1335 = Set[ 71, 72, 73, 76, 78, 79, 80, 82, 83, 84, 85, 86, 87, 88, 89, 91, 92, 95, 96, 97, 98, 99, 100, 107, 108, 109, 110, 111, 112, 115, 116, 117, 118, 119, 120, 121, 122, 124, 126, 127, 128, 130, 131, 132, 133, 134, 135, 136, 137, 139, 140, 141, 142, 144, 146, 147, 148, 149, 150 ]
        TOKENS_FOLLOWING_term_IN_statement_1339 = Set[ 52 ]
        TOKENS_FOLLOWING_RP_IN_statement_1341 = Set[ 1, 55 ]
        TOKENS_FOLLOWING_term_IN_statement_1347 = Set[ 1, 55 ]
        TOKENS_FOLLOWING_STATEMENT_COMMENT_IN_statement_1354 = Set[ 1 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_ns_prefix_1415 = Set[ 10 ]
        TOKENS_FOLLOWING_COLON_IN_ns_prefix_1417 = Set[ 1 ]
        TOKENS_FOLLOWING_ns_prefix_IN_param_1437 = Set[ 47 ]
        TOKENS_FOLLOWING_OBJECT_IDENT_IN_param_1440 = Set[ 1 ]
        TOKENS_FOLLOWING_ns_prefix_IN_param_1461 = Set[ 51 ]
        TOKENS_FOLLOWING_QUOTED_VALUE_IN_param_1464 = Set[ 1 ]
        TOKENS_FOLLOWING_T__126_IN_function_1500 = Set[ 1 ]
        TOKENS_FOLLOWING_T__115_IN_function_1524 = Set[ 1 ]
        TOKENS_FOLLOWING_T__134_IN_function_1563 = Set[ 1 ]
        TOKENS_FOLLOWING_T__128_IN_function_1591 = Set[ 1 ]
        TOKENS_FOLLOWING_T__72_IN_function_1630 = Set[ 1 ]
        TOKENS_FOLLOWING_T__71_IN_function_1661 = Set[ 1 ]
        TOKENS_FOLLOWING_T__111_IN_function_1700 = Set[ 1 ]
        TOKENS_FOLLOWING_T__110_IN_function_1723 = Set[ 1 ]
        TOKENS_FOLLOWING_T__98_IN_function_1762 = Set[ 1 ]
        TOKENS_FOLLOWING_T__97_IN_function_1789 = Set[ 1 ]
        TOKENS_FOLLOWING_T__76_IN_function_1828 = Set[ 1 ]
        TOKENS_FOLLOWING_T__78_IN_function_1851 = Set[ 1 ]
        TOKENS_FOLLOWING_T__117_IN_function_1889 = Set[ 1 ]
        TOKENS_FOLLOWING_T__116_IN_function_1920 = Set[ 1 ]
        TOKENS_FOLLOWING_T__87_IN_function_1956 = Set[ 1 ]
        TOKENS_FOLLOWING_T__86_IN_function_1980 = Set[ 1 ]
        TOKENS_FOLLOWING_T__146_IN_function_2013 = Set[ 1 ]
        TOKENS_FOLLOWING_T__141_IN_function_2040 = Set[ 1 ]
        TOKENS_FOLLOWING_T__82_IN_function_2076 = Set[ 1 ]
        TOKENS_FOLLOWING_T__136_IN_function_2103 = Set[ 1 ]
        TOKENS_FOLLOWING_T__83_IN_function_2140 = Set[ 1 ]
        TOKENS_FOLLOWING_T__140_IN_function_2159 = Set[ 1 ]
        TOKENS_FOLLOWING_T__131_IN_function_2195 = Set[ 1 ]
        TOKENS_FOLLOWING_T__135_IN_function_2227 = Set[ 1 ]
        TOKENS_FOLLOWING_T__89_IN_function_2264 = Set[ 1 ]
        TOKENS_FOLLOWING_T__88_IN_function_2286 = Set[ 1 ]
        TOKENS_FOLLOWING_T__96_IN_function_2317 = Set[ 1 ]
        TOKENS_FOLLOWING_T__95_IN_function_2351 = Set[ 1 ]
        TOKENS_FOLLOWING_T__92_IN_function_2388 = Set[ 1 ]
        TOKENS_FOLLOWING_T__91_IN_function_2417 = Set[ 1 ]
        TOKENS_FOLLOWING_T__112_IN_function_2454 = Set[ 1 ]
        TOKENS_FOLLOWING_T__73_IN_function_2477 = Set[ 1 ]
        TOKENS_FOLLOWING_T__80_IN_function_2514 = Set[ 1 ]
        TOKENS_FOLLOWING_T__79_IN_function_2537 = Set[ 1 ]
        TOKENS_FOLLOWING_T__108_IN_function_2574 = Set[ 1 ]
        TOKENS_FOLLOWING_T__107_IN_function_2600 = Set[ 1 ]
        TOKENS_FOLLOWING_T__121_IN_function_2637 = Set[ 1 ]
        TOKENS_FOLLOWING_T__120_IN_function_2658 = Set[ 1 ]
        TOKENS_FOLLOWING_T__119_IN_function_2694 = Set[ 1 ]
        TOKENS_FOLLOWING_T__118_IN_function_2717 = Set[ 1 ]
        TOKENS_FOLLOWING_T__133_IN_function_2754 = Set[ 1 ]
        TOKENS_FOLLOWING_T__132_IN_function_2774 = Set[ 1 ]
        TOKENS_FOLLOWING_T__144_IN_function_2810 = Set[ 1 ]
        TOKENS_FOLLOWING_T__150_IN_function_2827 = Set[ 1 ]
        TOKENS_FOLLOWING_T__147_IN_function_2860 = Set[ 1 ]
        TOKENS_FOLLOWING_T__142_IN_function_2883 = Set[ 1 ]
        TOKENS_FOLLOWING_T__100_IN_function_2918 = Set[ 1 ]
        TOKENS_FOLLOWING_T__99_IN_function_2942 = Set[ 1 ]
        TOKENS_FOLLOWING_T__85_IN_function_2979 = Set[ 1 ]
        TOKENS_FOLLOWING_T__84_IN_function_3002 = Set[ 1 ]
        TOKENS_FOLLOWING_T__127_IN_function_3038 = Set[ 1 ]
        TOKENS_FOLLOWING_T__122_IN_function_3059 = Set[ 1 ]
        TOKENS_FOLLOWING_T__139_IN_function_3095 = Set[ 1 ]
        TOKENS_FOLLOWING_T__137_IN_function_3123 = Set[ 1 ]
        TOKENS_FOLLOWING_T__149_IN_function_3160 = Set[ 1 ]
        TOKENS_FOLLOWING_T__148_IN_function_3190 = Set[ 1 ]
        TOKENS_FOLLOWING_T__130_IN_function_3225 = Set[ 1 ]
        TOKENS_FOLLOWING_T__124_IN_function_3256 = Set[ 1 ]
        TOKENS_FOLLOWING_T__109_IN_function_3288 = Set[ 1 ]
        TOKENS_FOLLOWING_T__105_IN_relationship_3337 = Set[ 1 ]
        TOKENS_FOLLOWING_T__65_IN_relationship_3368 = Set[ 1 ]
        TOKENS_FOLLOWING_T__90_IN_relationship_3406 = Set[ 1 ]
        TOKENS_FOLLOWING_T__66_IN_relationship_3437 = Set[ 1 ]
        TOKENS_FOLLOWING_T__94_IN_relationship_3475 = Set[ 1 ]
        TOKENS_FOLLOWING_T__68_IN_relationship_3498 = Set[ 1 ]
        TOKENS_FOLLOWING_T__93_IN_relationship_3536 = Set[ 1 ]
        TOKENS_FOLLOWING_T__69_IN_relationship_3559 = Set[ 1 ]
        TOKENS_FOLLOWING_T__81_IN_relationship_3597 = Set[ 1 ]
        TOKENS_FOLLOWING_T__123_IN_relationship_3623 = Set[ 1 ]
        TOKENS_FOLLOWING_T__113_IN_relationship_3644 = Set[ 1 ]
        TOKENS_FOLLOWING_T__145_IN_relationship_3665 = Set[ 1 ]
        TOKENS_FOLLOWING_T__70_IN_relationship_3693 = Set[ 1 ]
        TOKENS_FOLLOWING_T__143_IN_relationship_3731 = Set[ 1 ]
        TOKENS_FOLLOWING_T__67_IN_relationship_3758 = Set[ 1 ]
        TOKENS_FOLLOWING_T__106_IN_relationship_3796 = Set[ 1 ]
        TOKENS_FOLLOWING_T__138_IN_relationship_3833 = Set[ 1 ]
        TOKENS_FOLLOWING_T__129_IN_relationship_3861 = Set[ 1 ]
        TOKENS_FOLLOWING_T__77_IN_relationship_3883 = Set[ 1 ]
        TOKENS_FOLLOWING_T__125_IN_relationship_3911 = Set[ 1 ]
        TOKENS_FOLLOWING_T__114_IN_relationship_3929 = Set[ 1 ]
        TOKENS_FOLLOWING_T__74_IN_relationship_3958 = Set[ 1 ]
        TOKENS_FOLLOWING_T__75_IN_relationship_3989 = Set[ 1 ]
        TOKENS_FOLLOWING_T__64_IN_relationship_4018 = Set[ 1 ]
        TOKENS_FOLLOWING_T__104_IN_relationship_4056 = Set[ 1 ]
        TOKENS_FOLLOWING_T__102_IN_relationship_4086 = Set[ 1 ]
        TOKENS_FOLLOWING_T__103_IN_relationship_4113 = Set[ 1 ]
        TOKENS_FOLLOWING_T__101_IN_relationship_4144 = Set[ 1 ]
        TOKENS_FOLLOWING_WS_IN_eq_clause_4179 = Set[ 19, 63 ]
        TOKENS_FOLLOWING_EQ_IN_eq_clause_4182 = Set[ 1, 63 ]
        TOKENS_FOLLOWING_WS_IN_eq_clause_4184 = Set[ 1, 63 ]

      end # class Parser < ANTLR3::Parser

      at_exit { Parser.main( ARGV ) } if __FILE__ == $0

    end
  end
end
