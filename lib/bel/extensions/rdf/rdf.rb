# Load RDF library dependencies
begin
  require 'rdf'
  require 'addressable/uri'
  require 'uuid'
rescue LoadError => e
  # Raise LoadError if the requirements were not met.
  raise
end

require_relative 'bel_rdf'

# OpenClass to contribute RDF functionality to BEL Model.
class ::BEL::Namespace::NamespaceDefinition

  def to_uri
    @rdf_uri
  end

  def to_rdf_vocabulary
    RUBYRDF::Vocabulary.new("#{@rdf_uri}/")
  end
end

class ::BEL::Model::Parameter

  def to_uri
    @ns.to_rdf_vocabulary[URI::encode(@value)]
  end

  def to_rdf
    uri = to_uri
    encodings = ['A'].concat(@enc.to_s.each_char.to_a).uniq
    if block_given?
      encodings.map { |enc| concept_statement(enc, uri) }.each do |stmt|
        yield stmt
      end
    else
      encodings.map { |enc| concept_statement(enc, uri)}
    end
  end

  private

  def concept_statement(encoding_character, uri)
      case encoding_character
      when 'G'
        RUBYRDF::Statement(uri, RUBYRDF.type, BEL::RDF::BELV.GeneConcept)
      when 'R'
        RUBYRDF::Statement(uri, RUBYRDF.type, BEL::RDF::BELV.RNAConcept)
      when 'P'
        RUBYRDF::Statement(uri, RUBYRDF.type, BEL::RDF::BELV.ProteinConcept)
      when 'M'
        RUBYRDF::Statement(uri, RUBYRDF.type, BEL::RDF::BELV.MicroRNAConcept)
      when 'C'
        RUBYRDF::Statement(uri, RUBYRDF.type, BEL::RDF::BELV.ComplexConcept)
      when 'B'
        RUBYRDF::Statement(uri, RUBYRDF.type, BEL::RDF::BELV.BiologicalProcessConcept)
      when 'A'
        RUBYRDF::Statement(uri, RUBYRDF.type, BEL::RDF::BELV.AbundanceConcept)
      when 'O'
        RUBYRDF::Statement(uri, RUBYRDF.type, BEL::RDF::BELV.PathologyConcept)
      end
  end
end

