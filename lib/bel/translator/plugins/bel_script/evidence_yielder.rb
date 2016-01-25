require 'bel'

module BEL::Translator::Plugins

  module BelScript

    class EvidenceYielder
      include ::BEL::Model
      include ::BEL::Quoting

      SPECIAL_ANNOTATIONS = {
        'Citation' => true,
        'Evidence' => true,
      }

      def initialize(data)
        @data                   = data
        @references             = References.new
        @metadata               = Metadata.new
      end

      def each
        if block_given?
          ::BEL::Script.parse(@data).each { |parsed_obj|
            case parsed_obj
            when ::BEL::Language::DocumentProperty
              @metadata.document_header[parsed_obj.name] = parsed_obj.value
            when ::BEL::Model::Statement
              yield to_evidence(parsed_obj, @references, @metadata)
            when ::BEL::Language::AnnotationDefinition
              @references.add_annotation(
                parsed_obj.prefix,
                parsed_obj.type,
                parsed_obj.value
              )
            when ::BEL::Namespace::NamespaceDefinition
              @references.add_namespace(parsed_obj.prefix, parsed_obj.url)
            end
          }
        else
          to_enum(:each)
        end
      end

      private

      def to_evidence(statement, references, metadata)
        evidence = Evidence.new
        evidence.bel_statement = statement

        if statement.annotations.include? 'Citation'
          fields              = statement.annotations['Citation'].value
          if fields.respond_to? :each
            evidence.citation = Citation.new(
              fields.map { |field|
                remove_quotes(field)
              }.to_a
            )
          end
        end

        if statement.annotations.include? 'Evidence'
          value  = statement.annotations['Evidence'].value
          evidence.summary_text.value = value
        end

        annotations = statement.annotations.dup
        annotations.delete_if { |k, _| SPECIAL_ANNOTATIONS[k] }
        evidence.experiment_context = ExperimentContext.new(
          annotations.map { |k, v|
            value = v.value
            obj   = {
              :name  => k,
              :value => value
            }

            obj
          }
        )

        evidence.references = references
        evidence.metadata   = metadata
        evidence
      end
    end
  end
end
