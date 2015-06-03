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
    char_enum = @enc.to_s.each_char
    if block_given?
      char_enum.map {|c| concept_statement(c, uri) }.each do |stmt|
        yield stmt
      end
    else
      char_enum.map { |c| concept_statement(c, uri)}
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
      if @fx.short_form == :p and @arguments.find{|x| x.is_a? Term and x.fx.short_form == :pmod}
        return BEL::RDF::BELV.ModifiedProteinAbundance
      end
      if @fx.short_form == :p and @arguments.find{|x| x.is_a? Term and BEL::RDF::PROTEIN_VARIANT.include? x.fx}
        return BEL::RDF::BELV.ProteinVariantAbundance
      end

      BEL::RDF::FUNCTION_TYPE[@fx.short_form] || BEL::RDF::BELV.Abundance
    end
  end

  def to_rdf
    uri = to_uri
    statements = []

    # rdf:type
    type = rdf_type
    statements << [uri, BEL::RDF::RDF.type, BEL::RDF::BELV.Term]
    statements << [uri, BEL::RDF::RDF.type, type]
    if BEL::RDF::ACTIVITY_TYPE.include? @fx.short_form
      statements << [uri, BEL::RDF::BELV.hasActivityType, BEL::RDF::ACTIVITY_TYPE[@fx.short_form]]
    end

    # rdfs:label
    statements << [uri, BEL::RDF::RDFS.label, to_s]

    # special proteins (does not recurse into pmod)
    if @fx.short_form == :p
      if @arguments.find{|x| x.is_a? Term and x.fx.short_form == :pmod}
        pmod = @arguments.find{|x| x.is_a? Term and x.fx.short_form == :pmod}
        mod_string = pmod.arguments.map(&:to_s).join(',')
        mod_type = BEL::RDF::MODIFICATION_TYPE.find {|k,v| mod_string.start_with? k}
        mod_type = (mod_type ? mod_type[1] : BEL::RDF::BELV.Modification)
        statements << [uri, BEL::RDF::BELV.hasModificationType, mod_type]
        last = pmod.arguments.last.to_s
        if last.match(/^\d+$/)
          statements << [uri, BEL::RDF::BELV.hasModificationPosition, last.to_i]
        end
        # link root protein abundance as hasChild
        root_param = @arguments.find{|x| x.is_a? Parameter}
        (root_id, root_statements) = Term.new(:p, [root_param]).to_rdf
        statements << [uri, BEL::RDF::BELV.hasChild, root_id]
        statements += root_statements
        return [uri, statements]
      elsif @arguments.find{|x| x.is_a? Term and BEL::RDF::PROTEIN_VARIANT.include? x.fx}
        # link root protein abundance as hasChild
        root_param = @arguments.find{|x| x.is_a? Parameter}
        (root_id, root_statements) = Term.new(:p, [root_param]).to_rdf
        statements << [uri, BEL::RDF::BELV.hasChild, root_id]
        statements += root_statements
        return [uri, statements]
      end
    end

    # BEL::RDF::BELV.hasConcept]
    @arguments.find_all{ |x|
      x.is_a? Parameter and x.ns != nil
    }.each do |param|
      concept_uri = param.ns.to_rdf_vocabulary[param.value.to_s]
      statements << [uri, BEL::RDF::BELV.hasConcept, BEL::RDF::RDF::URI(Addressable::URI.encode(concept_uri))]
    end

    # BEL::RDF::BELV.hasChild]
    @arguments.find_all{|x| x.is_a? Term}.each do |child|
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
    statements << [uri, RDF::RDFS.label, to_s]

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
      value = evidence_text.value.gsub('"', '')
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
    MEDIA_TYPES = %i(application/n-quads)
    EXTENSIONS  = %i(nq)

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
      []
    end

    def serialize(objects, writer = StringIO.new)
    end
  end

  register_formatter(FormatRDF.new)
end
