require 'bel/evidence_model'
require 'bel/language'
require 'rexml/document'
require 'rexml/streamlistener'

module BEL::Extension::Format

  class FormatXBEL

    include Formatter
    ID          = :xbel
    MEDIA_TYPES = %i(application/xml)
    EXTENSIONS  = %i(xml xbel)

    def id
      ID
    end

    def media_types
      MEDIA_TYPES
    end

    def file_extensions
      EXTENSIONS
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

      FUNCTIONS = ::BEL::Language::FUNCTIONS

      def initialize(data, options = {})
        @data         = data
      end

      def each
        if block_given?
          header_flag        = true

          # yield <document>
          el_document = XBELYielder.document
          yield start_element_string(el_document)

          el_statement_group = nil
          evidence_count = 0
          @data.each { |evidence|
            if header_flag
              # document header
              el_statement_group = XBELYielder.statement_group

              yield element_string(
                XBELYielder.header(evidence.metadata.document_header)
              )
              yield element_string(
                XBELYielder.namespace_definitions(evidence.references.namespaces)
              )
              yield element_string(
                XBELYielder.annotation_definitions(evidence.references.annotations)
              )

              yield start_element_string(el_statement_group)

              header_flag = false
            end

            yield element_string(XBELYielder.evidence(evidence))
            evidence_count += 1
          }

          if evidence_count > 0
            yield end_element_string(el_statement_group)
          else
            # empty head sections; required for XBEL schema
            empty_header = Hash[%w(name description version).map { |element|
              [element, ""]
            }]
            yield element_string(XBELYielder.header(empty_header))
            yield element_string(XBELYielder.namespace_definitions({}))
            yield element_string(XBELYielder.annotation_definitions({}))
            yield element_string(XBELYielder.statement_group)
          end
          yield end_element_string(el_document)
        else
          to_enum(:each)
        end
      end

      def self.evidence(evidence)
        statement    = evidence.bel_statement
        el_statement = REXML::Element.new('bel:statement')

        el_statement.add_element(self.annotation_group(evidence))
        self.statement(statement, el_statement)

        el_statement
      end

      def self.statement(statement, el_statement)
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

        el_subject
      end

      def self.object(object)
        el_object = REXML::Element.new('bel:object')

        case object
        when BEL::Model::Term
          el_object.add_element(self.term(object))
        when BEL::Model::Statement
          el_statement = REXML::Element.new('bel:statement')
          el_object.add_element(el_statement)
          self.statement(object, el_statement)
        end
        el_object
      end

      def self.term(term)
        el_term    = REXML::Element.new('bel:term')
        term_fx    = term.fx.to_s
        term_fx    = (
                       FUNCTIONS.fetch(term_fx.to_sym, {}).
                                 fetch(:long_form, nil) || term_fx
                     ).to_s

        el_term.add_attribute 'bel:function', term_fx

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

      def self.annotation_group(evidence)
        el_ag = REXML::Element.new('bel:annotationGroup')

        # XBEL citation
        if evidence.citation && evidence.citation.valid?
          el_ag.add_element(self.citation(evidence.citation))
        end

        # XBEL evidence (::BEL::Model::SummaryText)
        if evidence.summary_text && evidence.summary_text.value
          xbel_evidence      = REXML::Element.new('bel:evidence')
          xbel_evidence.text = evidence.summary_text.value
          el_ag.add_element(xbel_evidence)
        end

        evidence.experiment_context.each do |annotation|
          name, value = annotation.values_at(:name, :value)

          if value.respond_to?(:each)
            value.each do |v|
              el_anno      = REXML::Element.new('bel:annotation')
              el_anno.text = v
              el_anno.add_attribute 'bel:refID', name.to_s

              el_ag.add_element(el_anno)
            end
          else
              el_anno      = REXML::Element.new('bel:annotation')
              el_anno.text = value
              el_anno.add_attribute 'bel:refID', name.to_s

              el_ag.add_element(el_anno)
          end
        end

        metadata_keys = evidence.metadata.keys - [:document_header]
        metadata_keys.each do |k|
          v = evidence.metadata[k]
          if v.respond_to?(:each)
            v.each do |value|
              el_anno      = REXML::Element.new('bel:annotation')
              el_anno.text = value
              el_anno.add_attribute 'bel:refID', k.to_s

              el_ag.add_element(el_anno)
            end
          else
            el_anno      = REXML::Element.new('bel:annotation')
            el_anno.text = v
            el_anno.add_attribute 'bel:refID', k.to_s

            el_ag.add_element(el_anno)
          end
        end

        el_ag
      end

      def self.citation(citation)
        el_citation  = REXML::Element.new('bel:citation')

        if citation.type && !citation.type.to_s.empty?
          el_citation.add_attribute 'bel:type', citation.type
        end

        if citation.id && !citation.id.to_s.empty?
          el_reference      = REXML::Element.new('bel:reference')
          el_reference.text = citation.id
          el_citation.add_element(el_reference)
        end

        if citation.name && !citation.name.to_s.empty?
          el_name         = REXML::Element.new('bel:name')
          el_name.text    = citation.name
          el_citation.add_element(el_name)
        end

        if citation.date && !citation.date.to_s.empty?
          el_date         = REXML::Element.new('bel:date')
          el_date.text    = citation.date
          el_citation.add_element(el_date)
        end

        if citation.comment && !citation.comment.to_s.empty?
          el_comment      = REXML::Element.new('bel:comment')
          el_comment.text = citation.comment
          el_citation.add_element(el_comment)
        end

        if citation.authors && !citation.authors.to_s.empty?
          el_author_group = REXML::Element.new('bel:authorGroup')
          citation.authors.each do |author|
            el_author      = REXML::Element.new('bel:author')
            el_author.text = author
            el_author_group.add_element(el_author)
          end
          el_citation.add_element(el_author_group)
        end

        el_citation
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
          el               = REXML::Element.new('bel:namespace')
          el.add_attribute 'bel:prefix', k.to_s

          resourceLocation = v.respond_to?(:url) ? v.url : v
          el.add_attribute 'bel:resourceLocation', "#{resourceLocation}"

          el_nd.add_element(el)
        end

        el_nd
      end

      def self.annotation_definitions(hash)
        el_ad = REXML::Element.new('bel:annotationDefinitionGroup')
        internal = []
        external = []
        hash.each do |k, v|
          type, domain = v.values_at(:type, :domain)
          case type.to_sym
          when :url
            el = REXML::Element.new('bel:externalAnnotationDefinition')
            el.add_attribute 'bel:url', domain.to_s
            el.add_attribute 'bel:id',  k.to_s
            external << el
          when :pattern
            el = REXML::Element.new('bel:internalAnnotationDefinition')
            el.add_attribute 'bel:id', k.to_s
            el.add_element(REXML::Element.new('bel:description'))
            el.add_element(REXML::Element.new('bel:usage'))

            el_pattern      = REXML::Element.new('bel:patternAnnotation')
            el_pattern.text =
              domain.respond_to?(:source) ? domain.source : domain.to_s

            el.add_element(el_pattern)
            internal << el
          when :list
            el = REXML::Element.new('bel:internalAnnotationDefinition')
            el.add_attribute 'bel:id', k.to_s
            el.add_element(REXML::Element.new('bel:description'))
            el.add_element(REXML::Element.new('bel:usage'))

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
            internal << el
          else
            el = nil
          end
        end

        # first add internal annotation definitions
        internal.each do |internal_element|
          el_ad.add_element(internal_element)
        end

        # second add external annotation definitions
        external.each do |external_element|
          el_ad.add_element(external_element)
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
          @evidence.references.namespaces[prefix] = resource_location
        end
        @element_stack << :namespace
      end

      def start_external_annotation_definition(attributes)
        if stack_top == :annotation_definition_group
          id                 = attr_value(attributes, ID)
          url                = attr_value(attributes, URL)
          @evidence.references.annotations[id] = {
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
          @evidence.references.annotations[id] = @current_anno_def
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
            :url    => @evidence.references.namespaces[ns_id]
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

      def start_citation(attributes)
        type = attr_value(attributes, TYPE)
        @evidence.citation.type = type
        @element_stack << :citation
      end

      def start_evidence(attributes)
        @element_stack << :evidence
      end

      # End element methods, dynamically invoked.

      def end_header
        @element_stack.pop
      end

      def end_version
        if stack_top == :header
          @evidence.metadata.document_header['version'] = @text
        end
      end

      def end_copyright
        if stack_top == :header
          @evidence.metadata.document_header['copyright'] = @text
        end
      end

      def end_contact_info
        if stack_top == :header
          @evidence.metadata.document_header['contactInfo'] = @text
        end
      end

      def end_license
        if stack_top == :header
          @evidence.metadata.document_header['licenses'] ||= []
          @evidence.metadata.document_header['licenses'] <<  @text
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
          @evidence.metadata.document_header['description'] = @text
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
          # create new evidence from parsed data
          evidence_copy = Evidence.create({
            :bel_statement      => stmt,
            :citation           => @evidence.citation.to_h,
            :summary_text       => @evidence.summary_text.value,
            :experiment_context => @evidence.experiment_context.values.dup,
            :references         => @evidence.references.values.dup,
            :metadata           => @evidence.metadata.values.dup
          })

          # yield evidence
          @callable.call(evidence_copy)

          # clear evidence parser state
          # note:
          #   - preserve @evidence.references
          #   - preserve @evidence.metadata.document_header
          @evidence.bel_statement      = nil
          @evidence.citation           = nil
          @evidence.summary_text       = nil
          @evidence.experiment_context = nil
          @evidence.metadata.delete_if { |key|
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

          annotation  = @evidence.experiment_context.find { |annotation|
            annotation[:name] == ref_id
          }
          if annotation
            # create array for multiple values by refID
            annotation[:value] = [annotation[:value], @text].flatten
          else
            @evidence.experiment_context << {
              :name  => ref_id,
              :value => @text
            }
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

      def end_citation
        @element_stack.pop
      end

      def end_reference
        if stack_top == :citation
          @evidence.citation.id   = @text
        end
      end

      def end_name
        if stack_top == :header
          @evidence.metadata.document_header['name'] = @text
        end

        if stack_top == :citation
          @evidence.citation.name = @text
        end
      end

      def end_date
        if stack_top == :citation
          @evidence.citation.date = @text
        end
      end

      def end_author
        if stack_top == :header
          @evidence.metadata.document_header['authors'] ||= []
          @evidence.metadata.document_header['authors'] <<  @text
        end

        if stack_top == :citation
          (@evidence.citation.authors ||= []) << @text
        end
      end

      def end_comment
        if stack_top == :citation
          @evidence.citation.comment = @text
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
