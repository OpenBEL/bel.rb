require 'bel/namespace'
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
      SAXIterator.new(data, EvidenceParser)
    end

    def serialize(objects, writer = StringIO.new)
    end

    private

    class SAXIterator
      include Enumerable

      def initialize(io, handler_class)
        @io            = io
        @handler_class = handler_class
      end

      def each
        evidence_yielder = Proc.new { |evidence|
          yield evidence
        }
        handler = @handler_class.new(evidence_yielder)

        REXML::Document.parse_stream(@io, handler)
      end
    end

    class EvidenceParser
      include REXML::StreamListener
      include ::BEL::Namespace
      include ::BEL::Language

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

      def initialize(yielder)
        @yielder           = yielder
        @element_stack     = []
        @text              = text
        @nspc_defs         = {}
        @anno_defs         = {}
        @current_anno_def  = nil
      end

      def tag_start(name, attributes)
        name.sub!(/^bel:/, '')

        case name
        when NAMESPACE_GROUP
          @nspc_defs      = {}
          @element_stack << :namespace_group
        when ANNOTATION_DEFINITION_GROUP
          @anno_defs      = {}
          @element_stack << :annotation_definition_group
        when NAMESPACE
          if stack_top == :namespace_group
            prefix             = attr_value(attributes, PREFIX)
            resource_location  = attr_value(attributes, RESOURCE_LOCATION)
            @nspc_defs[prefix] = NamespaceDefinition.new(prefix, resource_location)
            @yielder.call(@nspc_defs[prefix])
          end
          @element_stack << :namespace
        when EXTERNAL_ANNOTATION_DEFINITION
          if stack_top == :annotation_definition_group
            id                 = attr_value(attributes, ID)
            url                = attr_value(attributes, URL)
            @anno_defs[id]     = AnnotationDefinition.new(:url, id, url)
            @yielder.call(@anno_defs[id])
          end
          @element_stack << :external_annotation_definition
        when INTERNAL_ANNOTATION_DEFINITION
          if stack_top == :annotation_definition_group
            id                 = attr_value(attributes, ID)
            @current_anno_def  = AnnotationDefinition.new(nil, id, nil)
            @anno_defs[id]     = @current_anno_def
          end
          @element_stack << :internal_annotation_definition
        when LIST_ANNOTATION
          if stack_top == :internal_annotation_definition
            @current_anno_def.type = :list
            # FIXME We cannot save this value to an AnnotationDefinition.
            # We may want to parse to Hash through an abstraction.
          end
          @element_stack << :list_annotation
        when PATTERN_ANNOTATION
          if stack_top == :internal_annotation_definition
            @current_anno_def.type = :pattern
            # FIXME We cannot save this value to an AnnotationDefinition.
            # We may want to parse to Hash through an abstraction.
          end
          @element_stack << :list_annotation
        when STATEMENT_GROUP
          @element_stack << :statement_group
        when STATEMENT
          stmt = Statement.new
          stmt.relationship = attr_value(attributes, RELATIONSHIP)
          if stack_top == :statement_group
            @statement_stack = []
          elsif stack_top == :object
            @statement_stack.last.object = stmt
          end

          @statement_stack << stmt
          @element_stack   << :statement
        when SUBJECT
          @element_stack << :subject
        when OBJECT
          @element_stack << :object
        when TERM
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
        when PARAMETER
          if stack_top == :term
            ns                 = attr_value(attributes, NS)
            @current_parameter = Parameter.new(@nspc_defs[ns], nil)
          end
        end
      end

      def tag_end(name)
        name.sub!(/^bel:/, '')

        case name
        when NAMESPACE_GROUP
          @element_stack.pop
        when ANNOTATION_DEFINITION_GROUP
          @element_stack.pop
        when NAMESPACE
          @element_stack.pop
        when EXTERNAL_ANNOTATION_DEFINITION
          @element_stack.pop
        when INTERNAL_ANNOTATION_DEFINITION
          @yielder.call(@current_anno_def)
          @element_stack.pop
        when LIST_ANNOTATION
          @element_stack.pop
        when PATTERN_ANNOTATION
          begin
            @current_anno_def.value = Regexp.new(@text)
          rescue RegexpError
            @text = Regexp.escape(@text)
            retry
          end
          @element_stack.pop
        when DESCRIPTION
          if stack_top == :internal_annotation_definition
            description       = @text
            # FIXME We cannot save this value to an AnnotationDefinition.
            # We may want to parse to Hash through an abstraction.
          end
        when USAGE
          if stack_top == :internal_annotation_definition
            usage             = @text
            # FIXME We cannot save this value to an AnnotationDefinition.
            # We may want to parse to Hash through an abstraction.
          end
        when LIST_VALUE
          if stack_top == :list_annotation
            (@current_anno_def.value ||= []) << @text
            # FIXME We cannot save this value to an AnnotationDefinition.
            # We may want to parse to Hash through an abstraction.
          end
        when STATEMENT_GROUP
          @element_stack.pop
        when STATEMENT
          @element_stack.pop

          stmt = @statement_stack.pop
          if @statement_stack.empty?
            @yielder.call(stmt)
          end
        when SUBJECT
          @statement_stack.last.subject = @term_stack.last
          @element_stack.pop
        when OBJECT
          if @statement_stack.last.object == nil
            # sets object if it wasn't already set by OBJECT STATEMENT
            @statement_stack.last.object  = @term_stack.last
          end
          @element_stack.pop
        when TERM
          @element_stack.pop

          if @term_stack.size > 1
            @term_stack.pop
            @current_term = @term_stack.last
          end
        when PARAMETER
          @current_parameter.value    = @text
          @term_stack.last.arguments << @current_parameter
        end
      end

      def text(*args)
        if args.size.zero?
          @text = ''
        else
          @text = args.first
        end
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
