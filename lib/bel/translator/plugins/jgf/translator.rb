require 'bel'
require 'bel/json'

module BEL::Translator::Plugins

  module Jgf

    class JgfTranslator

      include ::BEL::Translator

      def read(data, options = {})
        default_resource_index = options.fetch(:default_resource_index) {
          ResourceIndex.openbel_published_index('20131211')
        }

        ::BEL::JSON.read(data, options).lazy.select { |obj|
          obj.include?(:nodes) && obj.include?(:edges)
        }.flat_map { |graph|
          unwrap(graph, default_resource_index)
        }
      end

      def write(objects, writer = StringIO.new, options = {})
        graph = {
          :type  => 'BEL-V1.0',
          :nodes => [],
          :edges => []
        }

        objects.each do |nanopub|
          unless nanopub.bel_statement.is_a?(::BEL::Nanopub::Statement)
            nanopub.bel_statement = ::BEL::Nanopub::Nanopub.parse_statement(nanopub)
          end

          stmt    = nanopub.bel_statement
          subject = stmt.subject.to_bel

          graph[:nodes] << {
            :id    => subject,
            :label => subject
          }

          if stmt.object
            object  = stmt.object.to_bel
            graph[:nodes] << {
              :id    => object,
              :label => object
            }
            graph[:edges] << {
              :source   => subject,
              :relation => stmt.relationship,
              :target   => object
            }
          end
        end
        graph[:nodes].uniq!

        ::BEL::JSON.write({:graph => graph}, writer, options)
        writer
      end

      private

      def unwrap(graph, default_resource_index)
        # index nodes
        id_nodes = Hash[
          graph[:nodes].map { |node|
            [node[:id], (node[:label] || node[:id])]
          }
        ]
        ids = id_nodes.keys.to_set

        # map edges to statements
        bel_statements = graph[:edges].map { |edge|
          src, rel, tgt = edge.values_at(:source, :relation, :target)
          source_node = id_nodes[src]
          target_node = id_nodes[tgt]

          if !source_node || !target_node
            nil
          else
            ids.delete(source_node)
            ids.delete(target_node)

            # semantic default
            rel  = 'association' unless rel

            bel_statement = ::BEL::Script.parse(
              "#{source_node} #{rel} #{target_node}\n").select { |obj| obj.is_a? ::BEL::Nanopub::Statement }.first
          end
        }.compact

        # map island nodes to bel statements
        if !ids.empty?
          bel_statements.concat(
            ids.map { |id|
              ::BEL::Script.parse(
                "#{id_nodes[id]}\n"
              ).select { |obj|
                obj.is_a? ::BEL::Nanopub::Statement
              }.first
            }
          )
        end

        # map statements to nanopub objects
        bel_statements.map { |bel_statement|
          graph_name = graph[:label] || graph[:id] || 'BEL Graph'
          metadata   = ::BEL::Nanopub::Metadata.new
          references = ::BEL::Nanopub::References.new

          # establish document header
          metadata.document_header[:Name]        = graph_name
          metadata.document_header[:Description] = graph_name
          metadata.document_header[:Version]     = '1.0'

          # establish annotation definitions
          annotations = graph.fetch(:metadata, {}).
                              fetch(:annotation_definitions, nil)
          if !annotations && default_resource_index
            annotations = Hash[
              default_resource_index.annotations.sort_by { |anno|
                anno.prefix
              }.map { |anno|
                [
                  anno.prefix,
                  {
                    :type   => anno.type,
                    :domain => anno.value
                  }
                ]
              }
            ]
          end
          references.annotations = annotations if annotations

          # establish namespace definitions
          namespaces = graph.fetch(:metadata, {}).
                             fetch(:namespace_definitions, nil)
          if !namespaces && default_resource_index
            namespaces = Hash[
              default_resource_index.namespaces.sort_by { |ns|
                ns.prefix
              }.map { |ns|
                [
                  ns.prefix,
                  ns.url
                ]
              }
            ]
          end
          references.namespaces = namespaces if namespaces

          ::BEL::Nanopub::Nanopub.create(
            :bel_statement => bel_statement,
            :metadata      => metadata,
            :references    => references
          )
        }
      end
    end
  end
end
