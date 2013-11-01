#!/usr/bin/env ruby
# vim: ts=2 sw=2:
#
# BELScript_v1.g
# --
# Generated using ANTLR version: 3.5
# Ruby runtime library version: 1.10.0
# Input grammar file: BELScript_v1.g
# Generated at: 2013-10-31 08:40:25
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

      end


      class Lexer < ANTLR3::Lexer
        @grammar_home = BEL::Script::Parser
        include TokenData

        begin
          generated_using( "BELScript_v1.g", "3.5", "1.10.0" )
        rescue NoMethodError => error
          # ignore
        end

        RULE_NAMES   = [ "T__64", "T__65", "T__66", "T__67", "T__68", "T__69", 
                         "T__70", "T__71", "T__72", "T__73", "T__74", "T__75", 
                         "T__76", "T__77", "T__78", "T__79", "T__80", "T__81", 
                         "T__82", "T__83", "T__84", "T__85", "T__86", "T__87", 
                         "T__88", "T__89", "T__90", "T__91", "T__92", "T__93", 
                         "T__94", "T__95", "T__96", "T__97", "T__98", "T__99", 
                         "T__100", "T__101", "T__102", "T__103", "T__104", "T__105", 
                         "T__106", "T__107", "T__108", "T__109", "T__110", "T__111", 
                         "T__112", "T__113", "T__114", "T__115", "T__116", "T__117", 
                         "T__118", "T__119", "T__120", "T__121", "T__122", "T__123", 
                         "T__124", "T__125", "T__126", "T__127", "T__128", "T__129", 
                         "T__130", "T__131", "T__132", "T__133", "T__134", "T__135", 
                         "T__136", "T__137", "T__138", "T__139", "T__140", "T__141", 
                         "T__142", "T__143", "T__144", "T__145", "T__146", "T__147", 
                         "T__148", "T__149", "T__150", "DOCUMENT_COMMENT", "STATEMENT_COMMENT", 
                         "IDENT_LIST", "VALUE_LIST", "QUOTED_VALUE", "LP", "RP", 
                         "EQ", "COLON", "COMMA", "NEWLINE", "WS", "KWRD_ANNO", 
                         "KWRD_AS", "KWRD_AUTHORS", "KWRD_CONTACTINFO", "KWRD_COPYRIGHT", 
                         "KWRD_DFLT", "KWRD_DEFINE", "KWRD_DESC", "KWRD_DISCLAIMER", 
                         "KWRD_DOCUMENT", "KWRD_LICENSES", "KWRD_LIST", "KWRD_NAME", 
                         "KWRD_NS", "KWRD_PATTERN", "KWRD_SET", "KWRD_STMT_GROUP", 
                         "KWRD_UNSET", "KWRD_URL", "KWRD_VERSION", "OBJECT_IDENT", 
                         "LETTER", "DIGIT", "ESCAPE_SEQUENCE", "OCTAL_ESCAPE", 
                         "UNICODE_ESCAPE", "HEX_DIGIT" ].freeze
        RULE_METHODS = [ :t__64!, :t__65!, :t__66!, :t__67!, :t__68!, :t__69!, 
                         :t__70!, :t__71!, :t__72!, :t__73!, :t__74!, :t__75!, 
                         :t__76!, :t__77!, :t__78!, :t__79!, :t__80!, :t__81!, 
                         :t__82!, :t__83!, :t__84!, :t__85!, :t__86!, :t__87!, 
                         :t__88!, :t__89!, :t__90!, :t__91!, :t__92!, :t__93!, 
                         :t__94!, :t__95!, :t__96!, :t__97!, :t__98!, :t__99!, 
                         :t__100!, :t__101!, :t__102!, :t__103!, :t__104!, :t__105!, 
                         :t__106!, :t__107!, :t__108!, :t__109!, :t__110!, :t__111!, 
                         :t__112!, :t__113!, :t__114!, :t__115!, :t__116!, :t__117!, 
                         :t__118!, :t__119!, :t__120!, :t__121!, :t__122!, :t__123!, 
                         :t__124!, :t__125!, :t__126!, :t__127!, :t__128!, :t__129!, 
                         :t__130!, :t__131!, :t__132!, :t__133!, :t__134!, :t__135!, 
                         :t__136!, :t__137!, :t__138!, :t__139!, :t__140!, :t__141!, 
                         :t__142!, :t__143!, :t__144!, :t__145!, :t__146!, :t__147!, 
                         :t__148!, :t__149!, :t__150!, :document_comment!, :statement_comment!, 
                         :ident_list!, :value_list!, :quoted_value!, :lp!, :rp!, 
                         :eq!, :colon!, :comma!, :newline!, :ws!, :kwrd_anno!, 
                         :kwrd_as!, :kwrd_authors!, :kwrd_contactinfo!, :kwrd_copyright!, 
                         :kwrd_dflt!, :kwrd_define!, :kwrd_desc!, :kwrd_disclaimer!, 
                         :kwrd_document!, :kwrd_licenses!, :kwrd_list!, :kwrd_name!, 
                         :kwrd_ns!, :kwrd_pattern!, :kwrd_set!, :kwrd_stmt_group!, 
                         :kwrd_unset!, :kwrd_url!, :kwrd_version!, :object_ident!, 
                         :letter!, :digit!, :escape_sequence!, :octal_escape!, 
                         :unicode_escape!, :hex_digit! ].freeze

        def initialize( input=nil, options = {} )
          super( input, options )
        end


        # - - - - - - - - - - - lexer rules - - - - - - - - - - - -
        # lexer rule t__64! (T__64)
        # (in BELScript_v1.g)
        def t__64!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 1 )



          type = T__64
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 7:9: '--'
          match( "--" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 1 )


        end

        # lexer rule t__65! (T__65)
        # (in BELScript_v1.g)
        def t__65!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 2 )



          type = T__65
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 8:9: '->'
          match( "->" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 2 )


        end

        # lexer rule t__66! (T__66)
        # (in BELScript_v1.g)
        def t__66!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 3 )



          type = T__66
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 9:9: '-|'
          match( "-|" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 3 )


        end

        # lexer rule t__67! (T__67)
        # (in BELScript_v1.g)
        def t__67!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 4 )



          type = T__67
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 10:9: ':>'
          match( ":>" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 4 )


        end

        # lexer rule t__68! (T__68)
        # (in BELScript_v1.g)
        def t__68!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 5 )



          type = T__68
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 11:9: '=>'
          match( "=>" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 5 )


        end

        # lexer rule t__69! (T__69)
        # (in BELScript_v1.g)
        def t__69!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 6 )



          type = T__69
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 12:9: '=|'
          match( "=|" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 6 )


        end

        # lexer rule t__70! (T__70)
        # (in BELScript_v1.g)
        def t__70!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 7 )



          type = T__70
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 13:9: '>>'
          match( ">>" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 7 )


        end

        # lexer rule t__71! (T__71)
        # (in BELScript_v1.g)
        def t__71!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 8 )



          type = T__71
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 14:9: 'a'
          match( 0x61 )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 8 )


        end

        # lexer rule t__72! (T__72)
        # (in BELScript_v1.g)
        def t__72!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 9 )



          type = T__72
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 15:9: 'abundance'
          match( "abundance" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 9 )


        end

        # lexer rule t__73! (T__73)
        # (in BELScript_v1.g)
        def t__73!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 10 )



          type = T__73
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 16:9: 'act'
          match( "act" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 10 )


        end

        # lexer rule t__74! (T__74)
        # (in BELScript_v1.g)
        def t__74!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 11 )



          type = T__74
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 17:9: 'analogous'
          match( "analogous" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 11 )


        end

        # lexer rule t__75! (T__75)
        # (in BELScript_v1.g)
        def t__75!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 12 )



          type = T__75
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 18:9: 'association'
          match( "association" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 12 )


        end

        # lexer rule t__76! (T__76)
        # (in BELScript_v1.g)
        def t__76!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 13 )



          type = T__76
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 19:9: 'biologicalProcess'
          match( "biologicalProcess" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 13 )


        end

        # lexer rule t__77! (T__77)
        # (in BELScript_v1.g)
        def t__77!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 14 )



          type = T__77
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 20:9: 'biomarkerFor'
          match( "biomarkerFor" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 14 )


        end

        # lexer rule t__78! (T__78)
        # (in BELScript_v1.g)
        def t__78!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 15 )



          type = T__78
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 21:9: 'bp'
          match( "bp" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 15 )


        end

        # lexer rule t__79! (T__79)
        # (in BELScript_v1.g)
        def t__79!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 16 )



          type = T__79
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 22:9: 'cat'
          match( "cat" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 16 )


        end

        # lexer rule t__80! (T__80)
        # (in BELScript_v1.g)
        def t__80!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 17 )



          type = T__80
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 23:9: 'catalyticActivity'
          match( "catalyticActivity" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 17 )


        end

        # lexer rule t__81! (T__81)
        # (in BELScript_v1.g)
        def t__81!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 18 )



          type = T__81
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 24:9: 'causesNoChange'
          match( "causesNoChange" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 18 )


        end

        # lexer rule t__82! (T__82)
        # (in BELScript_v1.g)
        def t__82!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 19 )



          type = T__82
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 25:9: 'cellSecretion'
          match( "cellSecretion" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 19 )


        end

        # lexer rule t__83! (T__83)
        # (in BELScript_v1.g)
        def t__83!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 20 )



          type = T__83
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 26:9: 'cellSurfaceExpression'
          match( "cellSurfaceExpression" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 20 )


        end

        # lexer rule t__84! (T__84)
        # (in BELScript_v1.g)
        def t__84!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 21 )



          type = T__84
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 27:9: 'chap'
          match( "chap" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 21 )


        end

        # lexer rule t__85! (T__85)
        # (in BELScript_v1.g)
        def t__85!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 22 )



          type = T__85
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 28:9: 'chaperoneActivity'
          match( "chaperoneActivity" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 22 )


        end

        # lexer rule t__86! (T__86)
        # (in BELScript_v1.g)
        def t__86!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 23 )



          type = T__86
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 29:9: 'complex'
          match( "complex" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 23 )


        end

        # lexer rule t__87! (T__87)
        # (in BELScript_v1.g)
        def t__87!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 24 )



          type = T__87
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 30:9: 'complexAbundance'
          match( "complexAbundance" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 24 )


        end

        # lexer rule t__88! (T__88)
        # (in BELScript_v1.g)
        def t__88!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 25 )



          type = T__88
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 31:9: 'composite'
          match( "composite" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 25 )


        end

        # lexer rule t__89! (T__89)
        # (in BELScript_v1.g)
        def t__89!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 26 )



          type = T__89
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 32:9: 'compositeAbundance'
          match( "compositeAbundance" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 26 )


        end

        # lexer rule t__90! (T__90)
        # (in BELScript_v1.g)
        def t__90!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 27 )



          type = T__90
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 33:9: 'decreases'
          match( "decreases" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 27 )


        end

        # lexer rule t__91! (T__91)
        # (in BELScript_v1.g)
        def t__91!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 28 )



          type = T__91
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 34:9: 'deg'
          match( "deg" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 28 )


        end

        # lexer rule t__92! (T__92)
        # (in BELScript_v1.g)
        def t__92!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 29 )



          type = T__92
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 35:9: 'degradation'
          match( "degradation" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 29 )


        end

        # lexer rule t__93! (T__93)
        # (in BELScript_v1.g)
        def t__93!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 30 )



          type = T__93
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 36:9: 'directlyDecreases'
          match( "directlyDecreases" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 30 )


        end

        # lexer rule t__94! (T__94)
        # (in BELScript_v1.g)
        def t__94!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 31 )



          type = T__94
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 37:9: 'directlyIncreases'
          match( "directlyIncreases" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 31 )


        end

        # lexer rule t__95! (T__95)
        # (in BELScript_v1.g)
        def t__95!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 32 )



          type = T__95
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 38:9: 'fus'
          match( "fus" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 32 )


        end

        # lexer rule t__96! (T__96)
        # (in BELScript_v1.g)
        def t__96!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 33 )



          type = T__96
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 39:9: 'fusion'
          match( "fusion" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 33 )


        end

        # lexer rule t__97! (T__97)
        # (in BELScript_v1.g)
        def t__97!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 34 )



          type = T__97
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 40:9: 'g'
          match( 0x67 )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 34 )


        end

        # lexer rule t__98! (T__98)
        # (in BELScript_v1.g)
        def t__98!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 35 )



          type = T__98
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 41:9: 'geneAbundance'
          match( "geneAbundance" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 35 )


        end

        # lexer rule t__99! (T__99)
        # (in BELScript_v1.g)
        def t__99!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 36 )



          type = T__99
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 42:9: 'gtp'
          match( "gtp" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 36 )


        end

        # lexer rule t__100! (T__100)
        # (in BELScript_v1.g)
        def t__100!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 37 )



          type = T__100
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 43:10: 'gtpBoundActivity'
          match( "gtpBoundActivity" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 37 )


        end

        # lexer rule t__101! (T__101)
        # (in BELScript_v1.g)
        def t__101!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 38 )



          type = T__101
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 44:10: 'hasComponent'
          match( "hasComponent" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 38 )


        end

        # lexer rule t__102! (T__102)
        # (in BELScript_v1.g)
        def t__102!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 39 )



          type = T__102
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 45:10: 'hasComponents'
          match( "hasComponents" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 39 )


        end

        # lexer rule t__103! (T__103)
        # (in BELScript_v1.g)
        def t__103!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 40 )



          type = T__103
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 46:10: 'hasMember'
          match( "hasMember" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 40 )


        end

        # lexer rule t__104! (T__104)
        # (in BELScript_v1.g)
        def t__104!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 41 )



          type = T__104
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 47:10: 'hasMembers'
          match( "hasMembers" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 41 )


        end

        # lexer rule t__105! (T__105)
        # (in BELScript_v1.g)
        def t__105!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 42 )



          type = T__105
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 48:10: 'increases'
          match( "increases" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 42 )


        end

        # lexer rule t__106! (T__106)
        # (in BELScript_v1.g)
        def t__106!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 43 )



          type = T__106
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 49:10: 'isA'
          match( "isA" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 43 )


        end

        # lexer rule t__107! (T__107)
        # (in BELScript_v1.g)
        def t__107!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 44 )



          type = T__107
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 50:10: 'kin'
          match( "kin" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 44 )


        end

        # lexer rule t__108! (T__108)
        # (in BELScript_v1.g)
        def t__108!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 45 )



          type = T__108
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 51:10: 'kinaseActivity'
          match( "kinaseActivity" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 45 )


        end

        # lexer rule t__109! (T__109)
        # (in BELScript_v1.g)
        def t__109!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 46 )



          type = T__109
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 52:10: 'list'
          match( "list" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 46 )


        end

        # lexer rule t__110! (T__110)
        # (in BELScript_v1.g)
        def t__110!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 47 )



          type = T__110
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 53:10: 'm'
          match( 0x6d )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 47 )


        end

        # lexer rule t__111! (T__111)
        # (in BELScript_v1.g)
        def t__111!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 48 )



          type = T__111
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 54:10: 'microRNAAbundance'
          match( "microRNAAbundance" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 48 )


        end

        # lexer rule t__112! (T__112)
        # (in BELScript_v1.g)
        def t__112!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 49 )



          type = T__112
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 55:10: 'molecularActivity'
          match( "molecularActivity" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 49 )


        end

        # lexer rule t__113! (T__113)
        # (in BELScript_v1.g)
        def t__113!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 50 )



          type = T__113
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 56:10: 'negativeCorrelation'
          match( "negativeCorrelation" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 50 )


        end

        # lexer rule t__114! (T__114)
        # (in BELScript_v1.g)
        def t__114!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 51 )



          type = T__114
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 57:10: 'orthologous'
          match( "orthologous" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 51 )


        end

        # lexer rule t__115! (T__115)
        # (in BELScript_v1.g)
        def t__115!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 52 )



          type = T__115
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 58:10: 'p'
          match( 0x70 )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 52 )


        end

        # lexer rule t__116! (T__116)
        # (in BELScript_v1.g)
        def t__116!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 53 )



          type = T__116
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 59:10: 'path'
          match( "path" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 53 )


        end

        # lexer rule t__117! (T__117)
        # (in BELScript_v1.g)
        def t__117!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 54 )



          type = T__117
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 60:10: 'pathology'
          match( "pathology" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 54 )


        end

        # lexer rule t__118! (T__118)
        # (in BELScript_v1.g)
        def t__118!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 55 )



          type = T__118
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 61:10: 'pep'
          match( "pep" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 55 )


        end

        # lexer rule t__119! (T__119)
        # (in BELScript_v1.g)
        def t__119!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 56 )



          type = T__119
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 62:10: 'peptidaseActivity'
          match( "peptidaseActivity" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 56 )


        end

        # lexer rule t__120! (T__120)
        # (in BELScript_v1.g)
        def t__120!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 57 )



          type = T__120
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 63:10: 'phos'
          match( "phos" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 57 )


        end

        # lexer rule t__121! (T__121)
        # (in BELScript_v1.g)
        def t__121!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 58 )



          type = T__121
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 64:10: 'phosphataseActivity'
          match( "phosphataseActivity" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 58 )


        end

        # lexer rule t__122! (T__122)
        # (in BELScript_v1.g)
        def t__122!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 59 )



          type = T__122
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 65:10: 'pmod'
          match( "pmod" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 59 )


        end

        # lexer rule t__123! (T__123)
        # (in BELScript_v1.g)
        def t__123!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 60 )



          type = T__123
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 66:10: 'positiveCorrelation'
          match( "positiveCorrelation" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 60 )


        end

        # lexer rule t__124! (T__124)
        # (in BELScript_v1.g)
        def t__124!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 61 )



          type = T__124
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 67:10: 'products'
          match( "products" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 61 )


        end

        # lexer rule t__125! (T__125)
        # (in BELScript_v1.g)
        def t__125!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 62 )



          type = T__125
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 68:10: 'prognosticBiomarkerFor'
          match( "prognosticBiomarkerFor" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 62 )


        end

        # lexer rule t__126! (T__126)
        # (in BELScript_v1.g)
        def t__126!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 63 )



          type = T__126
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 69:10: 'proteinAbundance'
          match( "proteinAbundance" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 63 )


        end

        # lexer rule t__127! (T__127)
        # (in BELScript_v1.g)
        def t__127!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 64 )



          type = T__127
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 70:10: 'proteinModification'
          match( "proteinModification" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 64 )


        end

        # lexer rule t__128! (T__128)
        # (in BELScript_v1.g)
        def t__128!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 65 )



          type = T__128
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 71:10: 'r'
          match( 0x72 )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 65 )


        end

        # lexer rule t__129! (T__129)
        # (in BELScript_v1.g)
        def t__129!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 66 )



          type = T__129
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 72:10: 'rateLimitingStepOf'
          match( "rateLimitingStepOf" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 66 )


        end

        # lexer rule t__130! (T__130)
        # (in BELScript_v1.g)
        def t__130!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 67 )



          type = T__130
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 73:10: 'reactants'
          match( "reactants" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 67 )


        end

        # lexer rule t__131! (T__131)
        # (in BELScript_v1.g)
        def t__131!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 68 )



          type = T__131
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 74:10: 'reaction'
          match( "reaction" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 68 )


        end

        # lexer rule t__132! (T__132)
        # (in BELScript_v1.g)
        def t__132!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 69 )



          type = T__132
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 75:10: 'ribo'
          match( "ribo" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 69 )


        end

        # lexer rule t__133! (T__133)
        # (in BELScript_v1.g)
        def t__133!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 70 )



          type = T__133
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 76:10: 'ribosylationActivity'
          match( "ribosylationActivity" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 70 )


        end

        # lexer rule t__134! (T__134)
        # (in BELScript_v1.g)
        def t__134!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 71 )



          type = T__134
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 77:10: 'rnaAbundance'
          match( "rnaAbundance" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 71 )


        end

        # lexer rule t__135! (T__135)
        # (in BELScript_v1.g)
        def t__135!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 72 )



          type = T__135
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 78:10: 'rxn'
          match( "rxn" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 72 )


        end

        # lexer rule t__136! (T__136)
        # (in BELScript_v1.g)
        def t__136!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 73 )



          type = T__136
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 79:10: 'sec'
          match( "sec" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 73 )


        end

        # lexer rule t__137! (T__137)
        # (in BELScript_v1.g)
        def t__137!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 74 )



          type = T__137
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 80:10: 'sub'
          match( "sub" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 74 )


        end

        # lexer rule t__138! (T__138)
        # (in BELScript_v1.g)
        def t__138!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 75 )



          type = T__138
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 81:10: 'subProcessOf'
          match( "subProcessOf" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 75 )


        end

        # lexer rule t__139! (T__139)
        # (in BELScript_v1.g)
        def t__139!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 76 )



          type = T__139
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 82:10: 'substitution'
          match( "substitution" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 76 )


        end

        # lexer rule t__140! (T__140)
        # (in BELScript_v1.g)
        def t__140!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 77 )



          type = T__140
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 83:10: 'surf'
          match( "surf" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 77 )


        end

        # lexer rule t__141! (T__141)
        # (in BELScript_v1.g)
        def t__141!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 78 )



          type = T__141
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 84:10: 'tloc'
          match( "tloc" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 78 )


        end

        # lexer rule t__142! (T__142)
        # (in BELScript_v1.g)
        def t__142!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 79 )



          type = T__142
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 85:10: 'tport'
          match( "tport" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 79 )


        end

        # lexer rule t__143! (T__143)
        # (in BELScript_v1.g)
        def t__143!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 80 )



          type = T__143
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 86:10: 'transcribedTo'
          match( "transcribedTo" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 80 )


        end

        # lexer rule t__144! (T__144)
        # (in BELScript_v1.g)
        def t__144!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 81 )



          type = T__144
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 87:10: 'transcriptionalActivity'
          match( "transcriptionalActivity" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 81 )


        end

        # lexer rule t__145! (T__145)
        # (in BELScript_v1.g)
        def t__145!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 82 )



          type = T__145
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 88:10: 'translatedTo'
          match( "translatedTo" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 82 )


        end

        # lexer rule t__146! (T__146)
        # (in BELScript_v1.g)
        def t__146!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 83 )



          type = T__146
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 89:10: 'translocation'
          match( "translocation" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 83 )


        end

        # lexer rule t__147! (T__147)
        # (in BELScript_v1.g)
        def t__147!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 84 )



          type = T__147
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 90:10: 'transportActivity'
          match( "transportActivity" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 84 )


        end

        # lexer rule t__148! (T__148)
        # (in BELScript_v1.g)
        def t__148!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 85 )



          type = T__148
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 91:10: 'trunc'
          match( "trunc" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 85 )


        end

        # lexer rule t__149! (T__149)
        # (in BELScript_v1.g)
        def t__149!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 86 )



          type = T__149
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 92:10: 'truncation'
          match( "truncation" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 86 )


        end

        # lexer rule t__150! (T__150)
        # (in BELScript_v1.g)
        def t__150!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 87 )



          type = T__150
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 93:10: 'tscript'
          match( "tscript" )



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 87 )


        end

        # lexer rule document_comment! (DOCUMENT_COMMENT)
        # (in BELScript_v1.g)
        def document_comment!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 88 )



          type = DOCUMENT_COMMENT
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 278:9: '#' (~ ( '\\n' | '\\r' ) )*
          match( 0x23 )
          # at line 278:13: (~ ( '\\n' | '\\r' ) )*
          while true # decision 1
            alt_1 = 2
            look_1_0 = @input.peek( 1 )

            if ( look_1_0.between?( 0x0, 0x9 ) || look_1_0.between?( 0xb, 0xc ) || look_1_0.between?( 0xe, 0xffff ) )
              alt_1 = 1

            end
            case alt_1
            when 1
              # at line 
              if @input.peek( 1 ).between?( 0x0, 0x9 ) || @input.peek( 1 ).between?( 0xb, 0xc ) || @input.peek( 1 ).between?( 0xe, 0xffff )
                @input.consume
              else
                mse = MismatchedSet( nil )
                recover mse
                raise mse

              end



            else
              break # out of loop for decision 1
            end
          end # loop for decision 1



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 88 )


        end

        # lexer rule statement_comment! (STATEMENT_COMMENT)
        # (in BELScript_v1.g)
        def statement_comment!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 89 )



          type = STATEMENT_COMMENT
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 282:9: '//' ( ( '\\\\\\n' ) | ( '\\\\\\r\\n' ) |~ ( '\\n' | '\\r' ) )*
          match( "//" )

          # at line 282:14: ( ( '\\\\\\n' ) | ( '\\\\\\r\\n' ) |~ ( '\\n' | '\\r' ) )*
          while true # decision 2
            alt_2 = 4
            look_2_0 = @input.peek( 1 )

            if ( look_2_0 == 0x5c )
              case look_2 = @input.peek( 2 )
              when 0xa then alt_2 = 1
              when 0xd then alt_2 = 2
              else
                alt_2 = 3
              end
            elsif ( look_2_0.between?( 0x0, 0x9 ) || look_2_0.between?( 0xb, 0xc ) || look_2_0.between?( 0xe, 0x5b ) || look_2_0.between?( 0x5d, 0xffff ) )
              alt_2 = 3

            end
            case alt_2
            when 1
              # at line 282:15: ( '\\\\\\n' )
              # at line 282:15: ( '\\\\\\n' )
              # at line 282:16: '\\\\\\n'
              match( "\\\n" )



            when 2
              # at line 282:26: ( '\\\\\\r\\n' )
              # at line 282:26: ( '\\\\\\r\\n' )
              # at line 282:27: '\\\\\\r\\n'
              match( "\\\r\n" )



            when 3
              # at line 282:39: ~ ( '\\n' | '\\r' )
              if @input.peek( 1 ).between?( 0x0, 0x9 ) || @input.peek( 1 ).between?( 0xb, 0xc ) || @input.peek( 1 ).between?( 0xe, 0xff )
                @input.consume
              else
                mse = MismatchedSet( nil )
                recover mse
                raise mse

              end



            else
              break # out of loop for decision 2
            end
          end # loop for decision 2



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 89 )


        end

        # lexer rule ident_list! (IDENT_LIST)
        # (in BELScript_v1.g)
        def ident_list!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 90 )



          type = IDENT_LIST
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 286:9: '{' OBJECT_IDENT ( COMMA OBJECT_IDENT )* '}'
          match( 0x7b )

          object_ident!

          # at line 286:26: ( COMMA OBJECT_IDENT )*
          while true # decision 3
            alt_3 = 2
            look_3_0 = @input.peek( 1 )

            if ( look_3_0 == 0x2c )
              alt_3 = 1

            end
            case alt_3
            when 1
              # at line 286:27: COMMA OBJECT_IDENT
              comma!


              object_ident!


            else
              break # out of loop for decision 3
            end
          end # loop for decision 3

          match( 0x7d )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 90 )


        end

        # lexer rule value_list! (VALUE_LIST)
        # (in BELScript_v1.g)
        def value_list!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 91 )



          type = VALUE_LIST
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 290:9: '{' ( OBJECT_IDENT | QUOTED_VALUE | VALUE_LIST )? ( COMMA ( ' ' )* ( OBJECT_IDENT | QUOTED_VALUE | VALUE_LIST )? )* '}'
          match( 0x7b )
          # at line 290:13: ( OBJECT_IDENT | QUOTED_VALUE | VALUE_LIST )?
          alt_4 = 4
          case look_4 = @input.peek( 1 )
          when 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f, 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5a, 0x5f, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7a then alt_4 = 1
          when 0x22 then alt_4 = 2
          when 0x7b then alt_4 = 3
          end
          case alt_4
          when 1
            # at line 290:14: OBJECT_IDENT
            object_ident!


          when 2
            # at line 290:29: QUOTED_VALUE
            quoted_value!


          when 3
            # at line 290:44: VALUE_LIST
            value_list!


          end
          # at line 290:57: ( COMMA ( ' ' )* ( OBJECT_IDENT | QUOTED_VALUE | VALUE_LIST )? )*
          while true # decision 7
            alt_7 = 2
            look_7_0 = @input.peek( 1 )

            if ( look_7_0 == 0x2c )
              alt_7 = 1

            end
            case alt_7
            when 1
              # at line 290:58: COMMA ( ' ' )* ( OBJECT_IDENT | QUOTED_VALUE | VALUE_LIST )?
              comma!

              # at line 290:64: ( ' ' )*
              while true # decision 5
                alt_5 = 2
                look_5_0 = @input.peek( 1 )

                if ( look_5_0 == 0x20 )
                  alt_5 = 1

                end
                case alt_5
                when 1
                  # at line 290:65: ' '
                  match( 0x20 )

                else
                  break # out of loop for decision 5
                end
              end # loop for decision 5

              # at line 290:71: ( OBJECT_IDENT | QUOTED_VALUE | VALUE_LIST )?
              alt_6 = 4
              case look_6 = @input.peek( 1 )
              when 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f, 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5a, 0x5f, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7a then alt_6 = 1
              when 0x22 then alt_6 = 2
              when 0x7b then alt_6 = 3
              end
              case alt_6
              when 1
                # at line 290:72: OBJECT_IDENT
                object_ident!


              when 2
                # at line 290:87: QUOTED_VALUE
                quoted_value!


              when 3
                # at line 290:102: VALUE_LIST
                value_list!


              end

            else
              break # out of loop for decision 7
            end
          end # loop for decision 7

          match( 0x7d )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 91 )


        end

        # lexer rule quoted_value! (QUOTED_VALUE)
        # (in BELScript_v1.g)
        def quoted_value!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 92 )



          type = QUOTED_VALUE
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 294:9: '\"' (~ ( '\"' ) )* '\"'
          match( 0x22 )
          # at line 294:13: (~ ( '\"' ) )*
          while true # decision 8
            alt_8 = 2
            look_8_0 = @input.peek( 1 )

            if ( look_8_0.between?( 0x0, 0x21 ) || look_8_0.between?( 0x23, 0xffff ) )
              alt_8 = 1

            end
            case alt_8
            when 1
              # at line 
              if @input.peek( 1 ).between?( 0x0, 0x21 ) || @input.peek( 1 ).between?( 0x23, 0xffff )
                @input.consume
              else
                mse = MismatchedSet( nil )
                recover mse
                raise mse

              end



            else
              break # out of loop for decision 8
            end
          end # loop for decision 8

          match( 0x22 )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 92 )


        end

        # lexer rule lp! (LP)
        # (in BELScript_v1.g)
        def lp!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 93 )



          type = LP
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 297:5: '('
          match( 0x28 )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 93 )


        end

        # lexer rule rp! (RP)
        # (in BELScript_v1.g)
        def rp!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 94 )



          type = RP
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 298:5: ')'
          match( 0x29 )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 94 )


        end

        # lexer rule eq! (EQ)
        # (in BELScript_v1.g)
        def eq!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 95 )



          type = EQ
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 299:5: '='
          match( 0x3d )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 95 )


        end

        # lexer rule colon! (COLON)
        # (in BELScript_v1.g)
        def colon!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 96 )



          type = COLON
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 300:8: ':'
          match( 0x3a )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 96 )


        end

        # lexer rule comma! (COMMA)
        # (in BELScript_v1.g)
        def comma!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 97 )



          type = COMMA
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 301:8: ','
          match( 0x2c )


          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 97 )


        end

        # lexer rule newline! (NEWLINE)
        # (in BELScript_v1.g)
        def newline!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 98 )



          type = NEWLINE
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 304:5: ( ( '\\u000d' )? '\\u000a' | '\\u000d' )
          alt_10 = 2
          look_10_0 = @input.peek( 1 )

          if ( look_10_0 == 0xd )
            look_10_1 = @input.peek( 2 )

            if ( look_10_1 == 0xa )
              alt_10 = 1
            else
              alt_10 = 2

            end
          elsif ( look_10_0 == 0xa )
            alt_10 = 1
          else
            raise NoViableAlternative( "", 10, 0 )

          end
          case alt_10
          when 1
            # at line 304:9: ( '\\u000d' )? '\\u000a'
            # at line 304:9: ( '\\u000d' )?
            alt_9 = 2
            look_9_0 = @input.peek( 1 )

            if ( look_9_0 == 0xd )
              alt_9 = 1
            end
            case alt_9
            when 1
              # at line 304:9: '\\u000d'
              match( 0xd )

            end
            match( 0xa )

          when 2
            # at line 304:30: '\\u000d'
            match( 0xd )

          end

          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 98 )


        end

        # lexer rule ws! (WS)
        # (in BELScript_v1.g)
        def ws!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 99 )



          type = WS
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 307:5: ( ' ' | '\\t' | '\\n' | '\\r' | '\\f' | '\\\\\\n' | '\\\\\\r\\n' )+
          # at file 307:5: ( ' ' | '\\t' | '\\n' | '\\r' | '\\f' | '\\\\\\n' | '\\\\\\r\\n' )+
          match_count_11 = 0
          while true
            alt_11 = 8
            case look_11 = @input.peek( 1 )
            when 0x20 then alt_11 = 1
            when 0x9 then alt_11 = 2
            when 0xa then alt_11 = 3
            when 0xd then alt_11 = 4
            when 0xc then alt_11 = 5
            when 0x5c then look_11_7 = @input.peek( 2 )

            if ( look_11_7 == 0xa )
              alt_11 = 6
            elsif ( look_11_7 == 0xd )
              alt_11 = 7

            end
            end
            case alt_11
            when 1
              # at line 307:6: ' '
              match( 0x20 )

            when 2
              # at line 307:12: '\\t'
              match( 0x9 )

            when 3
              # at line 307:19: '\\n'
              match( 0xa )

            when 4
              # at line 307:26: '\\r'
              match( 0xd )

            when 5
              # at line 307:32: '\\f'
              match( 0xc )

            when 6
              # at line 307:39: '\\\\\\n'
              match( "\\\n" )


            when 7
              # at line 307:48: '\\\\\\r\\n'
              match( "\\\r\n" )


            else
              match_count_11 > 0 and break
              eee = EarlyExit(11)


              raise eee
            end
            match_count_11 += 1
          end



          # --> action
           skip(); 
          # <-- action



          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 99 )


        end

        # lexer rule kwrd_anno! (KWRD_ANNO)
        # (in BELScript_v1.g)
        def kwrd_anno!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 100 )



          type = KWRD_ANNO
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 312:9: ( 'A' | 'a' ) ( 'N' | 'n' ) ( 'N' | 'n' ) ( 'O' | 'o' ) ( 'T' | 't' ) ( 'A' | 'a' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'O' | 'o' ) ( 'N' | 'n' )
          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4f || @input.peek(1) == 0x6f
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x49 || @input.peek(1) == 0x69
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4f || @input.peek(1) == 0x6f
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 100 )


        end

        # lexer rule kwrd_as! (KWRD_AS)
        # (in BELScript_v1.g)
        def kwrd_as!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 101 )



          type = KWRD_AS
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 316:9: ( 'A' | 'a' ) ( 'S' | 's' )
          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 101 )


        end

        # lexer rule kwrd_authors! (KWRD_AUTHORS)
        # (in BELScript_v1.g)
        def kwrd_authors!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 102 )



          type = KWRD_AUTHORS
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 320:9: ( 'A' | 'a' ) ( 'U' | 'u' ) ( 'T' | 't' ) ( 'H' | 'h' ) ( 'O' | 'o' ) ( 'R' | 'r' ) ( 'S' | 's' )
          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x55 || @input.peek(1) == 0x75
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x48 || @input.peek(1) == 0x68
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4f || @input.peek(1) == 0x6f
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x52 || @input.peek(1) == 0x72
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 102 )


        end

        # lexer rule kwrd_contactinfo! (KWRD_CONTACTINFO)
        # (in BELScript_v1.g)
        def kwrd_contactinfo!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 103 )



          type = KWRD_CONTACTINFO
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 324:9: ( 'C' | 'c' ) ( 'O' | 'o' ) ( 'N' | 'n' ) ( 'T' | 't' ) ( 'A' | 'a' ) ( 'C' | 'c' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'N' | 'n' ) ( 'F' | 'f' ) ( 'O' | 'o' )
          if @input.peek(1) == 0x43 || @input.peek(1) == 0x63
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4f || @input.peek(1) == 0x6f
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x43 || @input.peek(1) == 0x63
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x49 || @input.peek(1) == 0x69
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x46 || @input.peek(1) == 0x66
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4f || @input.peek(1) == 0x6f
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 103 )


        end

        # lexer rule kwrd_copyright! (KWRD_COPYRIGHT)
        # (in BELScript_v1.g)
        def kwrd_copyright!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 104 )



          type = KWRD_COPYRIGHT
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 328:9: ( 'C' | 'c' ) ( 'O' | 'o' ) ( 'P' | 'p' ) ( 'Y' | 'y' ) ( 'R' | 'r' ) ( 'I' | 'i' ) ( 'G' | 'g' ) ( 'H' | 'h' ) ( 'T' | 't' )
          if @input.peek(1) == 0x43 || @input.peek(1) == 0x63
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4f || @input.peek(1) == 0x6f
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x50 || @input.peek(1) == 0x70
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x59 || @input.peek(1) == 0x79
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x52 || @input.peek(1) == 0x72
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x49 || @input.peek(1) == 0x69
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x47 || @input.peek(1) == 0x67
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x48 || @input.peek(1) == 0x68
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 104 )


        end

        # lexer rule kwrd_dflt! (KWRD_DFLT)
        # (in BELScript_v1.g)
        def kwrd_dflt!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 105 )



          type = KWRD_DFLT
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 332:9: ( 'D' | 'd' ) ( 'E' | 'e' ) ( 'F' | 'f' ) ( 'A' | 'a' ) ( 'U' | 'u' ) ( 'L' | 'l' ) ( 'T' | 't' )
          if @input.peek(1) == 0x44 || @input.peek(1) == 0x64
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x46 || @input.peek(1) == 0x66
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x55 || @input.peek(1) == 0x75
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4c || @input.peek(1) == 0x6c
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 105 )


        end

        # lexer rule kwrd_define! (KWRD_DEFINE)
        # (in BELScript_v1.g)
        def kwrd_define!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 106 )



          type = KWRD_DEFINE
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 336:9: ( 'D' | 'd' ) ( 'E' | 'e' ) ( 'F' | 'f' ) ( 'I' | 'i' ) ( 'N' | 'n' ) ( 'E' | 'e' )
          if @input.peek(1) == 0x44 || @input.peek(1) == 0x64
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x46 || @input.peek(1) == 0x66
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x49 || @input.peek(1) == 0x69
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 106 )


        end

        # lexer rule kwrd_desc! (KWRD_DESC)
        # (in BELScript_v1.g)
        def kwrd_desc!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 107 )



          type = KWRD_DESC
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 340:9: ( 'D' | 'd' ) ( 'E' | 'e' ) ( 'S' | 's' ) ( 'C' | 'c' ) ( 'R' | 'r' ) ( 'I' | 'i' ) ( 'P' | 'p' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'O' | 'o' ) ( 'N' | 'n' )
          if @input.peek(1) == 0x44 || @input.peek(1) == 0x64
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x43 || @input.peek(1) == 0x63
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x52 || @input.peek(1) == 0x72
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x49 || @input.peek(1) == 0x69
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x50 || @input.peek(1) == 0x70
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x49 || @input.peek(1) == 0x69
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4f || @input.peek(1) == 0x6f
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 107 )


        end

        # lexer rule kwrd_disclaimer! (KWRD_DISCLAIMER)
        # (in BELScript_v1.g)
        def kwrd_disclaimer!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 108 )



          type = KWRD_DISCLAIMER
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 344:9: ( 'D' | 'd' ) ( 'I' | 'i' ) ( 'S' | 's' ) ( 'C' | 'c' ) ( 'L' | 'l' ) ( 'A' | 'a' ) ( 'I' | 'i' ) ( 'M' | 'm' ) ( 'E' | 'e' ) ( 'R' | 'r' )
          if @input.peek(1) == 0x44 || @input.peek(1) == 0x64
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x49 || @input.peek(1) == 0x69
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x43 || @input.peek(1) == 0x63
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4c || @input.peek(1) == 0x6c
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x49 || @input.peek(1) == 0x69
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4d || @input.peek(1) == 0x6d
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x52 || @input.peek(1) == 0x72
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 108 )


        end

        # lexer rule kwrd_document! (KWRD_DOCUMENT)
        # (in BELScript_v1.g)
        def kwrd_document!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 109 )



          type = KWRD_DOCUMENT
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 348:9: ( 'D' | 'd' ) ( 'O' | 'o' ) ( 'C' | 'c' ) ( 'U' | 'u' ) ( 'M' | 'm' ) ( 'E' | 'e' ) ( 'N' | 'n' ) ( 'T' | 't' )
          if @input.peek(1) == 0x44 || @input.peek(1) == 0x64
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4f || @input.peek(1) == 0x6f
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x43 || @input.peek(1) == 0x63
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x55 || @input.peek(1) == 0x75
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4d || @input.peek(1) == 0x6d
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 109 )


        end

        # lexer rule kwrd_licenses! (KWRD_LICENSES)
        # (in BELScript_v1.g)
        def kwrd_licenses!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 110 )



          type = KWRD_LICENSES
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 352:9: ( 'L' | 'l' ) ( 'I' | 'i' ) ( 'C' | 'c' ) ( 'E' | 'e' ) ( 'N' | 'n' ) ( 'S' | 's' ) ( 'E' | 'e' ) ( 'S' | 's' )
          if @input.peek(1) == 0x4c || @input.peek(1) == 0x6c
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x49 || @input.peek(1) == 0x69
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x43 || @input.peek(1) == 0x63
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 110 )


        end

        # lexer rule kwrd_list! (KWRD_LIST)
        # (in BELScript_v1.g)
        def kwrd_list!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 111 )



          type = KWRD_LIST
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 356:9: ( 'L' | 'l' ) ( 'I' | 'i' ) ( 'S' | 's' ) ( 'T' | 't' )
          if @input.peek(1) == 0x4c || @input.peek(1) == 0x6c
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x49 || @input.peek(1) == 0x69
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 111 )


        end

        # lexer rule kwrd_name! (KWRD_NAME)
        # (in BELScript_v1.g)
        def kwrd_name!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 112 )



          type = KWRD_NAME
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 360:9: ( 'N' | 'n' ) ( 'A' | 'a' ) ( 'M' | 'm' ) ( 'E' | 'e' )
          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4d || @input.peek(1) == 0x6d
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 112 )


        end

        # lexer rule kwrd_ns! (KWRD_NS)
        # (in BELScript_v1.g)
        def kwrd_ns!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 113 )



          type = KWRD_NS
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 364:9: ( 'N' | 'n' ) ( 'A' | 'a' ) ( 'M' | 'm' ) ( 'E' | 'e' ) ( 'S' | 's' ) ( 'P' | 'p' ) ( 'A' | 'a' ) ( 'C' | 'c' ) ( 'E' | 'e' )
          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4d || @input.peek(1) == 0x6d
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x50 || @input.peek(1) == 0x70
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x43 || @input.peek(1) == 0x63
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 113 )


        end

        # lexer rule kwrd_pattern! (KWRD_PATTERN)
        # (in BELScript_v1.g)
        def kwrd_pattern!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 114 )



          type = KWRD_PATTERN
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 368:9: ( 'P' | 'p' ) ( 'A' | 'a' ) ( 'T' | 't' ) ( 'T' | 't' ) ( 'E' | 'e' ) ( 'R' | 'r' ) ( 'N' | 'n' )
          if @input.peek(1) == 0x50 || @input.peek(1) == 0x70
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x52 || @input.peek(1) == 0x72
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 114 )


        end

        # lexer rule kwrd_set! (KWRD_SET)
        # (in BELScript_v1.g)
        def kwrd_set!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 115 )



          type = KWRD_SET
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 372:9: ( 'S' | 's' ) ( 'E' | 'e' ) ( 'T' | 't' )
          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 115 )


        end

        # lexer rule kwrd_stmt_group! (KWRD_STMT_GROUP)
        # (in BELScript_v1.g)
        def kwrd_stmt_group!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 116 )



          type = KWRD_STMT_GROUP
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 376:9: ( 'S' | 's' ) ( 'T' | 't' ) ( 'A' | 'a' ) ( 'T' | 't' ) ( 'E' | 'e' ) ( 'M' | 'm' ) ( 'E' | 'e' ) ( 'N' | 'n' ) ( 'T' | 't' ) ( '_' ) ( 'G' | 'g' ) ( 'R' | 'r' ) ( 'O' | 'o' ) ( 'U' | 'u' ) ( 'P' | 'p' )
          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x41 || @input.peek(1) == 0x61
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4d || @input.peek(1) == 0x6d
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          # at line 376:90: ( '_' )
          # at line 376:91: '_'
          match( 0x5f )

          if @input.peek(1) == 0x47 || @input.peek(1) == 0x67
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x52 || @input.peek(1) == 0x72
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4f || @input.peek(1) == 0x6f
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x55 || @input.peek(1) == 0x75
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x50 || @input.peek(1) == 0x70
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 116 )


        end

        # lexer rule kwrd_unset! (KWRD_UNSET)
        # (in BELScript_v1.g)
        def kwrd_unset!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 117 )



          type = KWRD_UNSET
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 380:9: ( 'U' | 'u' ) ( 'N' | 'n' ) ( 'S' | 's' ) ( 'E' | 'e' ) ( 'T' | 't' )
          if @input.peek(1) == 0x55 || @input.peek(1) == 0x75
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x54 || @input.peek(1) == 0x74
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 117 )


        end

        # lexer rule kwrd_url! (KWRD_URL)
        # (in BELScript_v1.g)
        def kwrd_url!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 118 )



          type = KWRD_URL
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 384:9: ( 'U' | 'u' ) ( 'R' | 'r' ) ( 'L' | 'l' )
          if @input.peek(1) == 0x55 || @input.peek(1) == 0x75
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x52 || @input.peek(1) == 0x72
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4c || @input.peek(1) == 0x6c
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 118 )


        end

        # lexer rule kwrd_version! (KWRD_VERSION)
        # (in BELScript_v1.g)
        def kwrd_version!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 119 )



          type = KWRD_VERSION
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 388:9: ( 'V' | 'v' ) ( 'E' | 'e' ) ( 'R' | 'r' ) ( 'S' | 's' ) ( 'I' | 'i' ) ( 'O' | 'o' ) ( 'N' | 'n' )
          if @input.peek(1) == 0x56 || @input.peek(1) == 0x76
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x45 || @input.peek(1) == 0x65
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x52 || @input.peek(1) == 0x72
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x53 || @input.peek(1) == 0x73
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x49 || @input.peek(1) == 0x69
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4f || @input.peek(1) == 0x6f
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end


          if @input.peek(1) == 0x4e || @input.peek(1) == 0x6e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 119 )


        end

        # lexer rule object_ident! (OBJECT_IDENT)
        # (in BELScript_v1.g)
        def object_ident!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 120 )



          type = OBJECT_IDENT
          channel = ANTLR3::DEFAULT_CHANNEL
        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 392:9: ( '_' | LETTER | DIGIT )+
          # at file 392:9: ( '_' | LETTER | DIGIT )+
          match_count_12 = 0
          while true
            alt_12 = 2
            look_12_0 = @input.peek( 1 )

            if ( look_12_0.between?( 0x30, 0x39 ) || look_12_0.between?( 0x41, 0x5a ) || look_12_0 == 0x5f || look_12_0.between?( 0x61, 0x7a ) )
              alt_12 = 1

            end
            case alt_12
            when 1
              # at line 
              if @input.peek( 1 ).between?( 0x30, 0x39 ) || @input.peek( 1 ).between?( 0x41, 0x5a ) || @input.peek(1) == 0x5f || @input.peek( 1 ).between?( 0x61, 0x7a )
                @input.consume
              else
                mse = MismatchedSet( nil )
                recover mse
                raise mse

              end



            else
              match_count_12 > 0 and break
              eee = EarlyExit(12)


              raise eee
            end
            match_count_12 += 1
          end




          @state.type = type
          @state.channel = channel
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 120 )


        end

        # lexer rule letter! (LETTER)
        # (in BELScript_v1.g)
        def letter!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 121 )


        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 
          if @input.peek( 1 ).between?( 0x41, 0x5a ) || @input.peek( 1 ).between?( 0x61, 0x7a )
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end



        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 121 )


        end

        # lexer rule digit! (DIGIT)
        # (in BELScript_v1.g)
        def digit!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 122 )


        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 
          if @input.peek( 1 ).between?( 0x30, 0x39 )
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end



        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 122 )


        end

        # lexer rule escape_sequence! (ESCAPE_SEQUENCE)
        # (in BELScript_v1.g)
        def escape_sequence!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 123 )


        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 408:5: ( '\\\\' ( 'b' | 't' | 'n' | 'f' | 'r' | '\\\"' | '\\'' | '\\\\' ) | UNICODE_ESCAPE | OCTAL_ESCAPE )
          alt_13 = 3
          look_13_0 = @input.peek( 1 )

          if ( look_13_0 == 0x5c )
            case look_13 = @input.peek( 2 )
            when 0x22, 0x27, 0x5c, 0x62, 0x66, 0x6e, 0x72, 0x74 then alt_13 = 1
            when 0x75 then alt_13 = 2
            when 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37 then alt_13 = 3
            else
              raise NoViableAlternative( "", 13, 1 )

            end
          else
            raise NoViableAlternative( "", 13, 0 )

          end
          case alt_13
          when 1
            # at line 408:9: '\\\\' ( 'b' | 't' | 'n' | 'f' | 'r' | '\\\"' | '\\'' | '\\\\' )
            match( 0x5c )
            if @input.peek(1) == 0x22 || @input.peek(1) == 0x27 || @input.peek(1) == 0x5c || @input.peek(1) == 0x62 || @input.peek(1) == 0x66 || @input.peek(1) == 0x6e || @input.peek(1) == 0x72 || @input.peek(1) == 0x74
              @input.consume
            else
              mse = MismatchedSet( nil )
              recover mse
              raise mse

            end



          when 2
            # at line 409:9: UNICODE_ESCAPE
            unicode_escape!


          when 3
            # at line 410:9: OCTAL_ESCAPE
            octal_escape!


          end
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 123 )


        end

        # lexer rule octal_escape! (OCTAL_ESCAPE)
        # (in BELScript_v1.g)
        def octal_escape!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 124 )


        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 414:5: ( '\\\\' ( '0' .. '3' ) ( '0' .. '7' ) ( '0' .. '7' ) | '\\\\' ( '0' .. '7' ) ( '0' .. '7' ) | '\\\\' ( '0' .. '7' ) )
          alt_14 = 3
          look_14_0 = @input.peek( 1 )

          if ( look_14_0 == 0x5c )
            look_14_1 = @input.peek( 2 )

            if ( look_14_1.between?( 0x30, 0x33 ) )
              look_14_2 = @input.peek( 3 )

              if ( look_14_2.between?( 0x30, 0x37 ) )
                look_14_4 = @input.peek( 4 )

                if ( look_14_4.between?( 0x30, 0x37 ) )
                  alt_14 = 1
                else
                  alt_14 = 2

                end
              else
                alt_14 = 3

              end
            elsif ( look_14_1.between?( 0x34, 0x37 ) )
              look_14_3 = @input.peek( 3 )

              if ( look_14_3.between?( 0x30, 0x37 ) )
                alt_14 = 2
              else
                alt_14 = 3

              end
            else
              raise NoViableAlternative( "", 14, 1 )

            end
          else
            raise NoViableAlternative( "", 14, 0 )

          end
          case alt_14
          when 1
            # at line 414:9: '\\\\' ( '0' .. '3' ) ( '0' .. '7' ) ( '0' .. '7' )
            match( 0x5c )
            if @input.peek( 1 ).between?( 0x30, 0x33 )
              @input.consume
            else
              mse = MismatchedSet( nil )
              recover mse
              raise mse

            end


            if @input.peek( 1 ).between?( 0x30, 0x37 )
              @input.consume
            else
              mse = MismatchedSet( nil )
              recover mse
              raise mse

            end


            if @input.peek( 1 ).between?( 0x30, 0x37 )
              @input.consume
            else
              mse = MismatchedSet( nil )
              recover mse
              raise mse

            end



          when 2
            # at line 415:9: '\\\\' ( '0' .. '7' ) ( '0' .. '7' )
            match( 0x5c )
            if @input.peek( 1 ).between?( 0x30, 0x37 )
              @input.consume
            else
              mse = MismatchedSet( nil )
              recover mse
              raise mse

            end


            if @input.peek( 1 ).between?( 0x30, 0x37 )
              @input.consume
            else
              mse = MismatchedSet( nil )
              recover mse
              raise mse

            end



          when 3
            # at line 416:9: '\\\\' ( '0' .. '7' )
            match( 0x5c )
            if @input.peek( 1 ).between?( 0x30, 0x37 )
              @input.consume
            else
              mse = MismatchedSet( nil )
              recover mse
              raise mse

            end



          end
        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 124 )


        end

        # lexer rule unicode_escape! (UNICODE_ESCAPE)
        # (in BELScript_v1.g)
        def unicode_escape!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 125 )


        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 420:9: '\\\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
          match( 0x5c )
          match( 0x75 )

          hex_digit!


          hex_digit!


          hex_digit!


          hex_digit!


        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 125 )


        end

        # lexer rule hex_digit! (HEX_DIGIT)
        # (in BELScript_v1.g)
        def hex_digit!
          # -> uncomment the next line to manually enable rule tracing
          # trace_in( __method__, 126 )


        # - - - - label initialization - - - -


          # - - - - main rule block - - - -
          # at line 
          if @input.peek( 1 ).between?( 0x30, 0x39 ) || @input.peek( 1 ).between?( 0x41, 0x46 ) || @input.peek( 1 ).between?( 0x61, 0x66 )
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end



        ensure
          # -> uncomment the next line to manually enable rule tracing
          # trace_out( __method__, 126 )


        end

        # main rule used to study the input at the current position,
        # and choose the proper lexer rule to call in order to
        # fetch the next token
        #
        # usually, you don't make direct calls to this method,
        # but instead use the next_token method, which will
        # build and emit the actual next token
        def token!
          # at line 1:8: ( T__64 | T__65 | T__66 | T__67 | T__68 | T__69 | T__70 | T__71 | T__72 | T__73 | T__74 | T__75 | T__76 | T__77 | T__78 | T__79 | T__80 | T__81 | T__82 | T__83 | T__84 | T__85 | T__86 | T__87 | T__88 | T__89 | T__90 | T__91 | T__92 | T__93 | T__94 | T__95 | T__96 | T__97 | T__98 | T__99 | T__100 | T__101 | T__102 | T__103 | T__104 | T__105 | T__106 | T__107 | T__108 | T__109 | T__110 | T__111 | T__112 | T__113 | T__114 | T__115 | T__116 | T__117 | T__118 | T__119 | T__120 | T__121 | T__122 | T__123 | T__124 | T__125 | T__126 | T__127 | T__128 | T__129 | T__130 | T__131 | T__132 | T__133 | T__134 | T__135 | T__136 | T__137 | T__138 | T__139 | T__140 | T__141 | T__142 | T__143 | T__144 | T__145 | T__146 | T__147 | T__148 | T__149 | T__150 | DOCUMENT_COMMENT | STATEMENT_COMMENT | IDENT_LIST | VALUE_LIST | QUOTED_VALUE | LP | RP | EQ | COLON | COMMA | NEWLINE | WS | KWRD_ANNO | KWRD_AS | KWRD_AUTHORS | KWRD_CONTACTINFO | KWRD_COPYRIGHT | KWRD_DFLT | KWRD_DEFINE | KWRD_DESC | KWRD_DISCLAIMER | KWRD_DOCUMENT | KWRD_LICENSES | KWRD_LIST | KWRD_NAME | KWRD_NS | KWRD_PATTERN | KWRD_SET | KWRD_STMT_GROUP | KWRD_UNSET | KWRD_URL | KWRD_VERSION | OBJECT_IDENT )
          alt_15 = 120
          alt_15 = @dfa15.predict( @input )
          case alt_15
          when 1
            # at line 1:10: T__64
            t__64!


          when 2
            # at line 1:16: T__65
            t__65!


          when 3
            # at line 1:22: T__66
            t__66!


          when 4
            # at line 1:28: T__67
            t__67!


          when 5
            # at line 1:34: T__68
            t__68!


          when 6
            # at line 1:40: T__69
            t__69!


          when 7
            # at line 1:46: T__70
            t__70!


          when 8
            # at line 1:52: T__71
            t__71!


          when 9
            # at line 1:58: T__72
            t__72!


          when 10
            # at line 1:64: T__73
            t__73!


          when 11
            # at line 1:70: T__74
            t__74!


          when 12
            # at line 1:76: T__75
            t__75!


          when 13
            # at line 1:82: T__76
            t__76!


          when 14
            # at line 1:88: T__77
            t__77!


          when 15
            # at line 1:94: T__78
            t__78!


          when 16
            # at line 1:100: T__79
            t__79!


          when 17
            # at line 1:106: T__80
            t__80!


          when 18
            # at line 1:112: T__81
            t__81!


          when 19
            # at line 1:118: T__82
            t__82!


          when 20
            # at line 1:124: T__83
            t__83!


          when 21
            # at line 1:130: T__84
            t__84!


          when 22
            # at line 1:136: T__85
            t__85!


          when 23
            # at line 1:142: T__86
            t__86!


          when 24
            # at line 1:148: T__87
            t__87!


          when 25
            # at line 1:154: T__88
            t__88!


          when 26
            # at line 1:160: T__89
            t__89!


          when 27
            # at line 1:166: T__90
            t__90!


          when 28
            # at line 1:172: T__91
            t__91!


          when 29
            # at line 1:178: T__92
            t__92!


          when 30
            # at line 1:184: T__93
            t__93!


          when 31
            # at line 1:190: T__94
            t__94!


          when 32
            # at line 1:196: T__95
            t__95!


          when 33
            # at line 1:202: T__96
            t__96!


          when 34
            # at line 1:208: T__97
            t__97!


          when 35
            # at line 1:214: T__98
            t__98!


          when 36
            # at line 1:220: T__99
            t__99!


          when 37
            # at line 1:226: T__100
            t__100!


          when 38
            # at line 1:233: T__101
            t__101!


          when 39
            # at line 1:240: T__102
            t__102!


          when 40
            # at line 1:247: T__103
            t__103!


          when 41
            # at line 1:254: T__104
            t__104!


          when 42
            # at line 1:261: T__105
            t__105!


          when 43
            # at line 1:268: T__106
            t__106!


          when 44
            # at line 1:275: T__107
            t__107!


          when 45
            # at line 1:282: T__108
            t__108!


          when 46
            # at line 1:289: T__109
            t__109!


          when 47
            # at line 1:296: T__110
            t__110!


          when 48
            # at line 1:303: T__111
            t__111!


          when 49
            # at line 1:310: T__112
            t__112!


          when 50
            # at line 1:317: T__113
            t__113!


          when 51
            # at line 1:324: T__114
            t__114!


          when 52
            # at line 1:331: T__115
            t__115!


          when 53
            # at line 1:338: T__116
            t__116!


          when 54
            # at line 1:345: T__117
            t__117!


          when 55
            # at line 1:352: T__118
            t__118!


          when 56
            # at line 1:359: T__119
            t__119!


          when 57
            # at line 1:366: T__120
            t__120!


          when 58
            # at line 1:373: T__121
            t__121!


          when 59
            # at line 1:380: T__122
            t__122!


          when 60
            # at line 1:387: T__123
            t__123!


          when 61
            # at line 1:394: T__124
            t__124!


          when 62
            # at line 1:401: T__125
            t__125!


          when 63
            # at line 1:408: T__126
            t__126!


          when 64
            # at line 1:415: T__127
            t__127!


          when 65
            # at line 1:422: T__128
            t__128!


          when 66
            # at line 1:429: T__129
            t__129!


          when 67
            # at line 1:436: T__130
            t__130!


          when 68
            # at line 1:443: T__131
            t__131!


          when 69
            # at line 1:450: T__132
            t__132!


          when 70
            # at line 1:457: T__133
            t__133!


          when 71
            # at line 1:464: T__134
            t__134!


          when 72
            # at line 1:471: T__135
            t__135!


          when 73
            # at line 1:478: T__136
            t__136!


          when 74
            # at line 1:485: T__137
            t__137!


          when 75
            # at line 1:492: T__138
            t__138!


          when 76
            # at line 1:499: T__139
            t__139!


          when 77
            # at line 1:506: T__140
            t__140!


          when 78
            # at line 1:513: T__141
            t__141!


          when 79
            # at line 1:520: T__142
            t__142!


          when 80
            # at line 1:527: T__143
            t__143!


          when 81
            # at line 1:534: T__144
            t__144!


          when 82
            # at line 1:541: T__145
            t__145!


          when 83
            # at line 1:548: T__146
            t__146!


          when 84
            # at line 1:555: T__147
            t__147!


          when 85
            # at line 1:562: T__148
            t__148!


          when 86
            # at line 1:569: T__149
            t__149!


          when 87
            # at line 1:576: T__150
            t__150!


          when 88
            # at line 1:583: DOCUMENT_COMMENT
            document_comment!


          when 89
            # at line 1:600: STATEMENT_COMMENT
            statement_comment!


          when 90
            # at line 1:618: IDENT_LIST
            ident_list!


          when 91
            # at line 1:629: VALUE_LIST
            value_list!


          when 92
            # at line 1:640: QUOTED_VALUE
            quoted_value!


          when 93
            # at line 1:653: LP
            lp!


          when 94
            # at line 1:656: RP
            rp!


          when 95
            # at line 1:659: EQ
            eq!


          when 96
            # at line 1:662: COLON
            colon!


          when 97
            # at line 1:668: COMMA
            comma!


          when 98
            # at line 1:674: NEWLINE
            newline!


          when 99
            # at line 1:682: WS
            ws!


          when 100
            # at line 1:685: KWRD_ANNO
            kwrd_anno!


          when 101
            # at line 1:695: KWRD_AS
            kwrd_as!


          when 102
            # at line 1:703: KWRD_AUTHORS
            kwrd_authors!


          when 103
            # at line 1:716: KWRD_CONTACTINFO
            kwrd_contactinfo!


          when 104
            # at line 1:733: KWRD_COPYRIGHT
            kwrd_copyright!


          when 105
            # at line 1:748: KWRD_DFLT
            kwrd_dflt!


          when 106
            # at line 1:758: KWRD_DEFINE
            kwrd_define!


          when 107
            # at line 1:770: KWRD_DESC
            kwrd_desc!


          when 108
            # at line 1:780: KWRD_DISCLAIMER
            kwrd_disclaimer!


          when 109
            # at line 1:796: KWRD_DOCUMENT
            kwrd_document!


          when 110
            # at line 1:810: KWRD_LICENSES
            kwrd_licenses!


          when 111
            # at line 1:824: KWRD_LIST
            kwrd_list!


          when 112
            # at line 1:834: KWRD_NAME
            kwrd_name!


          when 113
            # at line 1:844: KWRD_NS
            kwrd_ns!


          when 114
            # at line 1:852: KWRD_PATTERN
            kwrd_pattern!


          when 115
            # at line 1:865: KWRD_SET
            kwrd_set!


          when 116
            # at line 1:874: KWRD_STMT_GROUP
            kwrd_stmt_group!


          when 117
            # at line 1:890: KWRD_UNSET
            kwrd_unset!


          when 118
            # at line 1:901: KWRD_URL
            kwrd_url!


          when 119
            # at line 1:910: KWRD_VERSION
            kwrd_version!


          when 120
            # at line 1:923: OBJECT_IDENT
            object_ident!


          end
        end


        # - - - - - - - - - - DFA definitions - - - - - - - - - - -
        class DFA15 < ANTLR3::DFA
          EOT = unpack( 2, -1, 1, 46, 1, 49, 1, -1, 1, 57, 4, 41, 1, 73, 4, 
                        41, 1, 82, 2, 41, 1, 93, 1, 99, 2, 41, 7, -1, 2, 110, 
                        1, -1, 9, 41, 9, -1, 3, 41, 1, 119, 1, 41, 1, 119, 1, 
                        41, 1, -1, 1, 41, 1, 122, 13, 41, 1, -1, 8, 41, 1, -1, 
                        10, 41, 1, -1, 5, 41, 1, -1, 8, 41, 3, -1, 4, 41, 1, 
                        180, 3, 41, 1, -1, 2, 41, 1, -1, 1, 188, 7, 41, 1, 197, 
                        5, 41, 1, 205, 1, 41, 1, 208, 2, 41, 1, 212, 1, 214, 
                        10, 41, 1, 226, 8, 41, 1, 237, 1, 238, 1, 239, 1, 242, 
                        7, 41, 2, -1, 1, 41, 1, 253, 2, 41, 1, -1, 7, 41, 1, 
                        -1, 2, 41, 1, 266, 5, 41, 1, -1, 7, 41, 1, -1, 2, 41, 
                        1, -1, 3, 41, 1, -1, 1, 41, 1, -1, 1, 286, 1, 287, 4, 
                        41, 1, 293, 1, 41, 1, 296, 2, 41, 1, -1, 1, 300, 1, 
                        301, 6, 41, 1, 309, 1, 41, 3, -1, 2, 41, 1, -1, 1, 313, 
                        1, 41, 1, 315, 4, 41, 2, -1, 1, 41, 1, -1, 12, 41, 1, 
                        -1, 19, 41, 2, -1, 5, 41, 1, -1, 2, 41, 1, -1, 3, 41, 
                        2, -1, 7, 41, 1, -1, 3, 41, 1, -1, 1, 41, 1, -1, 1, 
                        375, 1, 41, 1, 380, 1, 41, 1, 382, 20, 41, 1, 403, 4, 
                        41, 1, 408, 28, 41, 1, -1, 4, 41, 1, -1, 1, 41, 1, -1, 
                        5, 41, 1, 448, 7, 41, 1, 457, 5, 41, 1, 463, 1, -1, 
                        4, 41, 1, -1, 13, 41, 1, 481, 19, 41, 1, 502, 1, 503, 
                        4, 41, 1, -1, 8, 41, 1, -1, 5, 41, 1, -1, 3, 41, 1, 
                        525, 6, 41, 1, 532, 6, 41, 1, -1, 3, 41, 1, 542, 5, 
                        41, 1, 548, 10, 41, 2, -1, 1, 560, 1, 561, 10, 41, 1, 
                        573, 1, 41, 1, 575, 1, 576, 5, 41, 1, -1, 3, 41, 1, 
                        586, 1, 587, 1, 41, 1, -1, 3, 41, 1, 592, 1, 41, 1, 
                        594, 3, 41, 1, -1, 4, 41, 1, 602, 1, -1, 11, 41, 2, 
                        -1, 1, 614, 10, 41, 1, -1, 1, 41, 2, -1, 4, 41, 1, 630, 
                        3, 41, 1, 634, 2, -1, 4, 41, 1, -1, 1, 41, 1, -1, 7, 
                        41, 1, -1, 10, 41, 1, 657, 1, -1, 1, 658, 9, 41, 1, 
                        668, 1, 669, 1, 670, 2, 41, 1, -1, 3, 41, 1, -1, 4, 
                        41, 1, 680, 17, 41, 2, -1, 1, 41, 1, 699, 7, 41, 3, 
                        -1, 4, 41, 1, 712, 4, 41, 1, -1, 8, 41, 1, 725, 1, 726, 
                        1, 727, 3, 41, 1, 731, 3, 41, 1, -1, 2, 41, 1, 737, 
                        6, 41, 1, 744, 1, 41, 1, 746, 1, -1, 12, 41, 3, -1, 
                        1, 41, 1, 760, 1, 41, 1, -1, 1, 762, 3, 41, 1, 766, 
                        1, -1, 6, 41, 1, -1, 1, 41, 1, -1, 1, 774, 12, 41, 1, 
                        -1, 1, 41, 1, -1, 3, 41, 1, -1, 7, 41, 1, -1, 11, 41, 
                        1, 809, 6, 41, 1, 816, 3, 41, 1, 820, 7, 41, 1, 828, 
                        3, 41, 1, -1, 2, 41, 1, 834, 1, 835, 1, 41, 1, 837, 
                        1, -1, 1, 41, 1, 839, 1, 840, 1, -1, 1, 841, 1, 842, 
                        1, 41, 1, 844, 3, 41, 1, -1, 4, 41, 1, 852, 2, -1, 1, 
                        41, 1, -1, 1, 854, 4, -1, 1, 41, 1, -1, 4, 41, 1, 860, 
                        2, 41, 1, -1, 1, 41, 1, -1, 1, 864, 1, 865, 1, 866, 
                        1, 41, 1, 868, 1, -1, 3, 41, 3, -1, 1, 41, 1, -1, 1, 
                        873, 1, 41, 1, 875, 1, 41, 1, -1, 1, 41, 1, -1, 1, 878, 
                        1, 41, 1, -1, 1, 880, 1, -1 )
          EOF = unpack( 881, -1 )
          MIN = unpack( 1, 9, 1, 45, 2, 62, 1, -1, 1, 48, 1, 105, 1, 79, 1, 
                        69, 1, 117, 1, 48, 1, 97, 1, 110, 1, 105, 1, 73, 1, 
                        48, 1, 65, 1, 114, 2, 48, 1, 69, 1, 108, 2, -1, 1, 34, 
                        4, -1, 2, 9, 1, -1, 1, 78, 1, 79, 1, 69, 1, 73, 2, 65, 
                        1, 69, 1, 78, 1, 69, 9, -1, 1, 117, 1, 116, 1, 78, 1, 
                        48, 1, 78, 1, 48, 1, 84, 1, -1, 1, 111, 1, 48, 1, 116, 
                        1, 108, 1, 97, 2, 78, 1, 70, 1, 83, 1, 70, 1, 83, 1, 
                        67, 1, 115, 1, 110, 1, 112, 1, -1, 1, 115, 1, 99, 1, 
                        65, 1, 110, 2, 67, 1, 99, 1, 108, 1, -1, 1, 103, 1, 
                        77, 1, 116, 1, 84, 1, 112, 2, 111, 1, 115, 1, 111, 1, 
                        84, 1, -1, 1, 116, 1, 97, 1, 98, 1, 97, 1, 110, 1, -1, 
                        1, 84, 1, 98, 1, 84, 1, 65, 2, 111, 1, 97, 1, 99, 1, 
                        44, 2, -1, 1, 83, 1, 76, 1, 82, 1, 110, 1, 48, 1, 108, 
                        1, 79, 1, 111, 1, -1, 1, 72, 1, 108, 1, -1, 1, 48, 1, 
                        115, 1, 108, 2, 112, 1, 84, 1, 89, 1, 114, 1, 48, 1, 
                        65, 1, 67, 1, 101, 1, 67, 1, 85, 1, 48, 1, 101, 1, 48, 
                        1, 67, 1, 114, 2, 48, 1, 84, 1, 69, 1, 84, 1, 114, 1, 
                        101, 1, 97, 1, 69, 1, 104, 2, 84, 1, 48, 1, 115, 1, 
                        100, 1, 105, 1, 100, 1, 101, 1, 99, 1, 111, 1, 65, 4, 
                        48, 1, 102, 1, 84, 1, 99, 1, 114, 2, 110, 1, 114, 1, 
                        32, 1, -1, 1, 69, 1, 48, 1, 83, 1, 100, 1, -1, 1, 111, 
                        1, 84, 1, 99, 1, 79, 1, 111, 1, 97, 1, 108, 1, -1, 1, 
                        101, 1, 83, 1, 48, 1, 108, 1, 65, 1, 82, 1, 101, 1, 
                        97, 1, -1, 1, 85, 1, 78, 1, 82, 1, 99, 1, 76, 1, 77, 
                        1, 111, 1, -1, 1, 65, 1, 111, 1, -1, 1, 111, 2, 101, 
                        1, -1, 1, 115, 1, -1, 2, 48, 1, 78, 1, 111, 1, 99, 1, 
                        116, 1, 48, 1, 111, 1, 48, 1, 69, 1, 105, 1, -1, 2, 
                        48, 1, 116, 1, 117, 1, 110, 1, 101, 1, 76, 1, 116, 1, 
                        48, 1, 98, 3, -1, 1, 114, 1, 116, 1, -1, 1, 48, 1, 69, 
                        1, 48, 1, 116, 1, 115, 1, 99, 1, 105, 1, 44, 1, -1, 
                        1, 84, 1, -1, 1, 73, 1, 97, 1, 103, 1, 65, 1, 105, 1, 
                        82, 1, 103, 1, 114, 1, 121, 1, 115, 1, 101, 1, 114, 
                        1, -1, 1, 101, 1, 115, 1, 67, 1, 73, 1, 97, 1, 100, 
                        1, 76, 1, 69, 1, 73, 1, 116, 1, 65, 1, 69, 1, 110, 1, 
                        98, 1, 117, 2, 109, 1, 97, 1, 101, 2, -1, 1, 83, 1, 
                        82, 1, 117, 1, 105, 1, 80, 1, -1, 2, 108, 1, -1, 1, 
                        82, 1, 100, 1, 104, 2, -1, 1, 105, 1, 99, 1, 111, 2, 
                        105, 1, 97, 1, 121, 1, -1, 1, 117, 1, 111, 1, 105, 1, 
                        -1, 1, 77, 1, -1, 1, 48, 1, 99, 1, 48, 1, 112, 1, 48, 
                        1, 79, 1, 110, 1, 111, 1, 84, 1, 97, 1, 83, 1, 105, 
                        1, 107, 1, 116, 1, 78, 1, 99, 1, 114, 1, 111, 1, 120, 
                        1, 105, 1, 84, 1, 71, 1, 115, 1, 97, 1, 84, 1, 48, 1, 
                        80, 1, 108, 1, 73, 1, 78, 1, 48, 1, 117, 1, 110, 1, 
                        112, 1, 98, 1, 115, 1, 65, 1, 69, 1, 78, 1, 108, 1, 
                        118, 1, 65, 2, 111, 1, 78, 2, 97, 1, 118, 1, 116, 1, 
                        115, 1, 110, 1, 109, 1, 110, 1, 111, 1, 108, 1, 110, 
                        1, 99, 1, 116, 1, 69, 1, -1, 1, 114, 1, 97, 1, 111, 
                        1, 116, 1, -1, 1, 116, 1, -1, 1, 78, 1, 99, 1, 117, 
                        1, 73, 1, 116, 1, 48, 1, 99, 1, 101, 1, 105, 1, 111, 
                        1, 114, 1, 102, 1, 110, 1, 48, 1, 116, 1, 73, 1, 72, 
                        1, 101, 1, 116, 1, 48, 1, -1, 1, 84, 1, 121, 1, 77, 
                        1, 84, 1, -1, 1, 110, 1, 100, 1, 111, 2, 101, 1, 99, 
                        1, 83, 1, 65, 1, 97, 1, 101, 1, 67, 2, 103, 1, 48, 1, 
                        115, 1, 116, 1, 101, 1, 115, 1, 116, 1, 65, 1, 105, 
                        1, 116, 1, 110, 1, 97, 1, 100, 1, 101, 1, 117, 1, 78, 
                        1, 105, 1, 116, 1, 99, 1, 114, 1, 105, 2, 48, 1, 101, 
                        1, 115, 1, 79, 1, 105, 1, -1, 1, 97, 1, 114, 1, 99, 
                        1, 67, 1, 101, 1, 97, 1, 101, 1, 98, 1, -1, 1, 101, 
                        1, 78, 1, 84, 1, 115, 1, 105, 1, -1, 1, 73, 1, 68, 1, 
                        69, 1, 48, 1, 100, 1, 65, 1, 110, 1, 114, 1, 115, 1, 
                        116, 1, 48, 1, 65, 1, 114, 1, 67, 1, 69, 1, 111, 1, 
                        121, 1, -1, 1, 101, 1, 97, 1, 67, 1, 48, 1, 105, 1, 
                        98, 1, 111, 1, 116, 1, 115, 1, 48, 1, 116, 1, 97, 1, 
                        115, 1, 116, 1, 84, 1, 98, 1, 101, 1, 97, 1, 116, 1, 
                        111, 2, -1, 2, 48, 1, 78, 1, 111, 1, 108, 1, 70, 1, 
                        65, 1, 104, 1, 116, 1, 99, 1, 65, 1, 117, 1, 48, 1, 
                        70, 2, 48, 1, 111, 1, 79, 1, 101, 1, 110, 1, 82, 1, 
                        -1, 1, 97, 1, 99, 1, 101, 2, 48, 1, 105, 1, -1, 1, 98, 
                        1, 65, 1, 111, 1, 48, 1, 117, 1, 48, 1, 65, 1, 115, 
                        1, 111, 1, -1, 1, 99, 1, 117, 1, 100, 1, 105, 1, 48, 
                        1, -1, 1, 105, 1, 110, 1, 115, 1, 105, 1, 95, 1, 101, 
                        1, 116, 1, 100, 1, 116, 1, 65, 1, 110, 2, -1, 1, 48, 
                        1, 110, 1, 80, 1, 111, 1, 99, 1, 97, 1, 105, 1, 101, 
                        1, 99, 1, 110, 1, 98, 1, -1, 1, 79, 2, -1, 1, 110, 1, 
                        78, 2, 99, 1, 48, 1, 110, 1, 116, 1, 110, 1, 48, 2, 
                        -1, 1, 118, 1, 117, 1, 99, 1, 114, 1, -1, 1, 115, 1, 
                        -1, 1, 99, 1, 101, 1, 114, 1, 66, 1, 110, 1, 105, 1, 
                        110, 1, -1, 1, 111, 1, 99, 1, 79, 1, 111, 1, 71, 1, 
                        100, 1, 105, 1, 84, 1, 105, 1, 99, 1, 48, 1, -1, 1, 
                        48, 2, 114, 1, 116, 1, 110, 1, 111, 1, 69, 1, 116, 1, 
                        100, 1, 117, 3, 48, 2, 114, 1, -1, 1, 99, 1, 105, 1, 
                        116, 1, -1, 1, 105, 1, 110, 1, 116, 1, 114, 1, 48, 1, 
                        116, 1, 65, 1, 114, 1, 105, 1, 100, 1, 102, 1, 103, 
                        1, 110, 1, 101, 1, 102, 1, 110, 1, 82, 1, 84, 3, 111, 
                        1, 116, 2, -1, 1, 111, 1, 48, 1, 105, 1, 103, 1, 110, 
                        1, 120, 1, 105, 1, 97, 1, 110, 3, -1, 3, 101, 1, 118, 
                        1, 48, 1, 116, 1, 100, 1, 105, 1, 101, 1, -1, 1, 105, 
                        1, 99, 1, 101, 1, 111, 1, 97, 1, 105, 1, 83, 1, 65, 
                        3, 48, 1, 79, 1, 111, 1, 110, 1, 48, 1, 110, 1, 105, 
                        1, 99, 1, -1, 1, 118, 1, 101, 1, 48, 1, 112, 1, 118, 
                        1, 110, 1, 100, 2, 97, 1, 48, 1, 105, 1, 48, 1, -1, 
                        1, 121, 1, 97, 1, 118, 1, 108, 1, 118, 1, 116, 1, 108, 
                        1, 109, 1, 110, 1, 99, 1, 116, 1, 99, 3, -1, 1, 85, 
                        1, 48, 1, 97, 1, -1, 1, 48, 1, 118, 1, 101, 1, 105, 
                        1, 48, 1, -1, 1, 114, 1, 105, 1, 99, 1, 97, 2, 115, 
                        1, -1, 1, 116, 1, -1, 1, 48, 1, 110, 1, 105, 1, 97, 
                        2, 105, 2, 97, 1, 99, 1, 97, 1, 101, 1, 116, 1, 80, 
                        1, -1, 1, 108, 1, -1, 1, 105, 1, 115, 1, 116, 1, -1, 
                        1, 101, 1, 116, 1, 101, 1, 110, 2, 101, 1, 121, 1, -1, 
                        1, 99, 3, 116, 1, 118, 1, 116, 1, 114, 1, 101, 1, 116, 
                        1, 112, 1, 105, 1, 48, 1, 65, 1, 116, 1, 115, 1, 121, 
                        1, 115, 1, 121, 1, 48, 1, 99, 2, 115, 1, 48, 1, 101, 
                        1, 121, 1, 105, 1, 121, 2, 105, 1, 107, 1, 48, 1, 105, 
                        1, 79, 1, 118, 1, -1, 1, 99, 1, 121, 2, 48, 1, 115, 
                        1, 48, 1, -1, 1, 101, 2, 48, 1, -1, 2, 48, 1, 111, 1, 
                        48, 1, 116, 1, 111, 1, 101, 1, -1, 1, 111, 1, 102, 1, 
                        105, 1, 116, 1, 48, 2, -1, 1, 105, 1, -1, 1, 48, 4, 
                        -1, 1, 110, 1, -1, 1, 121, 1, 110, 1, 114, 1, 110, 1, 
                        48, 1, 116, 1, 105, 1, -1, 1, 111, 1, -1, 3, 48, 1, 
                        70, 1, 48, 1, -1, 1, 121, 1, 118, 1, 110, 3, -1, 1, 
                        111, 1, -1, 1, 48, 1, 105, 1, 48, 1, 114, 1, -1, 1, 
                        116, 1, -1, 1, 48, 1, 121, 1, -1, 1, 48, 1, -1 )
          MAX = unpack( 1, 123, 1, 124, 1, 62, 1, 124, 1, -1, 1, 122, 1, 112, 
                        2, 111, 1, 117, 1, 122, 1, 97, 1, 115, 2, 105, 1, 122, 
                        1, 101, 1, 114, 2, 122, 1, 117, 1, 115, 2, -1, 1, 125, 
                        4, -1, 2, 92, 1, -1, 1, 117, 2, 111, 1, 105, 2, 97, 
                        1, 116, 1, 114, 1, 101, 9, -1, 1, 117, 1, 116, 1, 110, 
                        1, 122, 1, 110, 1, 122, 1, 116, 1, -1, 1, 111, 1, 122, 
                        1, 117, 1, 108, 1, 97, 2, 112, 4, 115, 1, 99, 1, 115, 
                        1, 110, 1, 112, 1, -1, 1, 115, 1, 99, 1, 65, 1, 110, 
                        2, 115, 1, 99, 1, 108, 1, -1, 1, 103, 1, 109, 2, 116, 
                        1, 112, 2, 111, 1, 115, 1, 111, 1, 116, 1, -1, 1, 116, 
                        1, 97, 1, 98, 1, 97, 1, 110, 1, -1, 1, 116, 1, 114, 
                        1, 116, 1, 97, 2, 111, 1, 117, 1, 99, 1, 125, 2, -1, 
                        1, 115, 1, 108, 1, 114, 1, 110, 1, 122, 1, 108, 2, 111, 
                        1, -1, 1, 104, 1, 109, 1, -1, 1, 122, 1, 115, 1, 108, 
                        2, 112, 1, 116, 1, 121, 1, 114, 1, 122, 1, 105, 1, 99, 
                        1, 101, 1, 99, 1, 117, 1, 122, 1, 101, 1, 122, 1, 77, 
                        1, 114, 2, 122, 1, 116, 1, 101, 1, 116, 1, 114, 1, 101, 
                        1, 97, 1, 101, 1, 104, 2, 116, 1, 122, 1, 115, 1, 100, 
                        1, 105, 1, 116, 1, 101, 1, 99, 1, 111, 1, 65, 4, 122, 
                        1, 102, 1, 116, 1, 99, 1, 114, 2, 110, 1, 114, 1, 125, 
                        1, -1, 1, 101, 1, 122, 1, 115, 1, 100, 1, -1, 1, 111, 
                        1, 116, 1, 99, 2, 111, 1, 97, 1, 108, 1, -1, 1, 101, 
                        1, 83, 1, 122, 1, 111, 1, 97, 1, 114, 1, 101, 1, 97, 
                        1, -1, 1, 117, 1, 110, 1, 114, 1, 99, 1, 108, 1, 109, 
                        1, 111, 1, -1, 1, 65, 1, 111, 1, -1, 1, 111, 2, 101, 
                        1, -1, 1, 115, 1, -1, 2, 122, 1, 110, 1, 111, 1, 99, 
                        1, 116, 1, 122, 1, 111, 1, 122, 1, 101, 1, 105, 1, -1, 
                        2, 122, 1, 116, 1, 117, 1, 110, 1, 101, 1, 76, 1, 116, 
                        1, 122, 1, 98, 3, -1, 1, 114, 1, 116, 1, -1, 1, 122, 
                        1, 101, 1, 122, 1, 116, 1, 115, 1, 99, 1, 105, 1, 125, 
                        1, -1, 1, 116, 1, -1, 1, 105, 1, 97, 1, 103, 1, 97, 
                        1, 105, 1, 114, 1, 103, 1, 114, 1, 121, 1, 115, 1, 117, 
                        1, 114, 1, -1, 1, 101, 1, 115, 1, 99, 1, 105, 1, 97, 
                        1, 100, 1, 108, 1, 101, 1, 105, 1, 116, 1, 97, 1, 101, 
                        1, 110, 1, 98, 1, 117, 2, 109, 1, 97, 1, 101, 2, -1, 
                        1, 115, 1, 82, 1, 117, 1, 105, 1, 112, 1, -1, 2, 108, 
                        1, -1, 1, 114, 1, 100, 1, 104, 2, -1, 1, 105, 1, 99, 
                        1, 111, 3, 105, 1, 121, 1, -1, 1, 117, 1, 111, 1, 105, 
                        1, -1, 1, 109, 1, -1, 1, 122, 1, 112, 1, 122, 1, 112, 
                        1, 122, 1, 111, 1, 110, 1, 111, 1, 116, 1, 97, 1, 115, 
                        1, 105, 1, 107, 1, 116, 1, 78, 1, 99, 1, 114, 1, 111, 
                        1, 120, 1, 105, 1, 116, 1, 103, 1, 115, 1, 97, 1, 116, 
                        1, 122, 1, 112, 1, 108, 1, 105, 1, 110, 1, 122, 1, 117, 
                        1, 110, 1, 112, 1, 98, 1, 115, 1, 65, 1, 101, 1, 78, 
                        1, 108, 1, 118, 1, 97, 2, 111, 1, 110, 2, 97, 1, 118, 
                        1, 116, 1, 115, 1, 110, 1, 109, 1, 110, 1, 111, 1, 108, 
                        1, 110, 1, 99, 1, 116, 1, 101, 1, -1, 1, 114, 2, 111, 
                        1, 116, 1, -1, 1, 116, 1, -1, 1, 110, 1, 99, 1, 117, 
                        1, 105, 1, 116, 1, 122, 1, 99, 1, 101, 1, 105, 1, 111, 
                        1, 114, 1, 102, 1, 110, 1, 122, 1, 116, 1, 105, 1, 104, 
                        1, 101, 1, 116, 1, 122, 1, -1, 1, 116, 1, 121, 1, 109, 
                        1, 116, 1, -1, 1, 110, 1, 100, 1, 111, 2, 101, 1, 99, 
                        1, 115, 1, 65, 1, 97, 1, 101, 1, 99, 2, 103, 1, 122, 
                        1, 115, 1, 116, 1, 101, 1, 115, 1, 116, 1, 77, 1, 105, 
                        1, 116, 1, 110, 1, 97, 1, 100, 1, 101, 1, 117, 1, 110, 
                        1, 105, 1, 116, 1, 99, 1, 114, 1, 105, 2, 122, 1, 101, 
                        1, 115, 1, 111, 1, 105, 1, -1, 1, 97, 1, 114, 1, 99, 
                        1, 67, 1, 101, 1, 97, 1, 101, 1, 98, 1, -1, 1, 101, 
                        1, 110, 1, 116, 1, 115, 1, 105, 1, -1, 1, 105, 1, 73, 
                        1, 101, 1, 122, 1, 100, 1, 65, 1, 110, 1, 114, 1, 115, 
                        1, 116, 1, 122, 1, 65, 1, 114, 1, 67, 1, 101, 1, 111, 
                        1, 121, 1, -1, 1, 101, 1, 97, 1, 67, 1, 122, 1, 105, 
                        1, 98, 1, 111, 1, 116, 1, 115, 1, 122, 1, 116, 1, 97, 
                        1, 115, 2, 116, 1, 112, 1, 101, 1, 97, 1, 116, 1, 111, 
                        2, -1, 2, 122, 1, 110, 1, 111, 1, 108, 1, 70, 1, 65, 
                        1, 104, 1, 116, 1, 99, 1, 65, 1, 117, 1, 122, 1, 102, 
                        2, 122, 2, 111, 1, 101, 1, 110, 1, 114, 1, -1, 1, 97, 
                        1, 99, 1, 101, 2, 122, 1, 105, 1, -1, 1, 98, 1, 65, 
                        1, 111, 1, 122, 1, 117, 1, 122, 1, 65, 1, 115, 1, 111, 
                        1, -1, 1, 99, 1, 117, 1, 100, 1, 105, 1, 122, 1, -1, 
                        1, 105, 1, 110, 1, 115, 1, 105, 1, 95, 1, 101, 1, 116, 
                        1, 100, 1, 116, 1, 65, 1, 110, 2, -1, 1, 122, 1, 110, 
                        1, 80, 1, 111, 1, 99, 1, 97, 1, 105, 1, 101, 1, 99, 
                        1, 110, 1, 98, 1, -1, 1, 111, 2, -1, 2, 110, 2, 99, 
                        1, 122, 1, 110, 1, 116, 1, 110, 1, 122, 2, -1, 1, 118, 
                        1, 117, 1, 99, 1, 114, 1, -1, 1, 115, 1, -1, 1, 99, 
                        1, 101, 1, 114, 1, 66, 1, 110, 1, 105, 1, 110, 1, -1, 
                        1, 111, 1, 99, 1, 79, 1, 111, 1, 103, 1, 100, 1, 105, 
                        1, 84, 1, 105, 1, 99, 1, 122, 1, -1, 1, 122, 2, 114, 
                        1, 116, 1, 110, 1, 111, 1, 69, 1, 116, 1, 100, 1, 117, 
                        3, 122, 2, 114, 1, -1, 1, 99, 1, 105, 1, 116, 1, -1, 
                        1, 105, 1, 110, 1, 116, 1, 114, 1, 122, 1, 116, 1, 65, 
                        1, 114, 1, 105, 1, 100, 1, 102, 1, 103, 1, 110, 1, 101, 
                        1, 102, 1, 110, 1, 114, 1, 84, 3, 111, 1, 116, 2, -1, 
                        1, 111, 1, 122, 1, 105, 1, 103, 1, 110, 1, 120, 1, 105, 
                        1, 97, 1, 110, 3, -1, 3, 101, 1, 118, 1, 122, 1, 116, 
                        1, 100, 1, 105, 1, 101, 1, -1, 1, 105, 1, 99, 1, 101, 
                        1, 111, 1, 97, 1, 105, 1, 83, 1, 65, 3, 122, 2, 111, 
                        1, 110, 1, 122, 1, 110, 1, 105, 1, 99, 1, -1, 1, 118, 
                        1, 101, 1, 122, 1, 112, 1, 118, 1, 110, 1, 100, 2, 97, 
                        1, 122, 1, 105, 1, 122, 1, -1, 1, 121, 1, 97, 1, 118, 
                        1, 108, 1, 118, 1, 116, 1, 108, 1, 109, 1, 110, 1, 99, 
                        1, 116, 1, 99, 3, -1, 1, 117, 1, 122, 1, 97, 1, -1, 
                        1, 122, 1, 118, 1, 101, 1, 105, 1, 122, 1, -1, 1, 114, 
                        1, 105, 1, 99, 1, 97, 2, 115, 1, -1, 1, 116, 1, -1, 
                        1, 122, 1, 110, 1, 105, 1, 97, 2, 105, 2, 97, 1, 99, 
                        1, 97, 1, 101, 1, 116, 1, 112, 1, -1, 1, 108, 1, -1, 
                        1, 105, 1, 115, 1, 116, 1, -1, 1, 101, 1, 116, 1, 101, 
                        1, 110, 2, 101, 1, 121, 1, -1, 1, 99, 3, 116, 1, 118, 
                        1, 116, 1, 114, 1, 101, 1, 116, 1, 112, 1, 105, 1, 122, 
                        1, 65, 1, 116, 1, 115, 1, 121, 1, 115, 1, 121, 1, 122, 
                        1, 99, 2, 115, 1, 122, 1, 101, 1, 121, 1, 105, 1, 121, 
                        2, 105, 1, 107, 1, 122, 1, 105, 1, 79, 1, 118, 1, -1, 
                        1, 99, 1, 121, 2, 122, 1, 115, 1, 122, 1, -1, 1, 101, 
                        2, 122, 1, -1, 2, 122, 1, 111, 1, 122, 1, 116, 1, 111, 
                        1, 101, 1, -1, 1, 111, 1, 102, 1, 105, 1, 116, 1, 122, 
                        2, -1, 1, 105, 1, -1, 1, 122, 4, -1, 1, 110, 1, -1, 
                        1, 121, 1, 110, 1, 114, 1, 110, 1, 122, 1, 116, 1, 105, 
                        1, -1, 1, 111, 1, -1, 3, 122, 1, 70, 1, 122, 1, -1, 
                        1, 121, 1, 118, 1, 110, 3, -1, 1, 111, 1, -1, 1, 122, 
                        1, 105, 1, 122, 1, 114, 1, -1, 1, 116, 1, -1, 1, 122, 
                        1, 121, 1, -1, 1, 122, 1, -1 )
          ACCEPT = unpack( 4, -1, 1, 7, 17, -1, 1, 88, 1, 89, 1, -1, 1, 92, 
                           1, 93, 1, 94, 1, 97, 2, -1, 1, 99, 9, -1, 1, 120, 
                           1, 1, 1, 2, 1, 3, 1, 4, 1, 96, 1, 5, 1, 6, 1, 95, 
                           7, -1, 1, 8, 15, -1, 1, 34, 8, -1, 1, 47, 10, -1, 
                           1, 52, 5, -1, 1, 65, 9, -1, 1, 91, 1, 98, 8, -1, 
                           1, 101, 2, -1, 1, 15, 52, -1, 1, 90, 4, -1, 1, 10, 
                           7, -1, 1, 16, 8, -1, 1, 28, 7, -1, 1, 32, 2, -1, 
                           1, 36, 3, -1, 1, 43, 1, -1, 1, 44, 11, -1, 1, 55, 
                           10, -1, 1, 72, 1, 73, 1, 115, 2, -1, 1, 74, 8, -1, 
                           1, 90, 1, -1, 1, 118, 12, -1, 1, 21, 19, -1, 1, 46, 
                           1, 111, 5, -1, 1, 112, 2, -1, 1, 53, 3, -1, 1, 57, 
                           1, 59, 7, -1, 1, 69, 3, -1, 1, 77, 1, -1, 1, 78, 
                           59, -1, 1, 79, 4, -1, 1, 85, 1, -1, 1, 117, 20, -1, 
                           1, 106, 4, -1, 1, 33, 39, -1, 1, 102, 8, -1, 1, 23, 
                           5, -1, 1, 105, 17, -1, 1, 114, 20, -1, 1, 87, 1, 
                           119, 21, -1, 1, 109, 6, -1, 1, 110, 9, -1, 1, 61, 
                           5, -1, 1, 68, 11, -1, 1, 9, 1, 11, 11, -1, 1, 25, 
                           1, -1, 1, 104, 1, 27, 9, -1, 1, 40, 1, 42, 4, -1, 
                           1, 113, 1, -1, 1, 54, 7, -1, 1, 67, 11, -1, 1, 100, 
                           15, -1, 1, 108, 3, -1, 1, 41, 22, -1, 1, 86, 1, 12, 
                           9, -1, 1, 103, 1, 29, 1, 107, 9, -1, 1, 51, 18, -1, 
                           1, 14, 12, -1, 1, 38, 12, -1, 1, 71, 1, 75, 1, 76, 
                           3, -1, 1, 82, 5, -1, 1, 19, 6, -1, 1, 35, 1, -1, 
                           1, 39, 13, -1, 1, 80, 1, -1, 1, 83, 3, -1, 1, 18, 
                           7, -1, 1, 45, 34, -1, 1, 116, 6, -1, 1, 24, 3, -1, 
                           1, 37, 7, -1, 1, 63, 5, -1, 1, 13, 1, 17, 1, -1, 
                           1, 22, 1, -1, 1, 30, 1, 31, 1, 48, 1, 49, 1, -1, 
                           1, 56, 7, -1, 1, 84, 1, -1, 1, 26, 5, -1, 1, 66, 
                           3, -1, 1, 50, 1, 58, 1, 60, 1, -1, 1, 64, 4, -1, 
                           1, 70, 1, -1, 1, 20, 2, -1, 1, 62, 1, -1, 1, 81 )
          SPECIAL = unpack( 881, -1 )
          TRANSITION = [
            unpack( 1, 31, 1, 30, 1, -1, 1, 31, 1, 29, 18, -1, 1, 31, 1, -1, 
                    1, 25, 1, 22, 4, -1, 1, 26, 1, 27, 2, -1, 1, 28, 1, 1, 1, 
                    -1, 1, 23, 10, 41, 1, 2, 2, -1, 1, 3, 1, 4, 2, -1, 1, 32, 
                    1, 41, 1, 33, 1, 34, 7, 41, 1, 35, 1, 41, 1, 36, 1, 41, 
                    1, 37, 2, 41, 1, 38, 1, 41, 1, 39, 1, 40, 4, 41, 1, -1, 
                    1, 31, 2, -1, 1, 41, 1, -1, 1, 5, 1, 6, 1, 7, 1, 8, 1, 41, 
                    1, 9, 1, 10, 1, 11, 1, 12, 1, 41, 1, 13, 1, 14, 1, 15, 1, 
                    16, 1, 17, 1, 18, 1, 41, 1, 19, 1, 20, 1, 21, 1, 39, 1, 
                    40, 4, 41, 1, 24 ),
            unpack( 1, 42, 16, -1, 1, 43, 61, -1, 1, 44 ),
            unpack( 1, 45 ),
            unpack( 1, 47, 61, -1, 1, 48 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 13, 41, 1, 54, 4, 41, 1, 55, 1, 41, 1, 56, 
                     5, 41, 4, -1, 1, 41, 1, -1, 1, 41, 1, 50, 1, 51, 10, 41, 
                     1, 52, 4, 41, 1, 53, 1, 41, 1, 56, 5, 41 ),
            unpack( 1, 58, 6, -1, 1, 59 ),
            unpack( 1, 64, 17, -1, 1, 60, 3, -1, 1, 61, 2, -1, 1, 62, 6, -1, 
                     1, 63 ),
            unpack( 1, 67, 3, -1, 1, 68, 5, -1, 1, 69, 21, -1, 1, 65, 3, -1, 
                     1, 66, 5, -1, 1, 69 ),
            unpack( 1, 70 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 4, 41, 1, 71, 
                     14, 41, 1, 72, 6, 41 ),
            unpack( 1, 74 ),
            unpack( 1, 75, 4, -1, 1, 76 ),
            unpack( 1, 77 ),
            unpack( 1, 79, 31, -1, 1, 78 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 8, 41, 1, 80, 
                     5, 41, 1, 81, 11, 41 ),
            unpack( 1, 84, 31, -1, 1, 84, 3, -1, 1, 83 ),
            unpack( 1, 85 ),
            unpack( 10, 41, 7, -1, 1, 92, 25, 41, 4, -1, 1, 41, 1, -1, 1, 86, 
                     3, 41, 1, 87, 2, 41, 1, 88, 4, 41, 1, 89, 1, 41, 1, 90, 
                     2, 41, 1, 91, 8, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 1, 94, 3, 41, 
                     1, 95, 3, 41, 1, 96, 4, 41, 1, 97, 9, 41, 1, 98, 2, 41 ),
            unpack( 1, 102, 14, -1, 1, 103, 16, -1, 1, 100, 14, -1, 1, 103, 
                     1, 101 ),
            unpack( 1, 104, 3, -1, 1, 105, 1, -1, 1, 106, 1, 107 ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 109, 9, -1, 1, 109, 3, -1, 10, 108, 7, -1, 26, 108, 
                     4, -1, 1, 108, 1, -1, 26, 108, 1, 109, 1, -1, 1, 109 ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 31, 1, 30, 1, -1, 2, 31, 18, -1, 1, 31, 59, -1, 1, 31 ),
            unpack( 2, 31, 1, -1, 2, 31, 18, -1, 1, 31, 59, -1, 1, 31 ),
            unpack(  ),
            unpack( 1, 54, 4, -1, 1, 55, 1, -1, 1, 56, 24, -1, 1, 54, 4, -1, 
                     1, 55, 1, -1, 1, 56 ),
            unpack( 1, 64, 31, -1, 1, 64 ),
            unpack( 1, 67, 3, -1, 1, 68, 5, -1, 1, 69, 21, -1, 1, 67, 3, -1, 
                     1, 68, 5, -1, 1, 69 ),
            unpack( 1, 79, 31, -1, 1, 79 ),
            unpack( 1, 84, 31, -1, 1, 84 ),
            unpack( 1, 92, 31, -1, 1, 92 ),
            unpack( 1, 102, 14, -1, 1, 103, 16, -1, 1, 102, 14, -1, 1, 103 ),
            unpack( 1, 111, 3, -1, 1, 112, 27, -1, 1, 111, 3, -1, 1, 112 ),
            unpack( 1, 113, 31, -1, 1, 113 ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 114 ),
            unpack( 1, 115 ),
            unpack( 1, 117, 18, -1, 1, 116, 12, -1, 1, 117 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 18, 41, 1, 
                     118, 7, 41 ),
            unpack( 1, 117, 31, -1, 1, 117 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 120, 31, -1, 1, 120 ),
            unpack(  ),
            unpack( 1, 121 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 123, 1, 124 ),
            unpack( 1, 125 ),
            unpack( 1, 126 ),
            unpack( 1, 128, 1, -1, 1, 129, 28, -1, 1, 127, 1, 128, 1, -1, 1, 
                     129 ),
            unpack( 1, 128, 1, -1, 1, 129, 29, -1, 1, 128, 1, -1, 1, 129 ),
            unpack( 1, 132, 12, -1, 1, 133, 15, -1, 1, 130, 2, -1, 1, 132, 
                     1, 131, 11, -1, 1, 133 ),
            unpack( 1, 135, 30, -1, 1, 134, 1, 135 ),
            unpack( 1, 132, 12, -1, 1, 133, 18, -1, 1, 132, 12, -1, 1, 133 ),
            unpack( 1, 135, 31, -1, 1, 135 ),
            unpack( 1, 136, 31, -1, 1, 136 ),
            unpack( 1, 137 ),
            unpack( 1, 138 ),
            unpack( 1, 139 ),
            unpack(  ),
            unpack( 1, 140 ),
            unpack( 1, 141 ),
            unpack( 1, 142 ),
            unpack( 1, 143 ),
            unpack( 1, 145, 15, -1, 1, 146, 15, -1, 1, 145, 15, -1, 1, 144 ),
            unpack( 1, 145, 15, -1, 1, 146, 15, -1, 1, 145, 15, -1, 1, 146 ),
            unpack( 1, 147 ),
            unpack( 1, 148 ),
            unpack(  ),
            unpack( 1, 149 ),
            unpack( 1, 150, 31, -1, 1, 150 ),
            unpack( 1, 151 ),
            unpack( 1, 153, 31, -1, 1, 152 ),
            unpack( 1, 154 ),
            unpack( 1, 155 ),
            unpack( 1, 156 ),
            unpack( 1, 157 ),
            unpack( 1, 158 ),
            unpack( 1, 153, 31, -1, 1, 153 ),
            unpack(  ),
            unpack( 1, 159 ),
            unpack( 1, 160 ),
            unpack( 1, 161 ),
            unpack( 1, 162 ),
            unpack( 1, 163 ),
            unpack(  ),
            unpack( 1, 165, 14, -1, 1, 164, 16, -1, 1, 165 ),
            unpack( 1, 166, 15, -1, 1, 167 ),
            unpack( 1, 165, 31, -1, 1, 165 ),
            unpack( 1, 168, 31, -1, 1, 168 ),
            unpack( 1, 169 ),
            unpack( 1, 170 ),
            unpack( 1, 171, 19, -1, 1, 172 ),
            unpack( 1, 173 ),
            unpack( 1, 174, 3, -1, 10, 108, 7, -1, 26, 108, 4, -1, 1, 108, 
                     1, -1, 26, 108, 2, -1, 1, 175 ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 176, 31, -1, 1, 176 ),
            unpack( 1, 177, 31, -1, 1, 177 ),
            unpack( 1, 178, 31, -1, 1, 178 ),
            unpack( 1, 179 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 181 ),
            unpack( 1, 182, 31, -1, 1, 182 ),
            unpack( 1, 183 ),
            unpack(  ),
            unpack( 1, 184, 31, -1, 1, 184 ),
            unpack( 1, 185, 1, 186 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 1, 187, 25, 
                     41 ),
            unpack( 1, 189 ),
            unpack( 1, 190 ),
            unpack( 1, 191 ),
            unpack( 1, 192 ),
            unpack( 1, 193, 31, -1, 1, 193 ),
            unpack( 1, 194, 31, -1, 1, 194 ),
            unpack( 1, 195 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 17, 41, 1, 
                     196, 8, 41 ),
            unpack( 1, 198, 7, -1, 1, 199, 23, -1, 1, 198, 7, -1, 1, 199 ),
            unpack( 1, 200, 31, -1, 1, 200 ),
            unpack( 1, 201 ),
            unpack( 1, 202, 31, -1, 1, 202 ),
            unpack( 1, 203, 31, -1, 1, 203 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 8, 41, 1, 204, 
                     17, 41 ),
            unpack( 1, 206 ),
            unpack( 10, 41, 7, -1, 1, 41, 1, 207, 24, 41, 4, -1, 1, 41, 1, 
                     -1, 26, 41 ),
            unpack( 1, 209, 9, -1, 1, 210 ),
            unpack( 1, 211 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 1, 213, 25, 
                     41 ),
            unpack( 1, 216, 31, -1, 1, 215 ),
            unpack( 1, 217, 31, -1, 1, 217 ),
            unpack( 1, 216, 31, -1, 1, 216 ),
            unpack( 1, 218 ),
            unpack( 1, 219 ),
            unpack( 1, 220 ),
            unpack( 1, 221, 31, -1, 1, 221 ),
            unpack( 1, 222 ),
            unpack( 1, 224, 19, -1, 1, 223, 11, -1, 1, 224 ),
            unpack( 1, 224, 31, -1, 1, 224 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 19, 41, 1, 
                     225, 6, 41 ),
            unpack( 1, 227 ),
            unpack( 1, 228 ),
            unpack( 1, 229 ),
            unpack( 1, 230, 2, -1, 1, 231, 12, -1, 1, 232 ),
            unpack( 1, 233 ),
            unpack( 1, 234 ),
            unpack( 1, 235 ),
            unpack( 1, 236 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 15, 41, 1, 240, 10, 41, 4, -1, 1, 41, 1, 
                     -1, 18, 41, 1, 241, 7, 41 ),
            unpack( 1, 243 ),
            unpack( 1, 244, 31, -1, 1, 244 ),
            unpack( 1, 245 ),
            unpack( 1, 246 ),
            unpack( 1, 247 ),
            unpack( 1, 248 ),
            unpack( 1, 249 ),
            unpack( 1, 109, 1, -1, 1, 109, 9, -1, 1, 109, 3, -1, 10, 250, 7, 
                     -1, 26, 250, 4, -1, 1, 250, 1, -1, 26, 250, 1, 109, 1, 
                     -1, 1, 109 ),
            unpack(  ),
            unpack( 1, 252, 31, -1, 1, 252 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 254, 31, -1, 1, 254 ),
            unpack( 1, 255 ),
            unpack(  ),
            unpack( 1, 256 ),
            unpack( 1, 257, 31, -1, 1, 257 ),
            unpack( 1, 258 ),
            unpack( 1, 259, 31, -1, 1, 259 ),
            unpack( 1, 260 ),
            unpack( 1, 261 ),
            unpack( 1, 262 ),
            unpack(  ),
            unpack( 1, 263 ),
            unpack( 1, 264 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 4, 41, 1, 265, 
                     21, 41 ),
            unpack( 1, 267, 2, -1, 1, 268 ),
            unpack( 1, 269, 31, -1, 1, 269 ),
            unpack( 1, 270, 31, -1, 1, 270 ),
            unpack( 1, 271 ),
            unpack( 1, 272 ),
            unpack(  ),
            unpack( 1, 273, 31, -1, 1, 273 ),
            unpack( 1, 274, 31, -1, 1, 274 ),
            unpack( 1, 275, 31, -1, 1, 275 ),
            unpack( 1, 276 ),
            unpack( 1, 277, 31, -1, 1, 277 ),
            unpack( 1, 278, 31, -1, 1, 278 ),
            unpack( 1, 279 ),
            unpack(  ),
            unpack( 1, 280 ),
            unpack( 1, 281 ),
            unpack(  ),
            unpack( 1, 282 ),
            unpack( 1, 283 ),
            unpack( 1, 284 ),
            unpack(  ),
            unpack( 1, 285 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 288, 31, -1, 1, 288 ),
            unpack( 1, 289 ),
            unpack( 1, 290 ),
            unpack( 1, 291 ),
            unpack( 10, 41, 7, -1, 18, 41, 1, 292, 7, 41, 4, -1, 1, 41, 1, 
                     -1, 18, 41, 1, 292, 7, 41 ),
            unpack( 1, 294 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 14, 41, 1, 
                     295, 11, 41 ),
            unpack( 1, 297, 31, -1, 1, 297 ),
            unpack( 1, 298 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 15, 41, 1, 
                     299, 10, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 302 ),
            unpack( 1, 303 ),
            unpack( 1, 304 ),
            unpack( 1, 305 ),
            unpack( 1, 306 ),
            unpack( 1, 307 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 18, 41, 1, 
                     308, 7, 41 ),
            unpack( 1, 310 ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 311 ),
            unpack( 1, 312 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 314, 31, -1, 1, 314 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 316 ),
            unpack( 1, 317 ),
            unpack( 1, 318 ),
            unpack( 1, 319 ),
            unpack( 1, 174, 3, -1, 10, 250, 7, -1, 26, 250, 4, -1, 1, 250, 
                     1, -1, 26, 250, 2, -1, 1, 175 ),
            unpack(  ),
            unpack( 1, 320, 31, -1, 1, 320 ),
            unpack(  ),
            unpack( 1, 321, 31, -1, 1, 321 ),
            unpack( 1, 322 ),
            unpack( 1, 323 ),
            unpack( 1, 324, 31, -1, 1, 324 ),
            unpack( 1, 325 ),
            unpack( 1, 326, 31, -1, 1, 326 ),
            unpack( 1, 327 ),
            unpack( 1, 328 ),
            unpack( 1, 329 ),
            unpack( 1, 330 ),
            unpack( 1, 331, 15, -1, 1, 332 ),
            unpack( 1, 333 ),
            unpack(  ),
            unpack( 1, 334 ),
            unpack( 1, 335 ),
            unpack( 1, 336, 31, -1, 1, 336 ),
            unpack( 1, 337, 31, -1, 1, 337 ),
            unpack( 1, 338 ),
            unpack( 1, 339 ),
            unpack( 1, 340, 31, -1, 1, 340 ),
            unpack( 1, 341, 31, -1, 1, 341 ),
            unpack( 1, 342, 31, -1, 1, 342 ),
            unpack( 1, 343 ),
            unpack( 1, 344, 31, -1, 1, 344 ),
            unpack( 1, 345, 31, -1, 1, 345 ),
            unpack( 1, 346 ),
            unpack( 1, 347 ),
            unpack( 1, 348 ),
            unpack( 1, 349 ),
            unpack( 1, 350 ),
            unpack( 1, 351 ),
            unpack( 1, 352 ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 353, 31, -1, 1, 353 ),
            unpack( 1, 354 ),
            unpack( 1, 355 ),
            unpack( 1, 356 ),
            unpack( 1, 357, 31, -1, 1, 357 ),
            unpack(  ),
            unpack( 1, 358 ),
            unpack( 1, 359 ),
            unpack(  ),
            unpack( 1, 360, 31, -1, 1, 360 ),
            unpack( 1, 361 ),
            unpack( 1, 362 ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 363 ),
            unpack( 1, 364 ),
            unpack( 1, 365 ),
            unpack( 1, 366 ),
            unpack( 1, 367 ),
            unpack( 1, 368, 7, -1, 1, 369 ),
            unpack( 1, 370 ),
            unpack(  ),
            unpack( 1, 371 ),
            unpack( 1, 372 ),
            unpack( 1, 373 ),
            unpack(  ),
            unpack( 1, 374, 31, -1, 1, 374 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 376, 8, -1, 1, 377, 3, -1, 1, 378 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 1, 379, 25, 
                     41 ),
            unpack( 1, 381 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 383, 31, -1, 1, 383 ),
            unpack( 1, 384 ),
            unpack( 1, 385 ),
            unpack( 1, 386, 31, -1, 1, 386 ),
            unpack( 1, 387 ),
            unpack( 1, 388, 31, -1, 1, 388 ),
            unpack( 1, 389 ),
            unpack( 1, 390 ),
            unpack( 1, 391 ),
            unpack( 1, 392 ),
            unpack( 1, 393 ),
            unpack( 1, 394 ),
            unpack( 1, 395 ),
            unpack( 1, 396 ),
            unpack( 1, 397 ),
            unpack( 1, 398, 31, -1, 1, 398 ),
            unpack( 1, 399, 31, -1, 1, 399 ),
            unpack( 1, 400 ),
            unpack( 1, 401 ),
            unpack( 1, 402, 31, -1, 1, 402 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 404, 31, -1, 1, 404 ),
            unpack( 1, 405 ),
            unpack( 1, 406, 31, -1, 1, 406 ),
            unpack( 1, 407, 31, -1, 1, 407 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 409 ),
            unpack( 1, 410 ),
            unpack( 1, 411 ),
            unpack( 1, 412 ),
            unpack( 1, 413 ),
            unpack( 1, 414 ),
            unpack( 1, 415, 31, -1, 1, 415 ),
            unpack( 1, 416 ),
            unpack( 1, 417 ),
            unpack( 1, 418 ),
            unpack( 1, 419, 31, -1, 1, 419 ),
            unpack( 1, 420 ),
            unpack( 1, 421 ),
            unpack( 1, 422, 31, -1, 1, 422 ),
            unpack( 1, 423 ),
            unpack( 1, 424 ),
            unpack( 1, 425 ),
            unpack( 1, 426 ),
            unpack( 1, 427 ),
            unpack( 1, 428 ),
            unpack( 1, 429 ),
            unpack( 1, 430 ),
            unpack( 1, 431 ),
            unpack( 1, 432 ),
            unpack( 1, 433 ),
            unpack( 1, 434 ),
            unpack( 1, 435 ),
            unpack( 1, 436, 31, -1, 1, 436 ),
            unpack(  ),
            unpack( 1, 437 ),
            unpack( 1, 438, 13, -1, 1, 439 ),
            unpack( 1, 440 ),
            unpack( 1, 441 ),
            unpack(  ),
            unpack( 1, 442 ),
            unpack(  ),
            unpack( 1, 443, 31, -1, 1, 443 ),
            unpack( 1, 444 ),
            unpack( 1, 445 ),
            unpack( 1, 446, 31, -1, 1, 446 ),
            unpack( 1, 447 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 449 ),
            unpack( 1, 450 ),
            unpack( 1, 451 ),
            unpack( 1, 452 ),
            unpack( 1, 453 ),
            unpack( 1, 454 ),
            unpack( 1, 455 ),
            unpack( 10, 41, 7, -1, 1, 456, 25, 41, 4, -1, 1, 41, 1, -1, 26, 
                     41 ),
            unpack( 1, 458 ),
            unpack( 1, 459, 31, -1, 1, 459 ),
            unpack( 1, 460, 31, -1, 1, 460 ),
            unpack( 1, 461 ),
            unpack( 1, 462 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  ),
            unpack( 1, 464, 31, -1, 1, 464 ),
            unpack( 1, 465 ),
            unpack( 1, 466, 31, -1, 1, 466 ),
            unpack( 1, 467, 31, -1, 1, 467 ),
            unpack(  ),
            unpack( 1, 468 ),
            unpack( 1, 469 ),
            unpack( 1, 470 ),
            unpack( 1, 471 ),
            unpack( 1, 472 ),
            unpack( 1, 473 ),
            unpack( 1, 474, 31, -1, 1, 474 ),
            unpack( 1, 475 ),
            unpack( 1, 476 ),
            unpack( 1, 477 ),
            unpack( 1, 478, 31, -1, 1, 478 ),
            unpack( 1, 479 ),
            unpack( 1, 480 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 482 ),
            unpack( 1, 483 ),
            unpack( 1, 484 ),
            unpack( 1, 485 ),
            unpack( 1, 486 ),
            unpack( 1, 487, 11, -1, 1, 488 ),
            unpack( 1, 489 ),
            unpack( 1, 490 ),
            unpack( 1, 491 ),
            unpack( 1, 492 ),
            unpack( 1, 493 ),
            unpack( 1, 494 ),
            unpack( 1, 495 ),
            unpack( 1, 496, 31, -1, 1, 496 ),
            unpack( 1, 497 ),
            unpack( 1, 498 ),
            unpack( 1, 499 ),
            unpack( 1, 500 ),
            unpack( 1, 501 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 504 ),
            unpack( 1, 505 ),
            unpack( 1, 506, 31, -1, 1, 506 ),
            unpack( 1, 507 ),
            unpack(  ),
            unpack( 1, 508 ),
            unpack( 1, 509 ),
            unpack( 1, 510 ),
            unpack( 1, 511 ),
            unpack( 1, 512 ),
            unpack( 1, 513 ),
            unpack( 1, 514 ),
            unpack( 1, 515 ),
            unpack(  ),
            unpack( 1, 516 ),
            unpack( 1, 517, 31, -1, 1, 517 ),
            unpack( 1, 518, 31, -1, 1, 518 ),
            unpack( 1, 519 ),
            unpack( 1, 520 ),
            unpack(  ),
            unpack( 1, 521, 31, -1, 1, 521 ),
            unpack( 1, 522, 4, -1, 1, 523 ),
            unpack( 1, 524, 31, -1, 1, 524 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 526 ),
            unpack( 1, 527 ),
            unpack( 1, 528 ),
            unpack( 1, 529 ),
            unpack( 1, 530 ),
            unpack( 1, 531 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 533 ),
            unpack( 1, 534 ),
            unpack( 1, 535 ),
            unpack( 1, 536, 31, -1, 1, 536 ),
            unpack( 1, 537 ),
            unpack( 1, 538 ),
            unpack(  ),
            unpack( 1, 539 ),
            unpack( 1, 540 ),
            unpack( 1, 541 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 543 ),
            unpack( 1, 544 ),
            unpack( 1, 545 ),
            unpack( 1, 546 ),
            unpack( 1, 547 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 549 ),
            unpack( 1, 550 ),
            unpack( 1, 551 ),
            unpack( 1, 552 ),
            unpack( 1, 553, 31, -1, 1, 553 ),
            unpack( 1, 554, 13, -1, 1, 555 ),
            unpack( 1, 556 ),
            unpack( 1, 557 ),
            unpack( 1, 558 ),
            unpack( 1, 559 ),
            unpack(  ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 562, 31, -1, 1, 562 ),
            unpack( 1, 563 ),
            unpack( 1, 564 ),
            unpack( 1, 565 ),
            unpack( 1, 566 ),
            unpack( 1, 567 ),
            unpack( 1, 568 ),
            unpack( 1, 569 ),
            unpack( 1, 570 ),
            unpack( 1, 571 ),
            unpack( 10, 41, 7, -1, 1, 572, 25, 41, 4, -1, 1, 41, 1, -1, 26, 
                     41 ),
            unpack( 1, 574, 31, -1, 1, 574 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 577 ),
            unpack( 1, 578, 31, -1, 1, 578 ),
            unpack( 1, 579 ),
            unpack( 1, 580 ),
            unpack( 1, 581, 31, -1, 1, 581 ),
            unpack(  ),
            unpack( 1, 582 ),
            unpack( 1, 583 ),
            unpack( 1, 584 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 18, 41, 1, 
                     585, 7, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 588 ),
            unpack(  ),
            unpack( 1, 589 ),
            unpack( 1, 590 ),
            unpack( 1, 591 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 593 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 595 ),
            unpack( 1, 596 ),
            unpack( 1, 597 ),
            unpack(  ),
            unpack( 1, 598 ),
            unpack( 1, 599 ),
            unpack( 1, 600 ),
            unpack( 1, 601 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  ),
            unpack( 1, 603 ),
            unpack( 1, 604 ),
            unpack( 1, 605 ),
            unpack( 1, 606 ),
            unpack( 1, 607 ),
            unpack( 1, 608 ),
            unpack( 1, 609 ),
            unpack( 1, 610 ),
            unpack( 1, 611 ),
            unpack( 1, 612 ),
            unpack( 1, 613 ),
            unpack(  ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 615 ),
            unpack( 1, 616 ),
            unpack( 1, 617 ),
            unpack( 1, 618 ),
            unpack( 1, 619 ),
            unpack( 1, 620 ),
            unpack( 1, 621 ),
            unpack( 1, 622 ),
            unpack( 1, 623 ),
            unpack( 1, 624 ),
            unpack(  ),
            unpack( 1, 625, 31, -1, 1, 625 ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 626 ),
            unpack( 1, 627, 31, -1, 1, 627 ),
            unpack( 1, 628 ),
            unpack( 1, 629 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 631 ),
            unpack( 1, 632 ),
            unpack( 1, 633 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 635 ),
            unpack( 1, 636 ),
            unpack( 1, 637 ),
            unpack( 1, 638 ),
            unpack(  ),
            unpack( 1, 639 ),
            unpack(  ),
            unpack( 1, 640 ),
            unpack( 1, 641 ),
            unpack( 1, 642 ),
            unpack( 1, 643 ),
            unpack( 1, 644 ),
            unpack( 1, 645 ),
            unpack( 1, 646 ),
            unpack(  ),
            unpack( 1, 647 ),
            unpack( 1, 648 ),
            unpack( 1, 649 ),
            unpack( 1, 650 ),
            unpack( 1, 651, 31, -1, 1, 651 ),
            unpack( 1, 652 ),
            unpack( 1, 653 ),
            unpack( 1, 654 ),
            unpack( 1, 655 ),
            unpack( 1, 656 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 659 ),
            unpack( 1, 660 ),
            unpack( 1, 661 ),
            unpack( 1, 662 ),
            unpack( 1, 663 ),
            unpack( 1, 664 ),
            unpack( 1, 665 ),
            unpack( 1, 666 ),
            unpack( 1, 667 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 671 ),
            unpack( 1, 672 ),
            unpack(  ),
            unpack( 1, 673 ),
            unpack( 1, 674 ),
            unpack( 1, 675 ),
            unpack(  ),
            unpack( 1, 676 ),
            unpack( 1, 677 ),
            unpack( 1, 678 ),
            unpack( 1, 679 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 681 ),
            unpack( 1, 682 ),
            unpack( 1, 683 ),
            unpack( 1, 684 ),
            unpack( 1, 685 ),
            unpack( 1, 686 ),
            unpack( 1, 687 ),
            unpack( 1, 688 ),
            unpack( 1, 689 ),
            unpack( 1, 690 ),
            unpack( 1, 691 ),
            unpack( 1, 692, 31, -1, 1, 692 ),
            unpack( 1, 693 ),
            unpack( 1, 694 ),
            unpack( 1, 695 ),
            unpack( 1, 696 ),
            unpack( 1, 697 ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 698 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 700 ),
            unpack( 1, 701 ),
            unpack( 1, 702 ),
            unpack( 1, 703 ),
            unpack( 1, 704 ),
            unpack( 1, 705 ),
            unpack( 1, 706 ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 707 ),
            unpack( 1, 708 ),
            unpack( 1, 709 ),
            unpack( 1, 710 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 18, 41, 1, 
                     711, 7, 41 ),
            unpack( 1, 713 ),
            unpack( 1, 714 ),
            unpack( 1, 715 ),
            unpack( 1, 716 ),
            unpack(  ),
            unpack( 1, 717 ),
            unpack( 1, 718 ),
            unpack( 1, 719 ),
            unpack( 1, 720 ),
            unpack( 1, 721 ),
            unpack( 1, 722 ),
            unpack( 1, 723 ),
            unpack( 1, 724 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 728, 31, -1, 1, 728 ),
            unpack( 1, 729 ),
            unpack( 1, 730 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 732 ),
            unpack( 1, 733 ),
            unpack( 1, 734 ),
            unpack(  ),
            unpack( 1, 735 ),
            unpack( 1, 736 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 738 ),
            unpack( 1, 739 ),
            unpack( 1, 740 ),
            unpack( 1, 741 ),
            unpack( 1, 742 ),
            unpack( 1, 743 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 745 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  ),
            unpack( 1, 747 ),
            unpack( 1, 748 ),
            unpack( 1, 749 ),
            unpack( 1, 750 ),
            unpack( 1, 751 ),
            unpack( 1, 752 ),
            unpack( 1, 753 ),
            unpack( 1, 754 ),
            unpack( 1, 755 ),
            unpack( 1, 756 ),
            unpack( 1, 757 ),
            unpack( 1, 758 ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 759, 31, -1, 1, 759 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 761 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 763 ),
            unpack( 1, 764 ),
            unpack( 1, 765 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  ),
            unpack( 1, 767 ),
            unpack( 1, 768 ),
            unpack( 1, 769 ),
            unpack( 1, 770 ),
            unpack( 1, 771 ),
            unpack( 1, 772 ),
            unpack(  ),
            unpack( 1, 773 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 775 ),
            unpack( 1, 776 ),
            unpack( 1, 777 ),
            unpack( 1, 778 ),
            unpack( 1, 779 ),
            unpack( 1, 780 ),
            unpack( 1, 781 ),
            unpack( 1, 782 ),
            unpack( 1, 783 ),
            unpack( 1, 784 ),
            unpack( 1, 785 ),
            unpack( 1, 786, 31, -1, 1, 786 ),
            unpack(  ),
            unpack( 1, 787 ),
            unpack(  ),
            unpack( 1, 788 ),
            unpack( 1, 789 ),
            unpack( 1, 790 ),
            unpack(  ),
            unpack( 1, 791 ),
            unpack( 1, 792 ),
            unpack( 1, 793 ),
            unpack( 1, 794 ),
            unpack( 1, 795 ),
            unpack( 1, 796 ),
            unpack( 1, 797 ),
            unpack(  ),
            unpack( 1, 798 ),
            unpack( 1, 799 ),
            unpack( 1, 800 ),
            unpack( 1, 801 ),
            unpack( 1, 802 ),
            unpack( 1, 803 ),
            unpack( 1, 804 ),
            unpack( 1, 805 ),
            unpack( 1, 806 ),
            unpack( 1, 807 ),
            unpack( 1, 808 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 810 ),
            unpack( 1, 811 ),
            unpack( 1, 812 ),
            unpack( 1, 813 ),
            unpack( 1, 814 ),
            unpack( 1, 815 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 817 ),
            unpack( 1, 818 ),
            unpack( 1, 819 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 821 ),
            unpack( 1, 822 ),
            unpack( 1, 823 ),
            unpack( 1, 824 ),
            unpack( 1, 825 ),
            unpack( 1, 826 ),
            unpack( 1, 827 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 829 ),
            unpack( 1, 830 ),
            unpack( 1, 831 ),
            unpack(  ),
            unpack( 1, 832 ),
            unpack( 1, 833 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 836 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  ),
            unpack( 1, 838 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 843 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 845 ),
            unpack( 1, 846 ),
            unpack( 1, 847 ),
            unpack(  ),
            unpack( 1, 848 ),
            unpack( 1, 849 ),
            unpack( 1, 850 ),
            unpack( 1, 851 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 853 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 855 ),
            unpack(  ),
            unpack( 1, 856 ),
            unpack( 1, 857 ),
            unpack( 1, 858 ),
            unpack( 1, 859 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 861 ),
            unpack( 1, 862 ),
            unpack(  ),
            unpack( 1, 863 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 867 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  ),
            unpack( 1, 869 ),
            unpack( 1, 870 ),
            unpack( 1, 871 ),
            unpack(  ),
            unpack(  ),
            unpack(  ),
            unpack( 1, 872 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 874 ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 876 ),
            unpack(  ),
            unpack( 1, 877 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack( 1, 879 ),
            unpack(  ),
            unpack( 10, 41, 7, -1, 26, 41, 4, -1, 1, 41, 1, -1, 26, 41 ),
            unpack(  )
          ].freeze

          ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
            if a > 0 and z < 0
              MAX[ i ] %= 0x10000
            end
          end

          @decision = 15


          def description
            <<-'__dfa_description__'.strip!
              1:1: Tokens : ( T__64 | T__65 | T__66 | T__67 | T__68 | T__69 | T__70 | T__71 | T__72 | T__73 | T__74 | T__75 | T__76 | T__77 | T__78 | T__79 | T__80 | T__81 | T__82 | T__83 | T__84 | T__85 | T__86 | T__87 | T__88 | T__89 | T__90 | T__91 | T__92 | T__93 | T__94 | T__95 | T__96 | T__97 | T__98 | T__99 | T__100 | T__101 | T__102 | T__103 | T__104 | T__105 | T__106 | T__107 | T__108 | T__109 | T__110 | T__111 | T__112 | T__113 | T__114 | T__115 | T__116 | T__117 | T__118 | T__119 | T__120 | T__121 | T__122 | T__123 | T__124 | T__125 | T__126 | T__127 | T__128 | T__129 | T__130 | T__131 | T__132 | T__133 | T__134 | T__135 | T__136 | T__137 | T__138 | T__139 | T__140 | T__141 | T__142 | T__143 | T__144 | T__145 | T__146 | T__147 | T__148 | T__149 | T__150 | DOCUMENT_COMMENT | STATEMENT_COMMENT | IDENT_LIST | VALUE_LIST | QUOTED_VALUE | LP | RP | EQ | COLON | COMMA | NEWLINE | WS | KWRD_ANNO | KWRD_AS | KWRD_AUTHORS | KWRD_CONTACTINFO | KWRD_COPYRIGHT | KWRD_DFLT | KWRD_DEFINE | KWRD_DESC | KWRD_DISCLAIMER | KWRD_DOCUMENT | KWRD_LICENSES | KWRD_LIST | KWRD_NAME | KWRD_NS | KWRD_PATTERN | KWRD_SET | KWRD_STMT_GROUP | KWRD_UNSET | KWRD_URL | KWRD_VERSION | OBJECT_IDENT );
            __dfa_description__
          end

        end


        private

        def initialize_dfas
          super rescue nil
          @dfa15 = DFA15.new( self, 15 )


        end

      end # class Lexer < ANTLR3::Lexer

      at_exit { Lexer.main( ARGV ) } if __FILE__ == $0

    end
  end
end
