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
      XBELYielder.new(objects).each { |xml_data|
        writer << xml_data
        writer.flush
      }
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

    class XBELYielder

      def initialize(data, options = {})
        @data         = data
        @write_header = options.fetch(:write_header, true)
      end

      def each
        if block_given?
          header_flag        = true
          el_document        = nil
          el_statement_group = nil
          @data.each { |evidence|
            if header_flag
              # document header
              el_document = XBELYielder.document
              el_statement_group = XBELYielder.statement_group

              yield start_element_string(el_document)

              if @write_header
                yield element_string(
                  XBELYielder.header(evidence.metadata.document_header)
                )
                yield element_string(
                  XBELYielder.namespace_definitions(evidence.metadata.namespace_definitions)
                )
                yield element_string(
                  XBELYielder.annotation_definitions(evidence.metadata.annotation_definitions)
                )
              end

              yield start_element_string(el_statement_group)

              header_flag = false
            end

            yield element_string(XBELYielder.statement(evidence.bel_statement))
          }

          yield end_element_string(el_statement_group)
          yield end_element_string(el_document)
        else
          to_enum(:each)
        end
      end

      def self.statement(statement)
        el_statement = REXML::Element.new('bel:statement')

        if statement.relationship
          el_statement.add_attribute 'bel:relationship', statement.relationship
        end

        el_subject = self.subject(statement.subject)
        el_statement.add_element(el_subject)

        if statement.object
          el_object = self.object(statement.object)
          el_statement.add_element(el_object)
        end

        el_statement
      end

      def self.subject(subject)
        el_subject = REXML::Element.new('bel:subject')
        el_subject.add_element(self.term(subject))
      end

      def self.object(object)
        el_object = REXML::Element.new('bel:object')

        case object
        when BEL::Model::Term
          el_object.add_element(self.term(object))
        when BEL::Model::Statement
          el_object.add_element(self.statement(object))
        end
        el_object
      end

      def self.term(term)
        el_term    = REXML::Element.new('bel:term')
        el_term.add_attribute 'bel:function', term.fx

        term.arguments.each do |arg|
          case arg
          when BEL::Model::Term
            el_term.add_element(self.term(arg))
          when BEL::Model::Parameter
            el_term.add_element(self.parameter(arg))
          end
        end
        el_term
      end

      def self.parameter(parameter)
        el_parameter      = REXML::Element.new('bel:parameter')
        el_parameter.text = parameter.value
        el_parameter.add_attribute 'bel:ns', parameter.ns
        el_parameter
      end

      def self.document
        el = REXML::Element.new('bel:document')
        el.add_namespace('bel', 'http://belframework.org/schema/1.0/xbel')
        el.add_namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
        el.add_attribute('xsi:schemaLocation', 'http://belframework.org/schema/1.0/xbel http://resource.belframework.org/belframework/1.0/schema/xbel.xsd')

        el
      end

      def self.statement_group(declare_namespaces = false)
        el = REXML::Element.new('bel:statementGroup')

        if declare_namespaces
          el.add_namespace('bel', 'http://belframework.org/schema/1.0/xbel')
          el.add_namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
          el.add_attribute('xsi:schemaLocation', 'http://belframework.org/schema/1.0/xbel http://resource.belframework.org/belframework/1.0/schema/xbel.xsd')
        end

        el
      end

      def self.header(hash)
        el_header = REXML::Element.new('bel:header')

        # normalize hash keys
        hash = Hash[
          hash.map { |k, v|
            k = k.to_s.dup
            k.downcase!
            k.gsub!(/[-_ .]/, '')
            [k, v]
          }
        ]

        (%w(name description version copyright) & hash.keys).each do |field|
          el      = REXML::Element.new("bel:#{field}")
          el.text = hash[field]
          el_header.add_element(el)
        end

        # add contactinfo with different element name (contactInfo)
        if hash.has_key?('contactinfo')
          el      = REXML::Element.new('bel:contactInfo')
          el.text = hash['contactinfo']
          el_header.add_element(el)
        end

        # handle grouping for authors and licenses
        if hash.has_key?('authors')
          authors  = hash['authors']
          el_group = REXML::Element.new('bel:authorGroup')

          [authors].flatten.each do |author|
            el      = REXML::Element.new('bel:author')
            el.text = author.to_s
            el_group.add_element(el)
          end
          el_header.add_element(el_group)
        end
        if hash.has_key?('licenses')
          licenses = hash['licenses']
          el_group = REXML::Element.new('bel:licenseGroup')

          [licenses].flatten.each do |license|
            el      = REXML::Element.new('bel:license')
            el.text = license.to_s
            el_group.add_element(el)
          end
          el_header.add_element(el_group)
        end

        el_header
      end

      def self.namespace_definitions(hash)
        el_nd = REXML::Element.new('bel:namespaceGroup')
        hash.each do |k, v|
          el = REXML::Element.new('bel:namespace')
          el.add_attribute 'bel:prefix',           k.to_s
          el.add_attribute 'bel:resourceLocation', v.to_s
          el_nd.add_element(el)
        end

        el_nd
      end

      def self.annotation_definitions(hash)
        el_ad = REXML::Element.new('bel:annotationDefinitionGroup')
        hash.each do |k, v|
          type, domain = v.values_at(:type, :domain)
          case type.to_sym
          when :url
            el = REXML::Element.new('bel:externalAnnotationDefinition')
            el.add_attribute 'bel:url', domain.to_s
            el.add_attribute 'bel:id',  k.to_s
          when :pattern
            el = REXML::Element.new('bel:internalAnnotationDefinition')
            el.add_attribute 'bel:id', k.to_s

            el_pattern      = REXML::Element.new('bel:patternAnnotation')
            el_pattern.text =
              domain.respond_to?(:source) ? domain.source : domain.to_s

            el.add_element(el_pattern)
          when :list
            el = REXML::Element.new('bel:internalAnnotationDefinition')
            el.add_attribute 'bel:id', k.to_s

            el_list = REXML::Element.new('bel:listAnnotation')
            if domain.respond_to?(:each)
              domain.each do |value|
                el_list_value      = REXML::Element.new('bel:listValue')
                el_list_value.text = value.to_s
                el_list.add_element(el_list_value)
              end
            else
              el_list_value      = REXML::Element.new('bel:listValue')
              el_list_value.text = domain.to_s
              el_list.add_element(el_list_value)
            end

            el.add_element(el_list)
          else
            el = nil
          end

          el_ad.add_element(el) if el
        end

        el_ad
      end

      def start_element_string(element)
        element.to_s.gsub(%r{(/>)}, '>')
      end
      private :start_element_string

      def end_element_string(element)
        "</#{element.expanded_name}>"
      end
      private :end_element_string

      def element_string(element)
        element.to_s
      end
      private :element_string
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
          # create new evidence from parsed data
          evidence_copy = Evidence.create({
            :bel_statement      => stmt,
            :citation           => nil,
            :summary_text       => @evidence.summary_text.value,
            :experiment_context => @evidence.experiment_context.values.dup,
            :metadata           => @evidence.metadata.values.dup
          })

          # yield evidence
          @callable.call(evidence_copy)

          # clear evidence parser state
          # note: this preserves @evidence.metadata for the definitions
          @evidence.bel_statement      = nil
          @evidence.citation           = nil
          @evidence.summary_text       = nil
          @evidence.experiment_context = nil
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
