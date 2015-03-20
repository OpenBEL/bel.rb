module LibBEL

  class << self

    def rubinius?
      defined?(RUBY_ENGINE) && ("rbx" == RUBY_ENGINE)
    end

    # @api_private
    # Determines the correct extension path for your ruby version
    def extension_path(ruby_version = RUBY_VERSION)
      version =
        case ruby_version
        when /^1\.9/
          '1.9'
        when /^2\.0/
          '2.0'
        when /^2\.1/
          '2.1'
        when /^2\.2/
          '2.2'
        else
          fail RuntimeError.new("Do not support Ruby #{RUBY_VERSION}.")
        end

      File.join(File.expand_path(File.dirname(__FILE__)), version)
    end

    # @api_private
    # Determine FFI constant for this ruby engine.
    def find_ffi
      if rubinius?
        # Use ffi gem instead of rubinius-bundled FFI
        # Rubinius 2.5.2 does not seem to support FFI::ManagedStruct
        require "ffi"
        ::FFI
      else # mri, jruby, etc
        require "ffi"
        ::FFI
      end
    end

    # @api_private
    # Extend with the correct ffi implementation.
    def load_ffi
      ffi_module = LibBEL::find_ffi
      extend ffi_module::Library
      ffi_module
    end

    # @api_private
    # Loads the libbel shared library.
    def load_libBEL
      ffi_module = find_ffi
      extend ffi_module::Library

      # libbel.so:     Linux and MinGW
      # libbel.bundle: Mac OSX
      messages = []
      library_loaded = ['libbel.so', 'libbel.bundle'].map { |library_file|
        [
          library_file,
          File.join(
            File.expand_path(File.dirname(__FILE__)),
            library_file
          )
        ]
      }.any? do |library_file, library_path|
        # Try loading top-level shared library.
        begin
          ffi_lib library_path
          true
        rescue LoadError => exception1
          # Try loading version-specific shared library.
          begin
            ffi_lib File.join(extension_path, library_file)
            true
          rescue LoadError => exception2
            messages << exception1.to_s
            messages << exception2.to_s
            false
          end
        end
      end

      if !library_loaded
        msg = messages.map { |msg| "  #{msg}" }.join("\n")
        fail LoadError.new("Failed to load libbel library. Details:\n#{msg}")
      end
    end
  end

  # Constant holding the FFI module for this ruby engine.
  FFI = LibBEL::load_ffi
  LibBEL::load_libBEL

  # typedef enum bel_token_type
  enum :bel_token_type, [
    :IDENT,   0,
    :STRING,
    :O_PAREN,
    :C_PAREN,
    :COLON,
    :COMMA,
    :SPACES
  ]

  enum :bel_ast_node_type, [
    :BEL_TOKEN, 0,
    :BEL_VALUE
  ]

  enum :bel_ast_token_type, [
    :BEL_TOKEN_STATEMENT, 0,
    :BEL_TOKEN_SUBJECT,
    :BEL_TOKEN_OBJECT,
    :BEL_TOKEN_REL,
    :BEL_TOKEN_TERM,
    :BEL_TOKEN_ARG,
    :BEL_TOKEN_NV
  ]

  enum :bel_ast_value_type, [
    :BEL_VALUE_FX, 0,
    :BEL_VALUE_REL,
    :BEL_VALUE_PFX,
    :BEL_VALUE_VAL
  ]

  require_relative 'libbel/bel_ast_structs'
  require_relative 'libbel/bel_token'
  require_relative 'libbel/bel_token_iterator'
  require_relative 'libbel/bel_token_list'

  # bel ast
  attach_function :bel_ast_as_string,       [:pointer                                     ], :string
  attach_function :bel_copy_ast_node,       [:pointer                                     ], :pointer
  attach_function :bel_free_ast,            [:pointer                                     ], :void
  attach_function :bel_free_ast_node,       [:pointer                                     ], :void
  attach_function :bel_new_ast,             [                                             ], :pointer
  attach_function :bel_new_ast_node_token,  [:bel_ast_token_type                          ], :pointer
  attach_function :bel_new_ast_node_value,  [:bel_ast_value_type, :string                 ], :pointer
  attach_function :bel_print_ast,           [:pointer                                     ], :void
  attach_function :bel_print_ast_node,      [:pointer, :string                            ], :void
  attach_function :bel_set_value,           [:pointer, :string                            ], :pointer

  # bel token
  attach_function :bel_new_token,           [:bel_token_type, :pointer, :pointer, :pointer], :pointer
  attach_function :bel_new_token_iterator,  [:pointer                                     ], :pointer
  attach_function :bel_new_token_list,      [:int                                         ], :pointer
  attach_function :bel_print_token,         [:pointer                                     ], :void
  attach_function :bel_print_token_list,    [:pointer                                     ], :void
  attach_function :bel_token_iterator_end,  [:pointer                                     ], :int
  attach_function :bel_token_iterator_get,  [:pointer                                     ], :pointer
  attach_function :bel_token_iterator_next, [:pointer                                     ], :void
  attach_function :free_bel_token,          [:pointer                                     ], :void
  attach_function :free_bel_token_iterator, [:pointer                                     ], :void
  attach_function :free_bel_token_list,     [:pointer                                     ], :void

  # tokenize
  attach_function :bel_tokenize_term,       [:string                                      ], :pointer

  # parse
  attach_function :bel_parse_statement,     [:string                                      ], :pointer
  attach_function :bel_parse_term,          [:string                                      ], :pointer

  def self.parse_statement(bel_string)
    LibBEL::BelAst.new(LibBEL::bel_parse_statement(bel_string))
  end

  def self.parse_term(bel_string)
    LibBEL::BelAst.new(LibBEL::bel_parse_term(bel_string))
  end

  def self.tokenize_term(bel_string)
    LibBEL::BelTokenList.new(self.bel_tokenize_term(string))
  end

  def self.copy_ast(bel_ast)
    copy_root = self.copy_ast_node(bel_ast.root)
    new_ast   = LibBEL::BelAst.new(LibBEL::bel_new_ast())
    new_ast.root = copy_root
    new_ast
  end

  def self.copy_ast_node(bel_ast_node)
    LibBEL::BelAstNode.new(LibBEL::bel_copy_ast_node(bel_ast_node))
  end

  def self.print_ast(bel_ast)
    LibBEL::bel_print_ast(bel_ast)
  end

  def self.print_token(token)
    self.bel_print_token(token.pointer)
  end

  def self.print_token_list(list)
    self.bel_print_token_list(list.pointer)
  end
end

