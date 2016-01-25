require 'bel'

module BEL::Translator::Plugins

  module BelScript

    class BelYielder

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

        annotations.reduce("") { |bel, annotation|
          keyword = annotation[:keyword]
          type    = annotation[:type]
          domain  = annotation[:domain]
          bel << "DEFINE ANNOTATION #{keyword} AS "

          case type.to_sym
          when :uri
            bel << %Q{URL "#{domain}"\n}
          when :pattern
            regex = domain.respond_to?(:source) ? domain.source : domain
            bel << %Q{PATTERN "#{regex}"\n}
          when :list
            bel << %Q|LIST {#{domain.inspect[1...-1]}}\n|
          end
          bel
        }
      end

      def namespaces(namespaces)
        return "" unless namespaces

        namespaces.reduce("") { |bel, namespace|
          keyword = namespace[:keyword]
          uri     = namespace[:uri]
          bel << %Q{DEFINE NAMESPACE #{keyword} AS URL "#{uri}"\n}
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
  end
end
