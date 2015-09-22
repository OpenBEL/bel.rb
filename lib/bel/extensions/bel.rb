require 'bel'

module BEL::Extension::Format

  class FormatBEL

    include Formatter

    ID          = :bel
    MEDIA_TYPES = %i(application/bel)
    EXTENSIONS  = %i(bel)
    
    def id
      ID
    end

    def media_types
      MEDIA_TYPES
    end

    def file_extensions
      EXTENSIONS
    end

    def deserialize(data, &block)
      EvidenceYielder.new(data)
    end

    def serialize(objects, writer = StringIO.new, options = {})
      BELYielder.new(objects).each { |bel_part|
        writer << "#{bel_part}"
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
            @references.annotations[parsed_obj.prefix] = {
              :type   => parsed_obj.type,
              :domain => parsed_obj.value
            }
          when ::BEL::Namespace::NamespaceDefinition
            @references.namespaces[parsed_obj.prefix] = parsed_obj.url
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

          annotation_def = references.annotations[k]
          if annotation_def
            type, domain = annotation_def.values_at(:type, :domain)
            if type == :url
              obj[:uri] = "#{domain}/#{value}"
              obj[:url] = domain
            end
          end

          obj
        }
      )

      evidence.references = references
      evidence.metadata   = metadata
      evidence
    end
  end

  class BELYielder

    def initialize(data, options = {})
      @data = data
      @write_header = (options[:write_header] || true)
    end

    def each
      if block_given?
        header_flag = true
        @data.each { |evidence|
          bel = to_bel(evidence)
          if @write_header && header_flag
            yield document_header(evidence.metadata.document_header)
            yield namespaces(
              evidence.references.namespaces
            )
            yield annotations(
              evidence.references.annotations
            )
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
      return "" unless header

      header.reduce("") { |bel, (name, value)|
        name_s  = name.to_s
        value_s =
          if value.respond_to?(:each)
            value.join('|')
          else
            value.to_s
          end

        # handle casing for document properties (special case, contactinfo)
        name_s = (name_s.downcase == 'contactinfo') ?
          'ContactInfo' :
          name_s.capitalize

        bel << %Q{SET DOCUMENT #{name_s} = "#{value_s}"\n}
        bel
      }
    end

    def annotations(annotations)
      return "" unless annotations

      annotations.reduce("") { |bel, (prefix, annotation)|
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

    def namespaces(namespaces)
      return "" unless namespaces

      namespaces.reduce("") { |bel, (prefix, url)|
        bel << %Q{DEFINE NAMESPACE #{prefix} AS URL "#{url}"\n}
        bel
      }
    end

    def to_bel(evidence)
      bel = ""

      # Citation
      citation = evidence.citation
      if citation && citation.valid?
        values = citation.to_a
        values.map! { |v| v || "" }
        values.map! { |v|
          if v.respond_to?(:each)
            v.join('|')
          else
            v
          end
        }
        value_string = values.inspect[1...-1]
        bel << "SET Citation = {#{value_string}}\n"
      end

      # Evidence
      summary_text = evidence.summary_text
      if summary_text && summary_text.value
        value = summary_text.value
        value.gsub!("\n", "")
        value.gsub!('"', %Q{\\"})
        bel << %Q{SET Evidence = "#{value}"\n}
      end

      # Annotation
      experiment_context = evidence.experiment_context
      if experiment_context
        experiment_context.
          sort_by { |obj| obj[:name] }.
          each    { |obj|
            name, value = obj.values_at(:name, :value)
            if value.respond_to? :each
              value = "{#{value.inspect[1...-1]}}"
            else
              value = value.inspect
            end
            bel << "SET #{name} = #{value}\n"
          }
      end

      # BEL statement
      bel << "#{evidence.bel_statement.to_s}\n"
      bel
    end
  end

  register_formatter(FormatBEL.new)
end
