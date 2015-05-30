require 'bel/evidence_model'
require 'bel/language'
require 'rexml/document'
require 'rexml/streamlistener'

module BEL::Extension::Format

  class FormatXBEL

    include Formatter
    ID = :xbel

    def id
      ID
    end

    def deserialize(data)
      EvidenceYielder.new(data)
    end

    def serialize(objects, writer = StringIO.new)
    end

    private

    class EvidenceYielder

      def initialize(io)
        @io = io
      end

      def each(&block)
        if block_given?
          handler = EvidenceHandler.new(block)
          REXML::Document.parse_stream(@io, handler)
        else
          to_enum(:each)
        end
      end
    end

    class EvidenceHandler
      include REXML::StreamListener
      include ::BEL::Model

      ANNOTATION                     = "annotation"
      ANNOTATION_DEFINITION_GROUP    = "annotationDefinitionGroup"
      ANNOTATION_GROUP               = "annotationGroup"
      AUTHOR                         = "author"
      AUTHOR_GROUP                   = "authorGroup"
      CITATION                       = "citation"
      COMMENT                        = "comment"
      CONTACT_INFO                   = "contactInfo"
      COPYRIGHT                      = "copyright"
      DATE                           = "date"
      DESCRIPTION                    = "description"
      DOCUMENT                       = "document"
      EVIDENCE                       = "evidence"
      EXTERNAL_ANNOTATION_DEFINITION = "externalAnnotationDefinition"
      FUNCTION                       = "function"
      HEADER                         = "header"
      ID                             = "id"
      INTERNAL_ANNOTATION_DEFINITION = "internalAnnotationDefinition"
      LICENSE                        = "license"
      LICENSE_GROUP                  = "licenseGroup"
      LIST_ANNOTATION                = "listAnnotation"
      LIST_VALUE                     = "listValue"
      NAME                           = "name"
      NAMESPACE                      = "namespace"
      NAMESPACE_GROUP                = "namespaceGroup"
      NS                             = "ns"
      OBJECT                         = "object"
      PARAMETER                      = "parameter"
      PATTERN_ANNOTATION             = "patternAnnotation"
      PREFIX                         = "prefix"
      REFERENCE                      = "reference"
      REF_ID                         = "refID"
      RELATIONSHIP                   = "relationship"
      RESOURCE_LOCATION              = "resourceLocation"
      STATEMENT                      = "statement"
      STATEMENT_GROUP                = "statementGroup"
      SUBJECT                        = "subject"
      TERM                           = "term"
      TYPE                           = "type"
      URL                            = "url"
      USAGE                          = "usage"
      VERSION                        = "version"

      def initialize(callable)
        @callable          = callable
        @element_stack     = []
        @text              = nil
        @evidence          = Evidence.new
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
          @evidence.metadata.namespace_definitions[prefix] = resource_location
        end
        @element_stack << :namespace
      end

      def start_external_annotation_definition(attributes)
        if stack_top == :annotation_definition_group
          id                 = attr_value(attributes, ID)
          url                = attr_value(attributes, URL)
          @evidence.metadata.annotation_definitions[id] = {
            :type   => :url,
            :domain => url
          }
        end
        @element_stack << :external_annotation_definition
      end

      def start_internal_annotation_definition(attributes)
        if stack_top == :annotation_definition_group
          id                 = attr_value(attributes, ID)
          @current_anno_def  = {}
          @evidence.metadata.annotation_definitions[id] = @current_anno_def
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
        elsif stack_top == :object
          @statement_stack.last.object = stmt
        else
          puts stack_top
        end

        @statement_stack << stmt
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
          ns_id              = attr_value(attributes, NS)
          # XXX Hitting a SystemStackError on line 174 (inside call).
          # Example: large_corpus.xbel
          ns                 = {
            :prefix => ns_id,
            :url    => @evidence.metadata.namespace_definitions[ns_id]
          }
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

      def start_evidence(attributes)
        @element_stack << :evidence
      end

      # End element methods, dynamically invoked.

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
          @evidence.bel_statement = stmt
          @callable.call(@evidence)

          # create new evidence with existing metadata;
          # header and definitions
          @evidence = Evidence.create({
            :metadata => @evidence.metadata
          })
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
        if @element_stack[-2] == :statement
          ref_id = @annotation_id

          value  = @evidence.experiment_context[ref_id]
          if value
            # create array for multiple values by refID
            @evidence.experiment_context[ref_id] = [value, @text].flatten
          else
            @evidence.experiment_context[ref_id] = @text
          end
        end

        @element_stack.pop
      end

      def end_evidence
        if @element_stack[-3] == :statement
          @evidence.summary_text.value = @text
        end

        @element_stack.pop
      end

      private

      def stack_top
        @element_stack.last
      end

      def attr_value(attributes, attr_name)
        attributes["bel:#{attr_name}"]
      end
    end
  end

  register_formatter(FormatXBEL.new)
end
