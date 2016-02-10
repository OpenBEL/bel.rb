require 'bel'
require 'rantly'

module BEL
  module Gen
    module Expression
      include BEL::Quoting

      NAMESPACES    = BEL::Namespace::NAMESPACE_LATEST.map { |prefix, (url, rdf_uri)|
                        BEL::Namespace::NamespaceDefinition.new(prefix, url, rdf_uri)
                      }
      FUNCTIONS     = BEL::Language::FUNCTIONS.map { |_, fx|
                        [ fx[:short_form], fx[:long_form] ]
                      }.flatten.sort.uniq
      RELATIONSHIPS = BEL::Language::RELATIONSHIPS.each.to_a.flatten.sort.uniq

      # Retrieve the namespaces chosen during use of {#namespace}.
      # @return [Hash] hash of namespace prefix => {BEL::Namespace::NamespaceDefinition}
      def referenced_namespaces
        @referenced_namespaces ||= Hash[
          NAMESPACES.map { |ns| [ns.prefix, ns] }
        ]
      end

      def namespace
        ns = Rantly {
          choose(*NAMESPACES)
        }
        referenced_namespaces[ns.prefix] = ns
        ns
      end

      def value_with_namespace
        ns = namespace
        "#{ns.prefix}:#{ensure_quotes(ns.values.keys.sample)}"
      end

      def value_without_namespace
        Rantly.value {
          sized(range(3,5)) {
            string(:alnum)
          }
        }
      end

      def bel_parameter
        w_namespace  = value_with_namespace
        wo_namespace = value_with_namespace
        Rantly {
          freq(
            [5, :literal, w_namespace],
            [1, :literal, wo_namespace],
          )
        }
      end

      def function
        Rantly {
          choose(*FUNCTIONS)
        }
      end

      def bel_term
        "#{function}(#{bel_parameter})"
      end

      def bel_statement
        sub = bel_term
        obj = bel_term
        "#{sub} #{relationship} #{obj}"
      end


      def relationship
        Rantly {
          choose(*RELATIONSHIPS)
        }
      end
    end
  end
end
