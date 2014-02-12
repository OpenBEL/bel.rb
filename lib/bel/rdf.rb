# vim: ts=2 sw=2:
# Defines the RDF vocabulary for BEL structures.

unless BEL::Features.rdf_support?
  # rdf and addressable are required
  raise RuntimeError, %Q{BEL::RDF is not supported.
The rdf and addressable gems are required.

Install the gems:
      gem install rdf
      gem install addressable}
end

require 'rdf'
require 'addressable/uri'

# rename rdf module to avoid conflict within BEL::RDF
RUBYRDF = RDF

module BEL
  module RDF
    # uri prefixes
    BELR    = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/')
    BELV    = RUBYRDF::Vocabulary.new('http://www.openbel.org/vocabulary/')
    PUBMED  = RUBYRDF::Vocabulary.new('http://bio2rdf.org/pubmed:')

    # annotations
    Anatomy       = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/anatomy/')
    Cell          = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/cell/')
    CellLine      = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/cell-line/')
    CellStructure = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/cell-structure/')
    Disease       = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/disease/')
    MeSHAnatomy   = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/mesh-anatomy/')
    MeSHDisease   = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/mesh-diseases/')
    Species       = RUBYRDF::Vocabulary.new('http://www.openbel.org/bel/annotation/species-taxonomy-id/')

    # maps outer function to bel/vocabulary class
    FUNCTION_TYPE = {
      a: BELV.Abundance,
      g: BELV.GeneAbundance,
      p: BELV.ProteinAbundance,
      r: BELV.RNAAbundance,
      m: BELV.microRNAAbundance,
      complex: BELV.ComplexAbundance,
      composite: BELV.CompositeAbundance,
      bp: BELV.BiologicalProcess,
      path: BELV.Pathology,
      rxn: BELV.Reaction,
      tloc: BELV.Translocation,
      sec: BELV.CellSecretion,
      deg: BELV.Degradation,
      cat: BELV.AbundanceActivity,
      chap: BELV.AbundanceActivity,
      gtp: BELV.AbundanceActivity,
      kin: BELV.AbundanceActivity,
      act: BELV.AbundanceActivity,
      pep: BELV.AbundanceActivity,
      phos: BELV.AbundanceActivity,
      ribo: BELV.AbundanceActivity,
      tscript: BELV.AbundanceActivity,
      tport: BELV.AbundanceActivity
    }
    RELATIONSHIP_TYPE = {
      # 'actsIn' =>                 'actsIn',  XXX captured by BELV.hasChild]
        'analogous'              => 'analogous',
        'association'            => 'association',
        '--'                     => 'association',
        'biomarkerFor'           => 'biomarkerFor',
        'causesNoChange'         => 'causesNoChange',
        'decreases'              => 'decreases',
        '-|'                     => 'decreases',
        'directlyDecreases'      => 'directlyDecreases',
        '=|'                     => 'directlyDecreases',
        'directlyIncreases'      => 'directlyIncreases',
        '=>'                     => 'directlyIncreases',
        'hasComponent'           => 'hasComponent',
        'hasComponents'          => 'hasComponents',
        'hasMember'              => 'hasMember',
        'hasMembers'             => 'hasMembers',
        'hasModification'        => 'hasModification',
        'hasProduct'             => 'hasProduct',
        'hasVariant'             => 'hasVariant',
        'includes'               => 'includes',
        'increases'              => 'increases',
        '->'                     => 'increases',
        'isA'                    => 'isA',
        'negativeCorrelation'    => 'negativeCorrelation',
        'orthologous'            => 'orthologous',
        'positiveCorrelation'    => 'positiveCorrelation',
        'prognosticBiomarkerFor' => 'prognosticBiomarkerFor',
        'rateLimitingStepOf'     => 'rateLimitingStepOf',
        'reactantIn'             => 'reactantIn',
        'subProcessOf'           => 'subProcessOf',
        'transcribedTo'          => 'transcribedTo',
        ':>'                     => 'transcribedTo',
        '>>'                     => 'translatedTo',
        'translatedTo'           => 'translatedTo',
        'translocates'           => 'translocates'
    }
    RELATIONSHIP_CLASSIFICATION = {
        :'association'            => BELV.correlativeRelationship,
        :'--'                     => BELV.correlativeRelationship,
        :'biomarkerFor'           => BELV.biomarkerFor,
        :'causesNoChange'         => BELV.causesNoChange,
        :'decreases'              => BELV.decreases,
        :'-|'                     => BELV.decreases,
        :'directlyDecreases'      => BELV.directlyDecreases,
        :'=|'                     => BELV.directlyDecreases,
        :'directlyIncreases'      => BELV.directlyIncreases,
        :'=>'                     => BELV.directlyIncreases,
        :'hasComponent'           => BELV.hasComponent,
        :'hasMember'              => BELV.hasMember,
        :'increases'              => BELV.increases,
        :'->'                     => BELV.increases,
        :'isA'                    => BELV.isA,
        :'negativeCorrelation'    => BELV.negativeCorrelation,
        :'positiveCorrelation'    => BELV.positiveCorrelation,
        :'prognosticBiomarkerFor' => BELV.prognosticBiomarkerFor,
        :'rateLimitingStepOf'     => BELV.rateLimitingStepOf,
        :'subProcessOf'           => BELV.subProcessOf
    }
    ACTIVITY_TYPE = {
      cat: BELV.Catalytic,
      chap: BELV.Chaperone,
      gtp: BELV.GtpBound,
      kin: BELV.Kinase,
      act: BELV.Activity,
      pep: BELV.Peptidase,
      phos: BELV.Phosphatase,
      ribo: BELV.Ribosylase,
      tscript: BELV.Transcription,
      tport: BELV.Transport
    }
    # maps modification types to bel/vocabulary class
    MODIFICATION_TYPE = {
      'P,S' => BELV.PhosphorylationSerine,
      'P,T' => BELV.PhosphorylationThreonine,
      'P,Y' => BELV.PhosphorylationTyrosine,
      'A'   => BELV.Acetylation,
      'F'   => BELV.Farnesylation,
      'G'   => BELV.Glycosylation,
      'H'   => BELV.Hydroxylation,
      'M'   => BELV.Methylation,
      'P'   => BELV.Phosphorylation,
      'R'   => BELV.Ribosylation,
      'S'   => BELV.Sumoylation,
      'U'   => BELV.Ubiquitination
    }
    # protein variant
    PROTEIN_VARIANT = [:fus, :fusion, :sub, :substitution, :trunc, :truncation]

    def self.for_statement(statement, writer)
      # TODO canonicalization

      case
      when statement.subject_only?
        id = for_term(statement.subject, writer)
        writer << [id, BELV.hasSubject, id]
      when statement.simple?
        sub_id = for_term(statement.subject, writer)
        obj_id = for_term(statement.object, writer)
        rel = RELATIONSHIP_TYPE[statement.rel.to_s]
        id = BELR["#{strip_prefix(sub_id)}_#{rel}_#{strip_prefix(obj_id)}"]
        writer << [id, BELV.hasSubject, sub_id]
        writer << [id, BELV.hasObject, obj_id]

        if RELATIONSHIP_CLASSIFICATION.include? statement.rel
          relclass = RELATIONSHIP_CLASSIFICATION[statement.rel]
          writer << [id, BELV.hasRelationship, relclass]
        else
          writer << [id, BELV.hasRelationship, RELATIONSHIP_TYPE[rel]]
        end
      when statement.nested?
        sub_id  = for_term(statement.subject, writer)
        nsub_id = for_term(statement.object.subject, writer)
        nobj_id = for_term(statement.object.object, writer)
        rel = RELATIONSHIP_TYPE[statement.rel.to_s]
        nrel = RELATIONSHIP_TYPE[statement.object.rel.to_s]
        id = BELR["#{strip_prefix(sub_id)}_#{rel}_#{strip_prefix(nsub_id)}_#{nrel}_#{strip_prefix(nobj_id)}"]
        nid = BELR["#{strip_prefix(nsub_id)}_#{nrel}_#{strip_prefix(nobj_id)}"]

        # inner
        writer << [nid, RDF.type, BELV.Statement]
        writer << [nid, RDF::RDFS.label, statement.object.to_s]
        writer << [nid, BELV.hasSubject, nsub_id]
        writer << [nid, BELV.hasObject, nobj_id]
        if RELATIONSHIP_CLASSIFICATION.include? statement.object.rel
          nrelclass = RELATIONSHIP_CLASSIFICATION[statement.object.rel]
          writer << [nid, BELV.hasRelationship, nrelclass]
        else
          writer << [nid, BELV.hasRelationship, RELATIONSHIP_TYPE[nrel]]
        end

        # outer
        writer << [id, BELV.hasSubject, sub_id]
        writer << [id, BELV.hasObject, nid]
        if RELATIONSHIP_CLASSIFICATION.include? statement.rel
          relclass = RELATIONSHIP_CLASSIFICATION[statement.rel]
          writer << [id, BELV.hasRelationship, relclass]
        else
          writer << [id, BELV.hasRelationship, RELATIONSHIP_TYPE[rel]]
        end
      end

      # common statement triples
      writer << [id, RDF.type, BELV.Statement]
      writer << [id, RDF::RDFS.label, statement.to_s]

      # evidence
      evidence_bnode = RDF::Node.new
      writer << [evidence_bnode, RDF.type, BELV.Evidence]
      writer << [id, BELV.hasEvidence, evidence_bnode]
      writer << [evidence_bnode, BELV.hasStatement, id]

      # citation
      citation = statement.annotations.delete('Citation')
      if citation
        value = citation.value.map{|x| x.gsub('"', '')}
        if citation and value[0] == 'PubMed'
          pid = value[2]
          writer << [evidence_bnode, BELV.hasCitation, RDF::URI(PUBMED + pid)]
        end
      end

      # evidence
      evidence_text = statement.annotations.delete('Evidence')
      if evidence_text
        value = evidence_text.value.gsub('"', '')
        writer << [evidence_bnode, BELV.hasEvidenceText, value]
      end

      # annotations
      statement.annotations.each do |name, anno|
        name = anno.name.gsub('"', '')

        if const_get name
          annotation_scheme = const_get name
          [anno.value].flatten.map{|x| x.gsub('"', '')}.each do |val|
            value_uri = RDF::URI(Addressable::URI.encode(annotation_scheme[val.to_s]))
            writer << [evidence_bnode, BELV.hasAnnotation, value_uri]
          end
        elsif
          $stderr.puts "missing annotation #{name}"
        end
      end

    end

    def self.for_term(term, writer)
      id = BELR[BEL::RDF::term_id(term)]

      # rdf:type
      type = BEL::RDF::type(term)
      writer << [id, RDF.type, BELV.Term]
      writer << [id, RDF.type, type]
      if ACTIVITY_TYPE.include? term.fx
        writer << [id, BELV.hasActivityType, ACTIVITY_TYPE[term.fx]]
      end

      # rdfs:label
      writer << [id, RDF::RDFS.label, term.to_s]

      # special proteins (does not recurse into pmod)
      if term.fx == :p
        if term.args.find{|x| x.is_a? BEL::Script::Term and x.fx == :pmod}
          pmod = term.args.find{|x| x.is_a? BEL::Script::Term and x.fx == :pmod}
          mod_string = pmod.args.map(&:to_s).join(',')
          mod_type = MODIFICATION_TYPE.find {|k,v| mod_string.start_with? k}
          mod_type = (mod_type ? mod_type[1] : BELV.Modification)
          writer << [id, BELV.hasModificationType, mod_type]
          last = pmod.args.last.to_s
          if last.match(/^\d+$/)
            writer << [id, BELV.hasModificationPosition, last.to_i]
          end
          # link root protein abundance as hasChild
          root_param = term.args.find{|x| x.is_a? BEL::Script::Parameter}
          root_id = self.for_term(BEL::Script::Term.new(:p, [root_param]), writer)
          writer << [id, BELV.hasChild, root_id]
          return id
        elsif term.args.find{|x| x.is_a? BEL::Script::Term and PROTEIN_VARIANT.include? x.fx}
          # link root protein abundance as hasChild
          root_param = term.args.find{|x| x.is_a? BEL::Script::Parameter}
          root_id = self.for_term(BEL::Script::Term.new(:p, [root_param]), writer)
          writer << [id, BELV.hasChild, root_id]
          return id
        end
      end

      # BELV.hasConcept]
      term.args.find_all{|x| x.is_a? BEL::Script::Parameter}.each do |param|
        if param.ns and const_get param.ns
          ev = const_get param.ns
          writer << [id, BELV.hasConcept, RDF::URI(Addressable::URI.encode(ev[param.value].to_s))]
        end
      end

      # BELV.hasChild]
      term.args.find_all{|x| x.is_a? BEL::Script::Term}.each do |child|
        child_id = self.for_term(child, writer)
        writer << [id, BELV.hasChild, child_id]
      end

      return id
    end

    def self.type(obj)
      if obj.respond_to? 'fx'
        if obj.fx == :p and obj.args.find{|x| x.is_a? BEL::Script::Term and x.fx == :pmod}
          return BELV.ModifiedProteinAbundance
        end
        if obj.fx == :p and obj.args.find{|x| x.is_a? BEL::Script::Term and PROTEIN_VARIANT.include? x.fx}
          return BELV.ProteinVariantAbundance
        end

        FUNCTION_TYPE[obj.fx.to_sym] || BELV.Abundance
      end
    end

    def self.term_id(term)
      term.to_s.squeeze(')').gsub(/[")]/, '').gsub(/[(:, ]/, '_')
    end

    def self.strip_prefix(uri)
      if uri.to_s.start_with? 'http://www.openbel.org/bel/'
        uri.to_s[28..-1]
      else
        uri
      end
    end

    ### TODO Vocabulary could be an RDF::Graph
    def self.vocabulary_rdf
      [
        # Class
        [BELV.Term, RDF.type, RDF::RDFS.Class],
        [BELV.Statement, RDF.type, RDF::RDFS.Class],
        [BELV.Evidence, RDF.type, RDF::RDFS.Class],
        [BELV.Abundance, RDF.type, RDF::RDFS.Class],
        [BELV.Modification, RDF.type, RDF::RDFS.Class],
        [BELV.relationship, RDF.type, RDF::RDFS.Class],

        # Property
        [BELV.hasConcept, RDF.type, RDF.Property],
        [BELV.hasChild, RDF.type, RDF.Property],
        [BELV.hasSubject, RDF::RDFS.subPropertyOf, BELV.hasChild],
        [BELV.hasSubject, RDF::RDFS.range, BELV.Term],
        [BELV.hasSubject, RDF::RDFS.domain, BELV.Statement],
        [BELV.hasObject, RDF::RDFS.subPropertyOf, BELV.hasChild],
        [BELV.hasObject, RDF::RDFS.range, BELV.Term],
        [BELV.hasObject, RDF::RDFS.domain, BELV.Statement],
        [BELV.hasRelationship, RDF.type, RDF.Property],
        [BELV.hasActivityType, RDF.type, RDF.Property],
        [BELV.hasModificationPosition, RDF.type, RDF.Property],
        [BELV.hasModificationType, RDF.type, RDF.Property],
        [BELV.hasEvidence, RDF.type, RDF.Property],
        [BELV.hasStatement, RDF.type, RDF.Property],
        [BELV.hasAnnotation, RDF.type, RDF.Property],
        [BELV.hasCitation, RDF.type, RDF.Property],
        [BELV.hasEvidenceText, RDF.type, RDF.Property],

        # abundance subclasses
        [BELV.Process, RDF.type, RDF::RDFS.Class],
        [BELV.ProteinAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.ModifiedProteinAbundance, RDF::RDFS.subClassOf, BELV.ProteinAbundance],
        [BELV.ProteinVariantAbundance, RDF::RDFS.subClassOf, BELV.ProteinAbundance],
        [BELV.ComplexAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.CompositeAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.RNAAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.GeneAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.microRNAAbundance, RDF::RDFS.subClassOf, BELV.Abundance],
        [BELV.BiologicalProcess, RDF::RDFS.subClassOf, BELV.Process],
        [BELV.Pathology, RDF::RDFS.subClassOf, BELV.BiologicalProcess],
        [BELV.Transformation, RDF::RDFS.subClassOf, BELV.Process],
        [BELV.Reaction, RDF::RDFS.subClassOf, BELV.Transformation],
        [BELV.Translocation, RDF::RDFS.subClassOf, BELV.Transformation],
        [BELV.CellSecretion, RDF::RDFS.subClassOf, BELV.Translocation],
        [BELV.Degradation, RDF::RDFS.subClassOf, BELV.Transformation],
        [BELV.AbundanceActivity, RDF::RDFS.subClassOf, BELV.Process],

        # modification subclasses
        [BELV.Acetylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Farnesylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Glycosylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Hydroxylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Methylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Phosphorylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Ribosylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Sumoylation, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.Ubiquitination, RDF::RDFS.subClassOf, BELV.Modification],
        [BELV.PhosphorylationSerine, RDF::RDFS.subClassOf, BELV.Phosphorylation],
        [BELV.PhosphorylationTyrosine, RDF::RDFS.subClassOf, BELV.Phosphorylation],
        [BELV.PhosphorylationThreonine, RDF::RDFS.subClassOf, BELV.Phosphorylation],

        # relationships subclasses
        [BELV.positiveRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.negativeRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.causalRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.directRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.membershipRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.correlativeRelationship, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.biomarkerFor, RDF::RDFS.subClassOf, BELV.relationship],
        [BELV.causesNoChange, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.increases, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.increases, RDF::RDFS.subClassOf, BELV.positiveRelationship],
        [BELV.decreases, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.decreases, RDF::RDFS.subClassOf, BELV.negativeRelationship],
        [BELV.directlyIncreases, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.directlyIncreases, RDF::RDFS.subClassOf, BELV.positiveRelationship],
        [BELV.directlyIncreases, RDF::RDFS.subClassOf, BELV.directRelationship],
        [BELV.directlyIncreases, RDF::RDFS.subClassOf, BELV.increases],
        [BELV.directlyDecreases, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.directlyDecreases, RDF::RDFS.subClassOf, BELV.negativeRelationship],
        [BELV.directlyDecreases, RDF::RDFS.subClassOf, BELV.directRelationship],
        [BELV.directlyDecreases, RDF::RDFS.subClassOf, BELV.decreases],
        [BELV.negativeCorrelation, RDF::RDFS.subClassOf, BELV.correlativeRelationship],
        [BELV.negativeCorrelation, RDF::RDFS.subClassOf, BELV.negativeRelationship],
        [BELV.positiveCorrelation, RDF::RDFS.subClassOf, BELV.correlativeRelationship],
        [BELV.positiveCorrelation, RDF::RDFS.subClassOf, BELV.positiveRelationship],
        [BELV.association, RDF::RDFS.subClassOf, BELV.correlativeRelationship],
        [BELV.hasComponent, RDF::RDFS.subClassOf, BELV.membershipRelationship],
        [BELV.hasMember, RDF::RDFS.subClassOf, BELV.membershipRelationship],
        [BELV.isA, RDF::RDFS.subClassOf, BELV.membershipRelationship],
        [BELV.prognosticBiomarkerFor, RDF::RDFS.subClassOf, BELV.biomarkerFor],
        [BELV.rateLimitingStepOf, RDF::RDFS.subClassOf, BELV.increases],
        [BELV.rateLimitingStepOf, RDF::RDFS.subClassOf, BELV.causalRelationship],
        [BELV.rateLimitingStepOf, RDF::RDFS.subClassOf, BELV.subProcessOf],
        [BELV.subProcessOf, RDF::RDFS.subClassOf, BELV.membershipRelationship]
      ]
    end
  end
end
