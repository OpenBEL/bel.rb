require 'bel/evidence_model'
require 'bel/namespace'
require 'bel/script'

module BEL::Extension::Format

  class FormatJSON

    include Formatter
    ID            = :json
    MEDIA_TYPES   = %i(application/json)
    EXTENSIONS    = %i(json)
    EVIDENCE_ROOT = :evidence

    def initialize
      json_module = load_implementation_module!
      @json_reader = json_module::JSONReader
      @json_writer = json_module::JSONWriter
    end

    def id
      ID
    end

    def media_types
      MEDIA_TYPES
    end

    def file_extensions
      EXTENSIONS
    end

    def deserialize(data)
      @json_reader.new(data).each.lazy.select { |obj|
        obj.include?(:evidence)
      }.map { |hash|
        unwrap(hash)
      }
    end

    def serialize(objects, writer = StringIO.new)
      json_writer = @json_writer.new
      # json array start
      writer << "["

      # json objects
      begin
        evidence_enum = objects.each

        # write first evidence
        evidence = evidence_enum.next
        writer  << json_writer.write_json_object(wrap(evidence))

        # each successive evidence starts with a comma
        while true
          evidence = evidence_enum.next
          writer  << ","
          writer  << json_writer.write_json_object(wrap(evidence))
        end
      rescue StopIteration
        # end of evidence hashes
      end

      # json array end
      writer << "]"
      writer
    end

    private

    # Load the most suitable JSON implementation available within ruby.
    # The load order attempted is:
    # - oj              (provides stream parsing utilizing event callbacks)
    # - TODO jrjackson  (stream parsing support for JRuby)
    # - multi_json      (simple buffering abstraction over multiple ruby libraries)
    # - json            (stock ruby implementation)
    def load_implementation_module!
      impl_modules  = [ 'oj', 'jrjackson', 'multi_json', 'ruby_json' ]

      load_success = impl_modules.any? { |impl_module|
        begin
          require_relative impl_module
          true
        rescue LoadError
          # Could not load +impl_module+; try the next one
          false
        end
      }

      if load_success
        BEL::Extension::Format::JSONImplementation
      else
        mod_s = impl_modules.join(', ')
        msg   = "Could not load any JSON implementation (tried: #{mod_s})."
        raise LoadError.new(msg)
      end
    end

    def wrap(evidence)
      hash = evidence.to_h
      {
        EVIDENCE_ROOT => {
          :bel_statement      => hash[:bel_statement].to_s,
          :citation           => hash[:citation],
          :summary_text       => hash[:summary_text],
          :experiment_context => hash[:experiment_context],
          :references         => hash[:references],
          :metadata           => hash[:metadata].to_a
        }
      }
    end

    def unwrap(hash)
      evidence_hash          = hash[EVIDENCE_ROOT]
      evidence               = ::BEL::Model::Evidence.create(evidence_hash)

      evidence.bel_statement = parse_statement(evidence)
      evidence
    end

    private

    def parse_statement(evidence)
      namespaces = evidence.references.namespaces
      ::BEL::Script.parse(
        "#{evidence.bel_statement}\n",
        Hash[
          namespaces.map { |k, v|
            [k, BEL::Namespace::NamespaceDefinition.new(k, v)]
          }
        ]
      ).select { |obj|
        obj.is_a? ::BEL::Model::Statement
      }.first
    end
  end

  register_formatter(FormatJSON.new)
end
