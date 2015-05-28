require 'bel'

module BEL::Extension::Format

  class FormatBEL

    include Formatter

    ID = :bel
    
    def id
      ID
    end

    def deserialize(data, &block)
      EvidenceYielder.new(data)
    end

    def serialize(objects, writer = StringIO.new, options = {})
      BELYielder.new(objects, {:write_header => true}).each { |bel_part|
        writer << "#{bel_part}\n"
        writer.flush
      }
    end
  end

  class EvidenceYielder
    include ::BEL::Model
    include ::BEL::Quoting

    SPECIAL_ANNOTATIONS = {
      'Citation' => true,
      'Evidence' => true,
    }

    def initialize(data)
      @data                   = data
      @metadata               = Metadata.new
    end

    def each
      if block_given?
        ::BEL::Script.parse(@data).each { |parsed_obj|
          case parsed_obj
          when ::BEL::Language::DocumentProperty
            @metadata.document_header[parsed_obj.name] = parsed_obj.value
          when ::BEL::Language::Statement
            yield to_evidence(parsed_obj, @metadata)
          when ::BEL::Language::AnnotationDefinition
            @metadata.annotation_definitions[parsed_obj.prefix] = {
              :type   => parsed_obj.type,
              :domain => parsed_obj.value
            }
          when ::BEL::Namespace::NamespaceDefinition
            @metadata.namespace_definitions[parsed_obj.prefix] = parsed_obj.url
          end
        }
      else
        to_enum(:each)
      end
    end

    private

    def to_evidence(statement, metadata)
      evidence = Evidence.new
      evidence.bel_statement = statement

      if statement.annotations.include? 'Citation'
        fields              = statement.annotations['Citation'].value
        if fields.respond_to? :each
          evidence.citation = Citation.new(
            *fields.map { |field|
              remove_quotes(field)
            }.to_a
          )
        end
      end

      if statement.annotations.include? 'Evidence'
        value  = statement.annotations['Evidence'].value
        evidence.summary_text.value = value
      end

      experiment_context = statement.annotations.dup
      experiment_context.delete_if { |k, _| SPECIAL_ANNOTATIONS[k] }
      experiment_context.each { |k, v|
        experiment_context[k] = v.value
      }
      evidence.experiment_context = ExperimentContext.new(experiment_context)

      evidence.metadata = metadata
      evidence
    end
  end

  class BELYielder

    def initialize(data, options = {})
      @data = data
      @write_header = (options[:write_header] || false)
    end

    def each
      if block_given?
        header_flag = true
        @data.each { |evidence|
          bel = to_bel(evidence)
          if @write_header && header_flag
            yield document_header(evidence.metadata.document_header)
            yield namespace_definitions(evidence.metadata.namespace_definitions)
            yield annotation_definitions(evidence.metadata.annotation_definitions)
            header_flag = false
          end

          yield bel
        }
      else
        to_enum(:each)
      end
    end

    private

    def document_header(header)
      header.reduce("") { |bel, (name, value)|
        bel << %Q{SET DOCUMENT #{name} = "#{value}"\n}
        bel
      }
    end

    def annotation_definitions(annotation_definitions)
      annotation_definitions.reduce("") { |bel, (prefix, annotation)|
        bel << "DEFINE ANNOTATION #{prefix} AS "
        type   = annotation[:type]   || annotation["type"]
        domain = annotation[:domain] || annotation["domain"]
        case type.to_sym
        when :url
          bel << %Q{URL "#{domain}"\n}
        when :pattern
          bel << %Q{PATTERN "#{domain}"\n}
        when :list
          bel << %Q|LIST {#{domain.inspect[1...-1]}}\n|
        end
        bel
      }
    end

    def namespace_definitions(namespace_definitions)
      namespace_definitions.reduce("") { |bel, (prefix, url)|
        bel << %Q{DEFINE NAMESPACE #{prefix} AS URL "#{url}"\n}
        bel
      }
    end

    def to_bel(evidence)
      bel = ""

      # Citation
      citation = evidence.citation
      if citation
        value = citation.values.collect { |v| v || '' }.inspect
        bel << "SET Citation = {#{citation.values.inspect[1...-1]}}\n"
      end

      # Evidence
      summary_text = evidence.summary_text
      if summary_text
        value = summary_text.value
        value.gsub!("\n", "")
        value.gsub!('"', %Q{\\"})
        bel << %Q{SET Evidence = "#{value}"\n}
      end

      # Annotation
      experiment_context = evidence.experiment_context
      if experiment_context
        experiment_context.sort.each { |key, value|
          if value.respond_to? :each
            value = "{#{value.inspect[1...-1]}}"
          else
            value = value.inspect
          end
          bel << "SET #{key} = #{value}\n"
        }
      end

      # BEL statement
      bel << evidence.bel_statement.to_s
      bel
    end
  end

  register_formatter(FormatBEL.new)
end
