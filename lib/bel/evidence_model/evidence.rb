require 'bel'

require_relative 'citation'
require_relative 'summary_text'
require_relative 'experiment_context'
require_relative 'references'
require_relative 'metadata'

module BEL
  module Model

    class Evidence
      def self.create(hash)
        ev = Evidence.new
        ev.bel_statement      = hash[:bel_statement] || nil
        ev.citation           = Citation.new(hash[:citation] || {})
        ev.summary_text.value = hash[:summary_text] || nil
        ev.experiment_context = ExperimentContext.new(hash[:experiment_context] || [])
        ev.references         = References.new(hash[:references] || {})
        ev.metadata           = Metadata.new(hash[:metadata] || {})
        ev
      end

      def bel_statement
        (@bel_statement ||= Statement.new)
      end

      def bel_statement=(bel_statement)
        @bel_statement = bel_statement
      end

      def citation
        (@citation ||= Citation.new)
      end

      def citation=(citation)
        @citation = citation
      end

      def summary_text
        (@summary_text ||= SummaryText.new)
      end

      def summary_text=(summary_text)
        @summary_text = summary_text
      end

      def experiment_context
        (@experiment_context ||= ExperimentContext.new)
      end

      def experiment_context=(experiment_context)
        @experiment_context = experiment_context
      end

      def references
        (@references ||= References.new)
      end

      def references=(references)
        @references = references
      end

      def metadata
        (@metadata ||= Metadata.new)
      end

      def metadata=(metadata)
        @metadata = metadata
      end

      def to_h(hash = {})
        hash.merge!(
          {
            :bel_statement      => @bel_statement,
            :citation           => @citation.to_h,
            :summary_text       => @summary_text.value,
            :experiment_context => @experiment_context.values,
            :references         => @references.values,
            :metadata           => @metadata.to_a
          }
        )
        hash
      end
    end
  end
end
