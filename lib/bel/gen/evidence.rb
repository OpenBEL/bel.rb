require 'bel'
require 'rantly'
require_relative 'annotation'
require_relative 'citation'
require_relative 'bel_expression'
require_relative 'document_header'

module BEL
  module Gen
    module Evidence

      include BEL::Gen::Annotation
      include BEL::Gen::Citation
      include BEL::Gen::DocumentHeader
      include BEL::Gen::Expression

      def evidence
        evidence = BEL::Model::Evidence.new

        evidence.bel_statement      = bel_statement
        evidence.citation           = citation
        evidence.summary_text       = BEL::Model::SummaryText.new(
          Rantly { sized(120) {string(:alpha)} }
        )
        evidence.experiment_context = BEL::Model::ExperimentContext.new(
          (1..5).to_a.sample.times.map { annotation }
        )
        evidence.references         = BEL::Model::References.new({
          :namespaces  => referenced_namespaces.map { |prefix, ns_def|
            {
              :keyword => prefix,
              :uri     => ns_def.url
            }
          }.sort_by { |ns| ns[:keyword] },
          :annotations => referenced_annotations.map { |keyword, anno_def|
            {
              :keyword => keyword,
              :type    => :uri,
              :domain  => anno_def.url
            }
          }
        })
        evidence.metadata           = BEL::Model::Metadata.new({
          :document_header => document_header
        })

        evidence
      end
    end
  end
end
