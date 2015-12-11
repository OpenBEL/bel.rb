require 'bel'
require 'bel/json'

module BEL::Translator::Plugins

  module JsonEvidence

    class JsonEvidenceTranslator

      include ::BEL::Translator

      def read(data, options = {})
        ::BEL::JSON.read(data, options).lazy.select { |obj|
          obj.include?(:evidence)
        }.map { |json_obj|
          unwrap(json_obj)
        }
      end

      def write(objects, writer = StringIO.new, options = {})
        json_strings = Enumerator.new { |yielder|
          yielder << '['
          begin
            evidence_enum = objects.each

            # write first evidence object
            evidence = evidence_enum.next
            yielder << ::BEL::JSON.write(wrap(evidence), nil)

            # each successive evidence starts with a comma
            while true
              evidence = evidence_enum.next
              yielder << ','
              yielder << ::BEL::JSON.write(wrap(evidence), nil)
            end
          rescue StopIteration
            # end of evidence hashes
          end
          yielder << ']'
        }

        if block_given?
          json_strings.each do |string|
            yield string
          end
        else
          if writer
            json_strings.each do |string|
              writer << string
              writer.flush
            end
            writer
          else
            json_strings
          end
        end
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
