require_relative 'belv2_0'

module BEL
  module BELRDF
    module Reader
      module NanopubYielder
        include ::BEL::Nanopub
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

        # Iterate the {BELV.Nanopub} predicated statements, from the
        # {::RDF::Graph graph}, and yield those correspdonding {Nanopub}
        # objects.
        #
        # @param  [::RDF::Graph]     graph the RDF graph to query
        # @yield  [::BEL::Nanopub::Nanopub] yields a nanopub object
        def nanopub_yielder(graph)
          resources_of_type(BELV.Nanopub, graph).each do |nanopub|

            yield make_nanopub(nanopub, graph)
          end
        end

        # Create an {Nanopub} object from RDF statements found in
        # the {::RDF::Graph graph}.
        #
        # @param  [Hash]       nanopub a hash of predicate to object
        #         representing the described nanopub
        # @param  [::RDF::Graph] graph the RDF graph to query
        # @return [Nanopub]   the nanopub
        def make_nanopub(nanopub_hash, graph)
          statement     = describe(nanopub_hash[BELV.hasStatement], graph)

          # values
          bel_statement = statement[::RDF::RDFS.label].value
          support_text  = nanopub_hash[BELV.hasSupport]
          citation      = nanopub_hash[BELV.hasCitation]

          # model
          nanopub               = Nanopub.new
          nanopub.bel_statement = ::BEL::Script.parse(bel_statement)
                                     .find { |obj|
                                       obj.is_a? Statement
                                     }
          nanopub.support       = Support.new(support_text.value) if support_text

          if citation.respond_to?(:value)
            nanopub.citation =
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

          nanopub
        end
      end

      class BufferedNanopubYielder

        include NanopubYielder

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
            nanopub_yielder(graph) do |nanopub|
              yield nanopub
            end
          else
            to_enum(:each)
          end
        end
      end

      class UnbufferedNanopubYielder

        include NanopubYielder

        def initialize(data, format)
          @data   = data
          @format = format
        end

        def each
          if block_given?
            graph   = RDF::Graph.new
            nanopub = nil
            RDF::Reader.for(@format).new(@data) do |reader|
              reader.each_statement do |statement|
                case
                when statement.object == BELV.Nanopub &&
                     statement.predicate == RDF.type
                  nanopub = statement.subject
                when nanopub &&
                     statement.predicate != BELV.hasNanopub &&
                     statement.subject != nanopub

                  # yield current graph as nanopub
                  yield make_nanopub(
                    describe(nanopub, graph),
                    graph
                  )

                  # reset parse state
                  graph.clear
                  nanopub = nil

                  # insert this RDF statement
                  graph << statement
                else
                  graph << statement
                end
              end
            end

            # yield last graph as nanopub
            yield make_nanopub(
              describe(nanopub, graph),
              graph
            )
          else
            to_enum(:each)
          end
        end
      end
    end
  end
end
