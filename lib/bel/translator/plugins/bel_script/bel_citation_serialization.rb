require_relative 'evidence_serialization.rb'

# BEL Script evidence serialization that groups evidence by citation scoped to
# individual statement groups (i.e. BEL Script's +SET STATEMENT_GROUP+ and
# +UNSET STATEMENT_GROUP+).
#
# @example Citation serialization for a group of evidence
#   SET STATEMENT_GROUP = 12857727
#   SET Citation = {"PubMed", "Journal...", "12857727", "2003-08-11", "", ""}
#   SET Evidence = "USF1 and USF2 bound the IGF2R promoter in vitro, ..."
#   SET CellLine = "MCF 10A"
#   SET TextLocation = Abstract
#   complex(p(HGNC:USF1),g(HGNC:IGF2R))
#
#   complex(p(HGNC:USF2),g(HGNC:IGF2R))
#
#   tscript(p(HGNC:USF2)) directlyIncreases r(HGNC:IGF2R)
#
#   tscript(p(HGNC:USF1)) causesNoChange r(HGNC:IGF2R)
#
#   SET Evidence = "c-Myc was present on the CDK4 promoter to the ..."
#   complex(p(HGNC:MYC),g(HGNC:CDK4))
#   UNSET STATEMENT_GROUP
module BEL::Translator::Plugins::BelScript::BelCitationSerialization
  include BEL::Translator::Plugins::BelScript::EvidenceSerialization

  # Serialize the {BEL::Model::Evidence evidence} to a BEL Script string.
  #
  # Includes +SET AnnotationName+ and +UNSET AnnotationName+ where needed in
  # order to remove duplicating annotations.
  #
  # @param  [BEL::Model::Evidence] evidence the evidence to serialize
  # @return [String]               the BEL Script string
  def to_bel(evidence)
    bel = ''

    citation     = citation_value(evidence)
    summary_text = summary_text_value(evidence)
    annotations  = annotation_values(evidence)

    current_annotations            = {}.merge(annotations)
    current_annotations[:Citation] = citation if citation
    current_annotations[:Evidence] = summary_text if summary_text

    if !evidence.citation.id || evidence.citation.id.empty?
      citation_id = quote('')
    else
      citation_id = quote_if_needed(evidence.citation.id)
    end

    # Reset cumulative annotations if new citation.
    if cumulative_citation == nil
      bel << %Q{SET STATEMENT_GROUP = #{citation_id}\n}
      cumulative_annotations.clear
    elsif evidence.citation != cumulative_citation
      bel << %Q{UNSET STATEMENT_GROUP\n}
      bel << "\n\n"
      bel << %Q{SET STATEMENT_GROUP = #{citation_id}\n}
      cumulative_annotations.clear
    end

    # Hang on to the last citation.
    self.cumulative_citation = evidence.citation

    # UNSET unused annotations from previous evidence.
    (cumulative_annotations.keys - current_annotations.keys).each do |unset_key|
      bel << "UNSET #{unset_key}\n"
      cumulative_annotations.delete(unset_key)
    end

    # Remove annotation if key/value was SET by a previous evidence.
    Hash[
      cumulative_annotations.to_a & current_annotations.to_a
    ].each do |same_k, _|
      current_annotations.delete(same_k)
    end

    # Retain the current evidence's annotation in cumulative set.
    cumulative_annotations.merge!(current_annotations)

    # SET Citation
    citation = current_annotations.delete(:Citation)
    if citation
      bel << "SET Citation = {#{citation}}\n"
    end

    # SET Evidence
    summary_text = current_annotations.delete(:Evidence)
    if summary_text
      bel << %Q{SET Evidence = "#{summary_text}"\n}
    end

    # SET new or modified annotations
    current_annotations.sort.each do |(name, value)|
      bel << "SET #{name} = #{value}\n"
    end

    # Assert BEL statement
    bel << "#{evidence.bel_statement}\n"

    # Separate evidence by new line.
    bel << "\n"

    bel
  end

  private

  # The cumulative citation that is active for the current evidence. This is
  # tracked in order to decide when to begin a new statement group.
  attr_accessor :cumulative_citation

  # Returns the cumulative +Hash+ of annotations. This *state* is used to keep
  # track of the active, scoped annotations as evidence is serialized.
  def cumulative_annotations
    @cumulative_annotations ||= {}
  end

  # Return BEL Script syntax that should completes the BEL Script document.
  # For Citation serialization we will always end with the unset of a
  # statement group.
  def epilogue
    %Q{UNSET STATEMENT_GROUP\n}
  end
end
