require 'rexml/streamlistener'

module BEL::Translator::Plugins

  module Xbel

    class NanopubHandler
      include REXML::StreamListener
      include ::BEL::Nanopub

      ANNOTATION                     = 'annotation'
      ANNOTATION_DEFINITION_GROUP    = 'annotationDefinitionGroup'
      ANNOTATION_GROUP               = 'annotationGroup'
      AUTHOR                         = 'author'
      AUTHOR_GROUP                   = 'authorGroup'
      CITATION                       = 'citation'
      COMMENT                        = 'comment'
      CONTACT_INFO                   = 'contactInfo'
      COPYRIGHT                      = 'copyright'
      DATE                           = 'date'
      DESCRIPTION                    = 'description'
      DOCUMENT                       = 'document'
      EXTERNAL_ANNOTATION_DEFINITION = 'externalAnnotationDefinition'
      FUNCTION                       = 'function'
      HEADER                         = 'header'
      ID                             = 'id'
      INTERNAL_ANNOTATION_DEFINITION = 'internalAnnotationDefinition'
      LICENSE                        = 'license'
      LICENSE_GROUP                  = 'licenseGroup'
      LIST_ANNOTATION                = 'listAnnotation'
      LIST_VALUE                     = 'listValue'
      NAME                           = 'name'
      NAMESPACE                      = 'namespace'
      NAMESPACE_GROUP                = 'namespaceGroup'
      NANOPUB                        = 'nanopub'
      NS                             = 'ns'
      OBJECT                         = 'object'
      PARAMETER                      = 'parameter'
      PATTERN_ANNOTATION             = 'patternAnnotation'
      PREFIX                         = 'prefix'
      REFERENCE                      = 'reference'
      REF_ID                         = 'refID'
      RELATIONSHIP                   = 'relationship'
      RESOURCE_LOCATION              = 'resourceLocation'
      STATEMENT                      = 'statement'
      STATEMENT_GROUP                = 'statementGroup'
      SUBJECT                        = 'subject'
      TERM                           = 'term'
      TYPE                           = 'type'
      URL                            = 'url'
      USAGE                          = 'usage'
      VERSION                        = 'version'

      def initialize(callable)
        @callable          = callable
        @element_stack     = []
        @text              = nil
        @nanopub          = Nanopub.new
      end

      # Called on element start by REXML.
      def tag_start(name, attributes)
        name.
          sub!(/^bel:/, '').
          gsub!(/([A-Z])/) { |match| "_#{match.downcase}" }

        start_method = "start_#{name}"
        if self.respond_to? start_method
          self.send(start_method, attributes)
        end
      end

      # Called on element end by REXML.
      def tag_end(name)
        name.
          sub!(/^bel:/, '').
          gsub!(/([A-Z])/) { |match| "_#{match.downcase}" }

        end_method = "end_#{name}"
        if self.respond_to? end_method
          self.send end_method
        end
      end

      # Called on text node by REXML.
      def text(*args)
        if args.size.zero?
          @text = ''
        else
          @text = args.first
        end
      end

      # Start element methods, dynamically invoked.

      def start_header(attributes)
        @element_stack << :header
      end

      def start_namespace_group(attributes)
        @element_stack << :namespace_group
      end

      def start_annotation_definition_group(attributes)
        @element_stack << :annotation_definition_group
      end

      def start_namespace(attributes)
        if stack_top == :namespace_group
          prefix             = attr_value(attributes, PREFIX)
          resource_location  = attr_value(attributes, RESOURCE_LOCATION)
          @nanopub.references.add_namespace(prefix, resource_location)
        end
        @element_stack << :namespace
      end

      def start_external_annotation_definition(attributes)
        if stack_top == :annotation_definition_group
          id                 = attr_value(attributes, ID)
          uri                = attr_value(attributes, URL)
          @nanopub.references.add_annotation(
            attr_value(attributes, ID),
            :uri,
            attr_value(attributes, URL)
          )
        end
        @element_stack << :external_annotation_definition
      end

      def start_internal_annotation_definition(attributes)
        if stack_top == :annotation_definition_group
          @current_anno_def = {
            :keyword => attr_value(attributes, ID)
          }
        end
        @element_stack << :internal_annotation_definition
      end

      def start_list_annotation(attributes)
        if stack_top == :internal_annotation_definition
          @current_anno_def[:type]   = :list
          @current_anno_def[:domain] = []
        end
        @element_stack << :list_annotation
      end

      def start_pattern_annotation(attributes)
        if stack_top == :internal_annotation_definition
          @current_anno_def[:type] = :pattern
        end
        @element_stack << :pattern_annotation
      end

      def start_statement_group(attributes)
        @element_stack << :statement_group
      end

      def start_statement(attributes)
        stmt = Statement.new
        stmt.relationship = attr_value(attributes, RELATIONSHIP)
        if stack_top == :statement_group
          @statement_stack = []
          @statement_stack << stmt
        elsif stack_top == :object
          @statement_stack.last.object = stmt
          @statement_stack << stmt
        end

        @element_stack << :statement
      end

      def start_subject(attributes)
        @element_stack << :subject
      end

      def start_object(attributes)
        @element_stack << :object
      end

      def start_term(attributes)
        term = Term.new(attr_value(attributes, FUNCTION), [])
        if stack_top == :subject || stack_top == :object
          # outer term
          @term_stack = []
        elsif stack_top == :term
          # nested term
          @term_stack.last.arguments << term
        end

        @term_stack    << term
        @element_stack << :term
      end

      def start_parameter(attributes)
        if stack_top == :term
          ns =
            if has_attr?(attributes, NS)
              ns_id = attr_value(attributes, NS)
              namespace_reference(ns_id, @nanopub)
            else
              nil
            end
          @current_parameter = Parameter.new(ns, nil)
        end
        @element_stack << :parameter
      end

      def start_annotation_group(attributes)
        @annotation_id = nil
        @element_stack << :annotation_group
      end

      def start_annotation(attributes)
        if @element_stack[-2] == :statement
          ref_id = attr_value(attributes, REF_ID)
          @annotation_id = ref_id
          @element_stack << :annotation
        end
      end

      def start_citation(attributes)
        type = attr_value(attributes, TYPE)
        @nanopub.citation.type = type
        @element_stack << :citation
      end

      def start_nanopub(attributes)
        @element_stack << :nanopub
      end

      # End element methods, dynamically invoked.

      def end_header
        @element_stack.pop
      end

      def end_version
        if stack_top == :header
          @nanopub.metadata.document_header[:Version] = @text
        end
      end

      def end_copyright
        if stack_top == :header
          @nanopub.metadata.document_header[:Copyright] = @text
        end
      end

      def end_contact_info
        if stack_top == :header
          @nanopub.metadata.document_header[:ContactInfo] = @text
        end
      end

      def end_license
        if stack_top == :header
          @nanopub.metadata.document_header[:Licenses] ||= []
          @nanopub.metadata.document_header[:Licenses]  << @text
        end
      end

      def end_namespace_group
        @element_stack.pop
      end

      def end_annotation_definition_group
        @element_stack.pop
      end

      def end_namespace
        @element_stack.pop
      end

      def end_external_annotation_definition
        @element_stack.pop
      end

      def end_internal_annotation_definition
        @element_stack.pop
        @nanopub.references.add_annotation(
          @current_anno_def[:keyword],
          @current_anno_def[:type],
          @current_anno_def[:domain],
        )
      end

      def end_list_annotation
        @element_stack.pop
      end

      def end_pattern_annotation
        begin
          @current_anno_def[:domain] = Regexp.new(@text)
        rescue RegexpError
          @text = Regexp.escape(@text)
          retry
        end
        @element_stack.pop
      end

      def end_description
        if stack_top == :header
          @nanopub.metadata.document_header[:Description] = @text
        end

        if stack_top == :internal_annotation_definition
          @current_anno_def[:description] = @text
        end
      end

      def end_usage
        if stack_top == :internal_annotation_definition
          @current_anno_def[:usage] = @text
        end
      end

      def end_list_value
        if stack_top == :list_annotation
          @current_anno_def[:domain] << @text
        end
      end

      def end_statement_group
        @element_stack.pop
      end

      def end_statement
        @element_stack.pop

        stmt = @statement_stack.pop
        if @statement_stack.empty?
          # create new nanopub from parsed data
          nanopub_copy = Nanopub.create({
            :bel_statement      => stmt,
            :citation           => @nanopub.citation.to_h,
            :support            => @nanopub.support.value,
            :experiment_context => @nanopub.experiment_context.values.dup,
            :references         => @nanopub.references.values.dup,
            :metadata           => @nanopub.metadata.values.dup
          })

          # yield nanopub
          @callable.call(nanopub_copy)

          # clear nanopub parser state
          # note:
          #   - preserve @nanopub.references
          #   - preserve @nanopub.metadata.document_header
          @nanopub.bel_statement      = nil
          @nanopub.citation           = nil
          @nanopub.support            = nil
          @nanopub.experiment_context = nil
          @nanopub.metadata.delete_if { |key|
            key != :document_header
          }
        end
      end

      def end_subject
        @statement_stack.last.subject = @term_stack.last
        @element_stack.pop
      end

      def end_object
        if @statement_stack.last.object == nil
          # sets object if it wasn't already set by OBJECT STATEMENT
          @statement_stack.last.object  = @term_stack.last
        end
        @element_stack.pop
      end

      def end_term
        @element_stack.pop

        if @term_stack.size > 1
          @term_stack.pop
          @current_term = @term_stack.last
        end
      end

      def end_parameter
        @current_parameter.value    = @text
        @term_stack.last.arguments << @current_parameter
        @element_stack.pop
      end

      def end_annotation_group
        @element_stack.pop
      end

      def end_annotation
        if @element_stack[-3] == :statement
          ref_id = @annotation_id

          annotation  = @nanopub.experiment_context.find { |annotation|
            annotation[:name] == ref_id
          }
          if annotation
            # create array for multiple values by refID
            annotation[:value] = [annotation[:value], @text].flatten
          else
            @nanopub.experiment_context << {
              :name  => ref_id,
              :value => @text
            }
          end
        end

        @element_stack.pop
      end

      def end_nanopub
        if @element_stack[-3] == :statement
          @nanopub.support.value = @text
        end

        @element_stack.pop
      end

      def end_citation
        @element_stack.pop
      end

      def end_reference
        if stack_top == :citation
          @nanopub.citation.id   = @text
        end
      end

      def end_name
        if stack_top == :header
          @nanopub.metadata.document_header[:Name] = @text
        end

        if stack_top == :citation
          @nanopub.citation.name = @text
        end
      end

      def end_date
        if stack_top == :citation
          @nanopub.citation.date = @text
        end
      end

      def end_author
        if stack_top == :header
          @nanopub.metadata.document_header[:Authors] ||= []
          @nanopub.metadata.document_header[:Authors] <<  @text
        end

        if stack_top == :citation
          @nanopub.citation.authors ||= []
          @nanopub.citation.authors  << @text
        end
      end

      def end_comment
        if stack_top == :citation
          @nanopub.citation.comment = @text
        end
      end

      private

      def stack_top
        @element_stack.last
      end

      def attr_value(attributes, attr_name)
        attributes["bel:#{attr_name}"]
      end

      def has_attr?(attributes, attr_name)
        attributes.has_key?("bel:#{attr_name}")
      end

      def namespace_reference(ns_id, nanopub)
        ns_id = ns_id.to_sym
        namespace_reference = nanopub.references.namespaces.find { |ns|
          ns[:keyword] == ns_id
        }

        if namespace_reference
          {
            :prefix => namespace_reference[:keyword],
            :url    => namespace_reference[:uri]
          }
        else
          nil
        end
      end
    end
  end
end
