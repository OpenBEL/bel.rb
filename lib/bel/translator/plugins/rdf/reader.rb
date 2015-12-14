module BEL::Translator::Plugins

  module Rdf::Reader

    module EvidenceYielder

      BELV = Rdf::BEL::RDF::BELV

      include ::BEL::Model
      include ::BEL::Quoting

      # Find described resources by +type+ in +graph+.
      #
      # @param  [::RDF::Resource] type the RDF type to find instances for
      # @param  [::RDF::Graph]    graph the RDF graph to query
      # @return [Enumerator]    an enumerator of described resource instances
      def resources_of_type(type, graph)
        graph.query([nil, ::RDF.type, type])
          .lazy
          .map { |rdf_statement|
            describe(rdf_statement.subject, graph)
          }
      end

      # Describes an RDF +resource+ contained within +graph+. Describing an RDF
      # resource will retrieve the neighborhood of RDF statements with
      # +resource+ in the subject position.
      #
      # @param  [::RDF::Resource] resource the RDF resource to describe
      # @param  [::RDF::Graph]    graph the RDF graph to query
      # @return [Hash]          a hash of predicate to object in the
      #         neighborhood of +resource+
      def describe(resource, graph)
        graph.query([resource, nil, nil]).reduce({}) { |hash, statement|
          hash[statement.predicate] = statement.object
          hash
        }
      end

      # Iterate the {BELV.Evidence} predicated statements, from the
      # {::RDF::Graph graph}, and yield those correspdonding {Evidence}
      # objects.
      #
      # @param  [::RDF::Graph]     graph the RDF graph to query
      # @yield  [evidence_model] yields an {Evidence} object
      def evidence_yielder(graph)
        resources_of_type(BELV.Evidence, graph).each do |evidence|

          yield make_evidence(evidence, graph)
        end
      end

      # Create an {Evidence} object from RDF statements found in
      # the {::RDF::Graph graph}.
      #
      # @param  [Hash]       evidence a hash of predicate to object
      #         representing the described evidence
      # @param  [::RDF::Graph] graph the RDF graph to query
      # @return [Evidence]   the evidence model    
      def make_evidence(evidence, graph)
        statement     = describe(evidence[BELV.hasStatement], graph)

        # values
        bel_statement = statement[::RDF::RDFS.label].value
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
          graph = RDF::Graph.new
          RDF::Reader.for(@format).new(@data) do |reader|
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
          graph             = RDF::Graph.new
          evidence_resource = nil
          RDF::Reader.for(@format).new(@data) do |reader|
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
end
