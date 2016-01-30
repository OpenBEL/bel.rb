require          'bel/evidence_model'
require_relative 'uuid'

module BEL::Translator::Plugins

  module Rdf

    # OpenClass to contribute RDF functionality to BEL Model.

    class ::BEL::Namespace::NamespaceDefinition

      def to_uri
        @rdf_uri
      end

      def to_rdf_vocabulary
        ::RDF::Vocabulary.new("#{@rdf_uri}/")
      end
    end

    class ::BEL::Model::Parameter

      CONCEPT_ENCODING = {
        :G => BEL::RDF::BELV.GeneConcept,
        :R => BEL::RDF::BELV.RNAConcept,
        :P => BEL::RDF::BELV.ProteinConcept,
        :M => BEL::RDF::BELV.MicroRNAConcept,
        :C => BEL::RDF::BELV.ComplexConcept,
        :B => BEL::RDF::BELV.BiologicalProcessConcept,
        :A => BEL::RDF::BELV.AbundanceConcept,
        :O => BEL::RDF::BELV.PathologyConcept,
      }

      def to_uri
        @ns.to_rdf_vocabulary[URI::encode(@value)]
      end

      def to_rdf(graph_name = nil)
        uri = to_uri
        encodings = ['A'].concat(@enc.to_s.each_char.to_a).uniq
        encodings.map! { |enc| concept_statement(enc, uri, graph_name)}
        [uri, encodings]
      end

      private

      def concept_statement(encoding_character, uri, graph_name = nil)
        encoding = CONCEPT_ENCODING.fetch(encoding_character.to_sym, BEL::RDF::BELV.AbundanceConcept)
        ::RDF::Statement(uri, ::RDF.type, encoding, :graph_name => graph_name)
      end
    end

    class ::BEL::Model::Term

      def to_uri
        tid = to_s.squeeze(')').gsub(/[")\[\]]/, '').gsub(/[(:, ]/, '_')
        BEL::RDF::BELR[URI::encode(tid)]
      end

      def rdf_type
        if respond_to? 'fx'
          fx = @fx.respond_to?(:short_form) ? @fx.short_form : @fx.to_s.to_sym
          if [:p, :proteinAbundance].include?(fx) &&
             @arguments.find{ |x|
               if x.is_a? ::BEL::Model::Term
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
               if x.is_a? ::BEL::Model::Term
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

      def to_rdf(graph_name = nil)
        uri = to_uri
        statements = []

        # rdf:type
        type = rdf_type
        statements << ::RDF::Statement.new(uri, BEL::RDF::RDF.type, BEL::RDF::BELV.Term, :graph_name => graph_name)
        statements << ::RDF::Statement.new(uri, BEL::RDF::RDF.type, type, :graph_name => graph_name)
        fx = @fx.respond_to?(:short_form) ? @fx.short_form : @fx.to_s.to_sym
        if BEL::RDF::ACTIVITY_TYPE.include? fx
          statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasActivityType, BEL::RDF::ACTIVITY_TYPE[fx], :graph_name => graph_name)
        end

        # rdfs:label
        statements << ::RDF::Statement.new(uri, BEL::RDF::RDFS.label, to_s.force_encoding('UTF-8'), :graph_name => graph_name)

        # special proteins (does not recurse into pmod)
        if [:p, :proteinAbundance].include?(fx)
          pmod =
            @arguments.find{ |x|
              if x.is_a? ::BEL::Model::Term
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
            statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasModificationType, mod_type, :graph_name => graph_name)
            last = pmod.arguments.last.to_s
            if last.match(/^\d+$/)
              statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasModificationPosition, last.to_i, :graph_name => graph_name)
            end
            # link root protein abundance as hasChild
            root_param = @arguments.find{|x| x.is_a? ::BEL::Model::Parameter}
            (root_id, root_statements) = ::BEL::Model::Term.new(:p, [root_param]).to_rdf(graph_name)
            statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasChild, root_id, :graph_name => graph_name)
            statements.concat(root_statements)
            return [uri, statements]
          elsif @arguments.find{|x| x.is_a? ::BEL::Model::Term and BEL::RDF::PROTEIN_VARIANT.include? x.fx}
            # link root protein abundance as hasChild
            root_param = @arguments.find{|x| x.is_a? ::BEL::Model::Parameter}
            (root_id, root_statements) = ::BEL::Model::Term.new(:p, [root_param]).to_rdf(graph_name)
            statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasChild, root_id, :graph_name => graph_name)
            statements.concat(root_statements)
            return [uri, statements]
          end
        end

        # BEL::RDF::BELV.hasConcept
        @arguments.find_all{ |x|
          x.is_a? ::BEL::Model::Parameter and x.ns != nil
        }.each do |param|
          param_uri, encoding_statements = param.to_rdf(graph_name)
          statements.concat(encoding_statements)
          statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasConcept, param_uri, :graph_name => graph_name)
        end

        # BEL::RDF::BELV.hasChild]
        @arguments.find_all{|x| x.is_a? ::BEL::Model::Term}.each do |child|
          (child_id, child_statements) = child.to_rdf(graph_name)
          statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasChild, child_id, :graph_name => graph_name)
          statements.concat(child_statements)
        end

        [uri, statements]
      end
    end

    class ::BEL::Model::Statement

      def to_uri
        case
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
        else
          # Interpret as subject only BEL statement.
          tid = @subject.to_s.squeeze(')').gsub(/[")\[\]]/, '').gsub(/[(:, ]/, '_')
          BEL::RDF::BELR[URI::encode(tid)]
        end
      end

      def to_rdf(graph_name = nil)
        uri        = to_uri
        statements = []

        case
        when subject_only?
          (sub_uri, sub_statements) = @subject.to_rdf(graph_name)
          statements << ::RDF::Statement(uri, BEL::RDF::BELV.hasSubject, sub_uri, :graph_name => graph_name)
          statements.concat(sub_statements)
        when simple?
          (sub_uri, sub_statements) = @subject.to_rdf(graph_name)
          statements.concat(sub_statements)

          (obj_uri, obj_statements) = @object.to_rdf(graph_name)
          statements.concat(obj_statements)

          rel = BEL::RDF::RELATIONSHIP_TYPE[@relationship.to_s]
          statements << ::RDF::Statement(uri, BEL::RDF::BELV.hasSubject, sub_uri,  :graph_name => graph_name)
          statements << ::RDF::Statement(uri, BEL::RDF::BELV.hasObject, obj_uri,   :graph_name => graph_name)
          statements << ::RDF::Statement(uri, BEL::RDF::BELV.hasRelationship, rel, :graph_name => graph_name)
        when nested?
          (sub_uri, sub_statements) = @subject.to_rdf(graph_name)
          (nsub_uri, nsub_statements) = @object.subject.to_rdf(graph_name)
          (nobj_uri, nobj_statements) = @object.object.to_rdf(graph_name)
          statements.concat(sub_statements)
          statements.concat(nsub_statements)
          statements.concat(nobj_statements)
          rel = BEL::RDF::RELATIONSHIP_TYPE[@relationship.to_s]
          nrel = BEL::RDF::RELATIONSHIP_TYPE[@object.relationship.to_s]
          nuri = BEL::RDF::BELR["#{strip_prefix(nsub_uri)}_#{nrel}_#{strip_prefix(nobj_uri)}"]

          # inner
          statements << ::RDF::Statement.new(nuri, BEL::RDF::BELV.hasSubject, nsub_uri,  :graph_name => graph_name)
          statements << ::RDF::Statement.new(nuri, BEL::RDF::BELV.hasObject, nobj_uri,   :graph_name => graph_name)
          statements << ::RDF::Statement.new(nuri, BEL::RDF::BELV.hasRelationship, nrel, :graph_name => graph_name)

          # outer
          statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasSubject, sub_uri,  :graph_name => graph_name)
          statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasObject, nuri,      :graph_name => graph_name)
          statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasRelationship, rel, :graph_name => graph_name)
        end

        # common statement triples
        statements << ::RDF::Statement.new(uri, BEL::RDF::RDF.type, BEL::RDF::BELV.Statement,     :graph_name => graph_name)
        statements << ::RDF::Statement.new(uri, ::RDF::RDFS.label, to_s.force_encoding('UTF-8'),  :graph_name => graph_name)

        # evidence
        evidence    = BEL::RDF::BELE[Rdf.generate_uuid]
        statements << ::RDF::Statement.new(evidence, BEL::RDF::RDF.type, BEL::RDF::BELV.Evidence, :graph_name => graph_name)
        statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasEvidence, evidence,             :graph_name => graph_name)
        statements << ::RDF::Statement.new(evidence, BEL::RDF::BELV.hasStatement, uri,            :graph_name => graph_name)

        # citation
        citation = @annotations.delete('Citation')
        if citation
          value = citation.value.map{|x| x.gsub('"', '')}
          if citation and value[0] == 'PubMed'
            pid = value[2]
            statements << ::RDF::Statement.new(evidence, BEL::RDF::BELV.hasCitation, BEL::RDF::PUBMED[pid], :graph_name => graph_name)
          end
        end

        # evidence
        evidence_text = @annotations.delete('Evidence')
        if evidence_text
          value = evidence_text.value.gsub('"', '').force_encoding('UTF-8')
          statements << ::RDF::Statement.new(evidence, BEL::RDF::BELV.hasEvidenceText, value, :graph_name => graph_name)
        end

        # annotations
        @annotations.each do |_, anno|
          name = anno.name.gsub('"', '')

          if BEL::RDF::const_defined? name
            annotation_scheme = BEL::RDF::const_get name
            [anno.value].flatten.map{|x| x.gsub('"', '')}.each do |val|
              value_uri = BEL::RDF::RDF::URI(URI.encode(annotation_scheme + val.to_s))
              statements << ::RDF::Statement.new(evidence, BEL::RDF::BELV.hasAnnotation, value_uri, :graph_name => graph_name)
            end
          end
        end

        [uri, statements]
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

    class ::BEL::Model::Evidence

      def to_uri
        BEL::RDF::BELE[Rdf.generate_uuid]
      end

      def to_rdf
        uri                       = to_uri

        # parse BEL statement if necessary
        unless self.bel_statement.is_a?(::BEL::Model::Statement)
          self.bel_statement = parse_statement(self)
        end

        # convert BEL statement to RDF
        statement_uri, statements = bel_statement.to_rdf(uri)

        statements << ::RDF::Statement.new(uri,           BEL::RDF::RDF.type,          BEL::RDF::BELV.Evidence, :graph_name => uri)
        statements << ::RDF::Statement.new(statement_uri, BEL::RDF::BELV.hasEvidence,  uri,                     :graph_name => uri)
        statements << ::RDF::Statement.new(uri,           BEL::RDF::BELV.hasStatement, statement_uri,           :graph_name => uri)

        annotations = bel_statement.annotations

        # citation
        citation = annotations.delete('Citation')
        if citation
          value = citation.value.map{|x| x.gsub('"', '')}
          if citation and value[0] == 'PubMed'
            pid = value[2]
            statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasCitation, BEL::RDF::PUBMED[pid], :graph_name => uri)
          end
        end

        # evidence
        evidence_text = annotations.delete('Evidence')
        if evidence_text
          value = evidence_text.value.gsub('"', '').force_encoding('UTF-8')
          statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasEvidenceText, value, :graph_name => uri)
        end

        # annotations
        annotations.each do |_, anno|
          name = anno.name.gsub('"', '')

          if BEL::RDF::const_defined? name
            annotation_scheme = BEL::RDF::const_get name
            [anno.value].flatten.map{|x| x.gsub('"', '')}.each do |val|
              value_uri = BEL::RDF::RDF::URI(URI.encode(annotation_scheme + val.to_s))
              statements << ::RDF::Statement.new(uri, BEL::RDF::BELV.hasAnnotation, value_uri, :graph_name => uri)
            end
          end
        end

        [uri, statements]
      end

      def to_void_dataset(void_dataset_uri)
        document_header = self.metadata[:document_header]
        return nil if !document_header || !document_header.is_a?(Hash)

        triples = ::RDF::Repository.new
        triples << ::RDF::Statement.new(void_dataset_uri, ::RDF.type, ::RDF::VOID.Dataset)

        name = version = nil
        document_header.each do |property, value|
          case property
            when /name/i
              name     = value.to_s
              triples << ::RDF::Statement.new(void_dataset_uri, ::RDF::DC.title, name)
            when /description/i
              triples << ::RDF::Statement.new(void_dataset_uri, ::RDF::DC.description, value.to_s)
            when /version/i
              version  = value.to_s
            when /copyright/i
              waiver = RDF::Vocabulary.new('http://vocab.org/waiver/terms/').waiver

              value = value.to_s
              uri   = RDF::URI(value)
              value = if uri.valid?
                        uri
                      else
                        value
                      end
              triples << ::RDF::Statement.new(void_dataset_uri, waiver, value)
            when /authors/i
              if value.respond_to?(:each)
                value.each do |v|
                  triples << ::RDF::Statement.new(void_dataset_uri, ::RDF::DC.creator, v.to_s)
                end
              else
                triples << ::RDF::Statement.new(void_dataset_uri, ::RDF::DC.creator, value.to_s)
              end
            when /licenses/i
              value = value.to_s
              uri   = RDF::URI(value)
              value = if uri.valid?
                        uri
                      else
                        value
                      end
              triples << ::RDF::Statement.new(void_dataset_uri, ::RDF::DC.license, value)
            when /contactinfo/i
              triples << ::RDF::Statement.new(void_dataset_uri, ::RDF::DC.publisher, :publisher)
              triples << ::RDF::Statement.new(:publisher, ::RDF.type,          ::RDF::FOAF.Person)
              triples << ::RDF::Statement.new(:publisher, ::RDF::FOAF.mbox,     value.to_s)
          end
        end

        if name && version
          identifier = "#{name}/#{version}"
          triples << ::RDF::Statement.new(void_dataset_uri, ::RDF::DC.identifier, identifier)
        end

        triples
      end

      private

      def parse_statement(evidence)
        namespaces = evidence.references.namespaces
        ::BEL::Script.parse(
          "#{evidence.bel_statement}\n",
          Hash[
            namespaces.map { |ns|
              keyword, uri = ns.values_at(:keyword, :uri)
              sym          = keyword.to_sym
              [
                sym,
                ::BEL::Namespace::NamespaceDefinition.new(sym, uri, uri)
              ]
            }
          ]
        ).select { |obj|
          obj.is_a? ::BEL::Model::Statement
        }.first
      end
    end
  end
end
