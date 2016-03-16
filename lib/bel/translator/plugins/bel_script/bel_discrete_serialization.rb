require_relative 'evidence_serialization'

# BEL Script evidence serialization that writes each evidence with their full
# set of annotations (i.e. includes all `SET` and necessary `UNSET` records).
# This style is more readable because it groups all set annotations near the
# BEL statement.
#
# @example Discrete serialization for a group of evidence
#   SET Citation = {"PubMed", "Journal...", "12857727", "2003-08-11", "", ""}
#   SET Evidence = "USF1 and USF2 bound the IGF2R promoter in vitro, ..."
#   SET CellLine = "MCF 10A"
#   SET TextLocation = Abstract
#   complex(p(HGNC:USF1),g(HGNC:IGF2R))
#
#   SET Citation = {"PubMed", "Journal...", "12857727", "2003-08-11", "", ""}
#   SET Evidence = "USF1 and USF2 bound the IGF2R promoter in vitro, ..."
#   SET CellLine = "MCF 10A"
#   SET TextLocation = Abstract
#   complex(p(HGNC:USF2),g(HGNC:IGF2R))
#
#   SET Citation = {"PubMed", "Journal...", "12857727", "2003-08-11", "", ""}
#   SET Evidence = "USF1 and USF2 bound the IGF2R promoter in vitro, ..."
#   SET CellLine = "MCF 10A"
#   SET TextLocation = Abstract
#   tscript(p(HGNC:USF2)) directlyIncreases r(HGNC:IGF2R)
#
#   SET Citation = {"PubMed", "Journal...", "12857727", "2003-08-11", "", ""}
#   SET Evidence = "USF1 and USF2 bound the IGF2R promoter in vitro, ..."
#   SET CellLine = "MCF 10A"
#   SET TextLocation = Abstract
#   tscript(p(HGNC:USF1)) causesNoChange r(HGNC:IGF2R)
#
#   SET Citation = {"PubMed", "Journal...", "12857727", "2003-08-11", "", ""}
#   SET Evidence = "c-Myc was present on the CDK4 promoter to the ..."
#   SET CellLine = "MCF 10A"
#   SET TextLocation = Abstract
#   complex(p(HGNC:MYC),g(HGNC:CDK4))
#
#   UNSET CellLine
module BEL::Translator::Plugins::BelScript::BelDiscreteSerialization
  include BEL::Translator::Plugins::BelScript::EvidenceSerialization

  # Serialize the {BEL::Model::Evidence evidence} to a BEL Script string.
  # Includes all necessary +SET AnnotationName+ and +UNSET AnnotationName+
  # records around the BEL statement.
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

    # UNSET unused annotations from previous evidence.
    (cumulative_annotations.keys - current_annotations.keys).each do |unset_key|
      bel << "UNSET #{unset_key}\n"
      cumulative_annotations.delete(unset_key)
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

  # Returns the cumulative +Hash+ of annotations. This *state* is used to keep
  # track of the active, scoped annotations as evidence is serialized.
  def cumulative_annotations
    @cumulative_annotations ||= {}
  end

  # Return BEL Script syntax that completes the BEL Script document.
  # The empty string is returned since no ending syntax is necessary when
  # serializing each evidence discretely.
  def epilogue
    ""
  end
end
