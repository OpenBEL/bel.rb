require 'bel'
require 'bel/json'

module BEL::Translator::Plugins

  module Bnj

    class BnjTranslator

      include ::BEL::Translator

      def read(data, options = {})
        ::BEL::JSON.read(data, options).lazy.select { |obj|
          obj.include?(Bnj::NANOPUB_ROOT)
        }.map { |json_obj|
          unwrap(json_obj)
        }
      end

      def write(objects, writer = StringIO.new, options = {})
        json_strings = Enumerator.new { |yielder|
          yielder << '['
          begin
            nanopub_enum = objects.each

            # write first nanopub object
            nanopub = nanopub_enum.next
            yielder << ::BEL::JSON.write(wrap(nanopub), nil)

            # each successive nanopub starts with a comma
            while true
              nanopub = nanopub_enum.next
              yielder << ','
              yielder << ::BEL::JSON.write(wrap(nanopub), nil)
            end
          rescue StopIteration
            # end of nanopub hashes
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

      def wrap(nanopub)
        hash = nanopub.to_h
        {
          NANOPUB_ROOT => {
            :bel_statement      => hash[:bel_statement].to_s,
            :citation           => hash[:citation],
            :support            => escape_newlines(hash[:support]),
            :experiment_context => hash[:experiment_context],
            :references         => hash[:references],
            :metadata           => hash[:metadata].to_a
          }
        }
      end

      def unwrap(hash)
        nanopub_hash          = hash[NANOPUB_ROOT]
        nanopub               = ::BEL::Nanopub::Nanopub.create(nanopub_hash)

        nanopub.bel_statement = parse_statement(nanopub)
        nanopub
      end

      def parse_statement(nanopub)
        namespaces = nanopub.references.namespaces
        ::BEL::Script.parse(
          "#{nanopub.bel_statement}\n",
          Hash[
            namespaces.map { |k, v|
              [k, ::BEL::Namespace::NamespaceDefinition.new(k, v)]
            }
          ]
        ).select { |obj|
          obj.is_a? ::BEL::Nanopub::Statement
        }.first
      end

      def escape_newlines(value)
        value.gsub(/\n/, "\\n").gsub(/\r/, "\\r")
      end
    end
  end
end