class BEL::Model::Term

  def to_uri
    tid = to_s.squeeze(')').gsub(/[")\[\]]/, '').gsub(/[(:, ]/, '_')
    BEL::RDF::BELR[URI::encode(tid)]
  end

  def rdf_type
    if respond_to? 'fx'
      fx = @fx.respond_to?(:short_form) ? @fx.short_form : @fx.to_s.to_sym
      if [:p, :proteinAbundance].include?(fx) &&
         @arguments.find{ |x|
           if x.is_a? BEL::Model::Term
             arg_fx = x.fx
             arg_fx = arg_fx.respond_to?(:short_form) ? arg_fx.short_form : arg_fx.to_s.to_sym
             [:pmod, :proteinModification].include?(arg_fx)
           else
             false
           end
         }

        return BEL::RDF::BELV.ModifiedProteinAbundance
      end

      if [:p, :proteinAbundance].include?(fx) &&
         @arguments.find{ |x|
           if x.is_a? BEL::Model::Term
             arg_fx = x.fx
             arg_fx = arg_fx.respond_to?(:short_form) ? arg_fx.short_form : arg_fx.to_s.to_sym
             BEL::RDF::PROTEIN_VARIANT.include?(arg_fx)
           else
             false
           end
         }

        return BEL::RDF::BELV.ProteinVariantAbundance
      end

      BEL::RDF::FUNCTION_TYPE[fx] || BEL::RDF::BELV.Abundance
    end
  end

  def to_rdf
    uri = to_uri
    statements = []

    # rdf:type
    type = rdf_type
    statements << [uri, BEL::RDF::RDF.type, BEL::RDF::BELV.Term]
    statements << [uri, BEL::RDF::RDF.type, type]
    fx = @fx.respond_to?(:short_form) ? @fx.short_form : @fx.to_s.to_sym
    if BEL::RDF::ACTIVITY_TYPE.include? fx
      statements << [uri, BEL::RDF::BELV.hasActivityType, BEL::RDF::ACTIVITY_TYPE[fx]]
    end

    # rdfs:label
    statements << [uri, BEL::RDF::RDFS.label, to_s.force_encoding('UTF-8')]

    # special proteins (does not recurse into pmod)
    if [:p, :proteinAbundance].include?(fx)
      pmod =
        @arguments.find{ |x|
          if x.is_a? BEL::Model::Term
            arg_fx = x.fx
            arg_fx = arg_fx.respond_to?(:short_form) ? arg_fx.short_form : arg_fx.to_s.to_sym
            [:pmod, :proteinModification].include?(arg_fx)
          else
            false
          end
        }
      if pmod
        mod_string = pmod.arguments.map(&:to_s).join(',')
        mod_type = BEL::RDF::MODIFICATION_TYPE.find {|k,v| mod_string.start_with? k}
        mod_type = (mod_type ? mod_type[1] : BEL::RDF::BELV.Modification)
        statements << [uri, BEL::RDF::BELV.hasModificationType, mod_type]
        last = pmod.arguments.last.to_s
        if last.match(/^\d+$/)
          statements << [uri, BEL::RDF::BELV.hasModificationPosition, last.to_i]
        end
        # link root protein abundance as hasChild
        root_param = @arguments.find{|x| x.is_a? BEL::Model::Parameter}
        (root_id, root_statements) = BEL::Model::Term.new(:p, [root_param]).to_rdf
        statements << [uri, BEL::RDF::BELV.hasChild, root_id]
        statements += root_statements
        return [uri, statements]
      elsif @arguments.find{|x| x.is_a? BEL::Model::Term and BEL::RDF::PROTEIN_VARIANT.include? x.fx}
        # link root protein abundance as hasChild
        root_param = @arguments.find{|x| x.is_a? BEL::Model::Parameter}
        (root_id, root_statements) = BEL::Model::Term.new(:p, [root_param]).to_rdf
        statements << [uri, BEL::RDF::BELV.hasChild, root_id]
        statements += root_statements
        return [uri, statements]
      end
    end

    # BEL::RDF::BELV.hasConcept]
    @arguments.find_all{ |x|
      x.is_a? BEL::Model::Parameter and x.ns != nil
    }.each do |param|
      concept_uri = param.ns.to_rdf_vocabulary[param.value.to_s]
      statements << [uri, BEL::RDF::BELV.hasConcept, BEL::RDF::RDF::URI(Addressable::URI.encode(concept_uri))]
    end

    # BEL::RDF::BELV.hasChild]
    @arguments.find_all{|x| x.is_a? BEL::Model::Term}.each do |child|
      (child_id, child_statements) = child.to_rdf
      statements << [uri, BEL::RDF::BELV.hasChild, child_id]
      statements += child_statements
    end

    return [uri, statements]
  end
end

class BEL::Model::Statement

  def to_uri
    case
    when subject_only?
      tid = @subject.to_s.squeeze(')').gsub(/[")\[\]]/, '').gsub(/[(:, ]/, '_')
      BEL::RDF::BELR[URI::encode(tid)]
    when simple?
      sub_id = @subject.to_s.squeeze(')').gsub(/[")\[\]]/, '').gsub(/[(:, ]/, '_')
      obj_id = @object.to_s.squeeze(')').gsub(/[")\[\]]/, '').gsub(/[(:, ]/, '_')
      rel = BEL::RDF::RELATIONSHIP_TYPE[@relationship.to_s]
      if rel
        rel = rel.path.split('/')[-1]
      else
        rel = @relationship.to_s
      end
      BEL::RDF::BELR[URI::encode("#{sub_id}_#{rel}_#{obj_id}")]
    when nested?
      sub_id = @subject.to_s.squeeze(')').gsub(/[")\[\]]/, '').gsub(/[(:, ]/, '_')
      nsub_id = @object.subject.to_s.squeeze(')').gsub(/[")\[\]]/, '').gsub(/[(:, ]/, '_')
      nobj_id = @object.object.to_s.squeeze(')').gsub(/[")\[\]]/, '').gsub(/[(:, ]/, '_')
      rel = BEL::RDF::RELATIONSHIP_TYPE[@relationship.to_s]
      if rel
        rel = rel.path.split('/')[-1]
      else
        rel = @relationship.to_s
      end
      nrel = BEL::RDF::RELATIONSHIP_TYPE[@object.relationship.to_s]
      if nrel
        nrel = nrel.path.split('/')[-1]
      else
        nrel = @object.relationship.to_s
      end
      BEL::RDF::BELR[URI::encode("#{sub_id}_#{rel}_#{nsub_id}_#{nrel}_#{nobj_id}")]
    end
  end

  def to_rdf
    uri = to_uri
    statements = []

    case
    when subject_only?
      (sub_uri, sub_statements) = @subject.to_rdf
      statements << [uri, BEL::RDF::BELV.hasSubject, sub_uri]
      statements += sub_statements
    when simple?
      (sub_uri, sub_statements) = @subject.to_rdf
      statements += sub_statements

      (obj_uri, obj_statements) = @object.to_rdf
      statements += obj_statements

      rel = BEL::RDF::RELATIONSHIP_TYPE[@relationship.to_s]
      statements << [uri, BEL::RDF::BELV.hasSubject, sub_uri]
      statements << [uri, BEL::RDF::BELV.hasObject, obj_uri]
      statements << [uri, BEL::RDF::BELV.hasRelationship, rel]
    when nested?
      (sub_uri, sub_statements) = @subject.to_rdf
      (nsub_uri, nsub_statements) = @object.subject.to_rdf
      (nobj_uri, nobj_statements) = @object.object.to_rdf
      statements += sub_statements
      statements += nsub_statements
      statements += nobj_statements
      rel = BEL::RDF::RELATIONSHIP_TYPE[@relationship.to_s]
      nrel = BEL::RDF::RELATIONSHIP_TYPE[@object.relationship.to_s]
      nuri = BEL::RDF::BELR["#{strip_prefix(nsub_uri)}_#{nrel}_#{strip_prefix(nobj_uri)}"]

      # inner
      statements << [nuri, BEL::RDF::BELV.hasSubject, nsub_uri]
      statements << [nuri, BEL::RDF::BELV.hasObject, nobj_uri]
      statements << [nuri, BEL::RDF::BELV.hasRelationship, nrel]

      # outer
      statements << [uri, BEL::RDF::BELV.hasSubject, sub_uri]
      statements << [uri, BEL::RDF::BELV.hasObject, nuri]
      statements << [uri, BEL::RDF::BELV.hasRelationship, rel]
    end

    # common statement triples
    statements << [uri, BEL::RDF::RDF.type, BEL::RDF::BELV.Statement]
    statements << [uri, RDF::RDFS.label, to_s.force_encoding('UTF-8')]

    # evidence
    evidence_bnode = BEL::RDF::RDF::Node.uuid
    statements << [evidence_bnode, BEL::RDF::RDF.type, BEL::RDF::BELV.Evidence]
    statements << [uri, BEL::RDF::BELV.hasEvidence, evidence_bnode]
    statements << [evidence_bnode, BEL::RDF::BELV.hasStatement, uri]

    # citation
    citation = @annotations.delete('Citation')
    if citation
      value = citation.value.map{|x| x.gsub('"', '')}
      if citation and value[0] == 'PubMed'
        pid = value[2]
        statements << [
          evidence_bnode,
          BEL::RDF::BELV.hasCitation,
          BEL::RDF::RDF::URI(BEL::RDF::PUBMED[pid])
        ]
      end
    end

    # evidence
    evidence_text = @annotations.delete('Evidence')
    if evidence_text
      value = evidence_text.value.gsub('"', '').force_encoding('UTF-8')
      statements << [evidence_bnode, BEL::RDF::BELV.hasEvidenceText, value]
    end

    # annotations
    @annotations.each do |name, anno|
      name = anno.name.gsub('"', '')

      if BEL::RDF::const_defined? name
        annotation_scheme = BEL::RDF::const_get name
        [anno.value].flatten.map{|x| x.gsub('"', '')}.each do |val|
          value_uri = BEL::RDF::RDF::URI(Addressable::URI.encode(annotation_scheme[val.to_s]))
          statements << [evidence_bnode, BEL::RDF::BELV.hasAnnotation, value_uri]
        end
      end
    end

    return [uri, statements]
  end

  private

  def strip_prefix(uri)
    if uri.to_s.start_with? 'http://www.openbel.org/bel/'
      uri.to_s[28..-1]
    else
      uri
    end
  end
end

module BEL::Extension::Format

  class FormatRDF

    include Formatter
    ID          = :rdf
    MEDIA_TYPES = %i(
      application/n-quads
      application/n-triples
      application/rdf+xml
      application/turtle
      application/x-turtle
      text/turtle
    )
    EXTENSIONS  = %i(
      nq
      nt
      rdf
      ttl
    )

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
      RDFReader::UnbufferedEvidenceYielder.new(data)
    end

    def serialize(objects, writer = StringIO.new, options = {})
      format = options[:format] || :ntriples
      rdf_writer = RDFWriter::RDFYielder.new(writer, format)

      objects.each do |evidence|
        rdf_writer << evidence
      end
      rdf_writer.done
      writer
    end
  end

  module RDFReader

    module EvidenceYielder

      RDF  = BEL::RDF::RDF
      RDFS = RDF::RDFS
      BELV = BEL::RDF::BELV

      include ::BEL::Model
      include ::BEL::Quoting

      # Find described resources by +type+ in +graph+.
      #
      # @param  [RDF::Resource] type the RDF type to find instances for
      # @param  [RDF::Graph]    graph the RDF graph to query
      # @return [Enumerator]    an enumerator of described resource instances
      def resources_of_type(type, graph)
        graph.query([nil, RDF.type, type])
          .lazy
          .map { |rdf_statement|
            describe(rdf_statement.subject, graph)
          }
      end

      # Describes an RDF +resource+ contained within +graph+. Describing an RDF
      # resource will retrieve the neighborhood of RDF statements with
      # +resource+ in the subject position.
      #
      # @param  [RDF::Resource] resource the RDF resource to describe
      # @param  [RDF::Graph]    graph the RDF graph to query
      # @return [Hash]          a hash of predicate to object in the
      #         neighborhood of +resource+
      def describe(resource, graph)
        graph.query([resource, nil, nil]).reduce({}) { |hash, statement|
          hash[statement.predicate] = statement.object
          hash
        }
      end

      # Iterate the {BELV.Evidence} predicated statements, from the
      # {RUBYRDF::Graph graph}, and yield those correspdonding {Evidence}
      # objects.
      #
      # @param  [RDF::Graph]     graph the RDF graph to query
      # @yield  [evidence_model] yields an {Evidence} object
      def evidence_yielder(graph)
        resources_of_type(BELV.Evidence, graph).each do |evidence|

          yield make_evidence(evidence, graph)
        end
      end

      # Create an {Evidence} object from RDF statements found in
      # the {RUBYRDF::Graph graph}.
      #
      # @param  [Hash]       evidence a hash of predicate to object
      #         representing the described evidence
      # @param  [RDF::Graph] graph the RDF graph to query
      # @return [Evidence]   the evidence model    
      def make_evidence(evidence, graph)
        statement     = describe(evidence[BELV.hasStatement], graph)

        # values
        bel_statement = statement[RDFS.label].value
        ev_text       = evidence[BELV.hasEvidenceText]
        citation      = evidence[BELV.hasCitation]

        # model
        ev_model               = Evidence.new
        ev_model.bel_statement = ::BEL::Script.parse(bel_statement)
                                   .find { |obj|
                                     obj.is_a? Statement
                                   }
        ev_model.summary_text  = SummaryText.new(ev_text.value) if ev_text

        if citation.respond_to?(:value)
          ev_model.citation =
            case citation.value
            when /pubmed:(\d+)$/
              pubmed_id = $1.to_i
              Citation.new({
                :type => 'PubMed',
                :id   => pubmed_id,
                :name => "PubMed Citation - #{pubmed_id}"
              })
            else
              nil
            end
        end

        ev_model
      end
    end

    class BufferedEvidenceYielder

      include EvidenceYielder

      def initialize(data, format = :ntriples)
        @data   = data
        @format = format
      end

      def each
        if block_given?
          graph = RUBYRDF::Graph.new
          RUBYRDF::Reader.for(@format).new(@data) do |reader|
            reader.each_statement do |statement|
              graph << statement
            end
          end
          evidence_yielder(graph) do |evidence_model|
            yield evidence_model
          end
        else
          to_enum(:each)
        end
      end
    end

    class UnbufferedEvidenceYielder

      include EvidenceYielder

      def initialize(data, format = :ntriples)
        @data   = data
        @format = format
      end

      def each
        if block_given?
          graph             = RUBYRDF::Graph.new
          evidence_resource = nil
          RUBYRDF::Reader.for(@format).new(@data) do |reader|
            reader.each_statement do |statement|
              case
              when statement.object == BELV.Evidence &&
                   statement.predicate == RDF.type
                evidence_resource = statement.subject
              when evidence_resource &&
                   statement.predicate != BELV.hasEvidence &&
                   statement.subject != evidence_resource

                # yield current graph as evidence model
                yield make_evidence(
                  describe(evidence_resource, graph),
                  graph
                )

                # reset parse state
                graph.clear
                evidence_resource = nil

                # insert this RDF statement
                graph << statement
              else
                graph << statement
              end
            end
          end

          # yield last graph as evidence model
          yield make_evidence(
            describe(evidence_resource, graph),
            graph
          )
        else
          to_enum(:each)
        end
      end
    end
  end

  module RDFWriter

    class RDFYielder
      attr_reader :writer

      def initialize(io, format)
        rdf_writer = find_writer(format)
        @writer = rdf_writer.new(io, { :stream => true })
      end

      def <<(evidence)
        triples = evidence.bel_statement.to_rdf[1]
        triples.each do |triple|
          @writer.write_statement(RDF::Statement(*triple))
        end
      end

      def done
        @writer.write_epilogue
      end

      private

      def find_writer(format)
        case format.to_s.to_sym
        when :nquads
          BEL::RDF::RDF::NQuads::Writer
        when :turtle
          begin
            require 'rdf/turtle'
            BEL::RDF::RDF::Turtle::Writer
          rescue LoadError
            $stderr.puts """Turtle format not supported.
    Install the 'rdf-turtle' gem."""
            raise
          end
        when :ntriples
          BEL::RDF::RDF::NTriples::Writer
        end
      end
    end
  end

  register_formatter(FormatRDF.new)
end
