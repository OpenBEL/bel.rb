require 'bel'
require 'bel/json'

module BEL::Translator::Plugins

  module JsonEvidence

    class JsonEvidenceTranslator

      include ::BEL::Translator

      ID          = :json_evidence
      NAME        = 'JSON Evidence Translator'
      DESCRIPTION = 'A translator that can read and write evidence to individual JSON objects per the evidence schema (http://next.belframework.org/schemas/evidence.schema.json).'
      MEDIA_TYPES = %i(application/json)
      EXTENSIONS  = %i(json)
      EVIDENCE_ROOT = :evidence
      
      def id
        ID
      end

      def name
        NAME
      end

      def description
        DESCRIPTION
      end

      def media_types
        MEDIA_TYPES
      end

      def file_extensions
        EXTENSIONS
      end

      def on_activate
        require 'bel/json'
      end

      def create
      end

      def read(data, options = {})
        ::BEL::JSON.read(data, options).lazy.select { |obj|
          obj.include?(:evidence)
        }.map { |json_obj|
          unwrap(json_obj)
        }
      end

      def write(objects, writer = StringIO.new, options = {})
        write_array_start(writer)
        begin
          evidence_enum = objects.each

          # write first evidence object
          evidence = evidence_enum.next
          ::BEL::JSON.write(wrap(evidence), writer)

          # each successive evidence starts with a comma
          while true
            evidence = evidence_enum.next
            writer  << ","
            ::BEL::JSON.write(wrap(evidence), writer)
          end
        rescue StopIteration
          # end of evidence hashes
        end
        write_array_end(writer)

        writer
      end

      private

      def write_array_start(writer)
        writer << '['
      end

      def write_array_end(writer)
        writer << ']'
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

      def parse_statement(evidence)
        namespaces = evidence.references.namespaces
        ::BEL::Script.parse(
          "#{evidence.bel_statement}\n",
          Hash[
            namespaces.map { |k, v|
              [k, ::BEL::Namespace::NamespaceDefinition.new(k, v)]
            }
          ]
        ).select { |obj|
          obj.is_a? ::BEL::Model::Statement
        }.first
      end
    end
  end
end
