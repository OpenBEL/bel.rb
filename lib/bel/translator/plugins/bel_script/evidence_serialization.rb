require 'bel/quoting'

# Serializing of common {BEL::Model::Evidence evidence} components to BEL
# Script syntax.
#
# @abstract
module BEL::Translator::Plugins::BelScript::EvidenceSerialization
  include BEL::Quoting

  # Serialize the {BEL::Model::Evidence evidence} to a BEL Script string.
  #
  # @param  [BEL::Model::Evidence] evidence the evidence to serialize
  # @return [String]               the BEL Script string
  # @abstract Include and override {#to_bel} to implement serialization
  #           {BEL::Model::Evidence evidence} to BEL Script
  def to_bel(evidence)
  end

  # Return BEL Script syntax that completes the BEL Script document.
  #
  # @abstract
  def epilogue
    raise NotImplementedError.new("#{self.class}#epilogue")
  end

  protected

  def citation_value(evidence)
    citation = evidence.citation

    return nil unless citation && citation.valid?

    values = citation.to_a
    values.map! { |v|
      v ||= ""
      if v.respond_to?(:each)
        %Q{"#{v.join('|')}"}
      else
        %Q{"#{v}"}
      end
    }
    values.join(', ')
  end

  def summary_text_value(evidence)
    summary_text = evidence.summary_text

    return nil unless summary_text && summary_text.value

    value = summary_text.value
    value.gsub!("\n", "")
    value.gsub!('"', %Q{\\"})
    value
  end

  def annotation_values(evidence)
    experiment_context = evidence.experiment_context

    return {} unless experiment_context

    Hash[
      experiment_context.
        sort_by { |obj| obj[:name].to_sym }.
        map { |obj|
          name  = obj[:name].to_sym
          value = obj[:value]

          value_s =
            if value.respond_to? :map
              "{#{value.map { |v| quote(v) }.join(', ')}}"
            else
              quote(value)
            end

          [name, value_s]
        }
    ]
  end
end
