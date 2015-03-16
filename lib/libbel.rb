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
        when %r{1\.9}
          '1.9'
        when %r{2\.0}
          '2.0'
        when %r{2\.1}
          '2.1'
        when %r{2\.2}
          '2.1' # 2.2 is compatible with 2.1, but cannot cross compile 2.2
        else
          fail RuntimeError.new("Do not support Ruby #{RUBY_VERSION}.")
        end
        extension_path = File.join(
          File.expand_path(File.dirname(__FILE__)),
          version
        )
        if !File.readable?(extension_path)
          msg = "Extension path cannot be read: #{extension_path}"
          fail IOError.new(msg)
        end

        extension_path
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

  class BelToken < FFI::Struct

    layout :type,      :bel_token_type,
           :pos_start, :int,
           :pos_end,   :int,
           :value,     :pointer

    def type
      self[:type]
    end

    def pos_start
      self[:pos_start]
    end

    def pos_end
      self[:pos_end]
    end

    def value
      self[:value].read_string
    end

    def hash
      [self.type, self.value, self.pos_start, self.pos_end].hash
    end

    def ==(other)
      return false if other == nil
      self.type == other.type && self.value == other.value &&
        self.pos_start == other.pos_start && self.pos_end == other.pos_end
    end

    alias_method :eql?, :'=='
  end

  class BelTokenList < FFI::ManagedStruct
    include Enumerable

    layout :length,    :int,
           :tokens,    BelToken.ptr

    def each
      if block_given?
        iterator = LibBEL::bel_new_token_iterator(self.pointer)
        while LibBEL::bel_token_iterator_end(iterator).zero?
          current_token = LibBEL::bel_token_iterator_get(iterator)
          yield LibBEL::BelToken.new(current_token)
          LibBEL::bel_token_iterator_next(iterator)
        end
        LibBEL::free_bel_token_iterator(iterator)
      else
        enum_for(:each)
      end
    end

    def token_at(position)
      self.each_with_index { |tk, index|
        if (tk.pos_start..tk.pos_end).include? position
          return [tk, index]
        end
      }
      nil
    end

    def self.release(ptr)
      LibBEL::free_bel_token_list(ptr)
    end
  end

  class BelTokenIterator < FFI::ManagedStruct
    include Enumerable

    layout :index,         :int,
           :list,          :pointer,
           :current_token, :pointer

    def each
      if self.null? or not LibBEL::bel_token_iterator_end(self).zero?
        fail StopIteration, "bel_token_iterator reached end"
      end

      if block_given?
        while LibBEL::bel_token_iterator_end(self.pointer).zero?
          current_token = LibBEL::bel_token_iterator_get(self.pointer)
          yield LibBEL::BelToken.new(current_token)
          LibBEL::bel_token_iterator_next(self.pointer)
        end
      else
        enum_for(:each)
      end
    end

    def self.release(ptr)
      LibBEL::free_bel_token_iterator(ptr)
    end
  end

  attach_function :bel_new_token,           [:bel_token_type, :pointer, :pointer, :pointer], :pointer
  attach_function :bel_new_token_list,      [:int                                         ], :pointer
  attach_function :bel_new_token_iterator,  [:pointer                                     ], :pointer
  attach_function :bel_token_iterator_get,  [:pointer                                     ], :pointer
  attach_function :bel_token_iterator_next, [:pointer                                     ], :void
  attach_function :bel_token_iterator_end,  [:pointer                                     ], :int
  attach_function :bel_parse_term,          [:string                                      ], :pointer
  attach_function :bel_tokenize_term,       [:string                                      ], :pointer
  attach_function :bel_print_token,         [:pointer                                     ], :void
  attach_function :bel_print_token_list,    [:pointer                                     ], :void
  attach_function :free_bel_token,          [:pointer                                     ], :void
  attach_function :free_bel_token_list,     [:pointer                                     ], :void
  attach_function :free_bel_token_iterator, [:pointer                                     ], :void

  def self.tokenize_term(string)
    LibBEL::BelTokenList.new(self.bel_tokenize_term(string))
  end

  def self.print_token(token)
    self.bel_print_token(token.pointer)
  end

  def self.print_token_list(list)
    self.bel_print_token_list(list.pointer)
  end
end

