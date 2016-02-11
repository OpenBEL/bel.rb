require 'bel'
require_relative '../gen'
BEL::Gen.soft_require('rantly')

module BEL
  module Gen

    # The {Expression} module defines methods that generate random BEL
    # {BEL::Model::Parameter parameters}, {BEL::Model::Term terms}, and
    # {BEL::Model::Statement statements}.
    module Expression
      include BEL::Quoting

      # Array of the latest OpenBEL {BEL::Namespace::NamespaceDefinition}.
      NAMESPACES    = BEL::Namespace::NAMESPACE_LATEST.map { |prefix, (url, rdf_uri)|
                        BEL::Namespace::NamespaceDefinition.new(prefix, url, rdf_uri)
                      }

      # Array of all BEL 1.0 functions including both short and long form.
      FUNCTIONS     = BEL::Language::FUNCTIONS.map { |_, fx|
                        [ fx[:short_form], fx[:long_form] ]
                      }.flatten.sort.uniq

      # Array of all BEL 1.0 relationships including both short and long form.
      RELATIONSHIPS = BEL::Language::RELATIONSHIPS.each.to_a.flatten.sort.uniq

      # Retrieve the namespaces chosen during use of {#namespace}.
      # @return [Hash] hash of namespace prefix => {BEL::Namespace::NamespaceDefinition}
      def referenced_namespaces
        @referenced_namespaces ||= Hash[
          NAMESPACES.map { |ns| [ns.prefix, ns] }
        ]
      end

      # Returns a randomly chosen namespace.
      # @return [BEL::Namespace::NamespaceDefinition] a random namespace
      def namespace
        ns = Rantly {
          choose(*NAMESPACES)
        }
        referenced_namespaces[ns.prefix] = ns
        ns
      end

      # Returns a BEL parameter from a random namespace. The value will be
      # randomly sample from the chosen namespace.
      #
      # @return [BEL::Model::Parameter] a parameter chosen from a namespace
      def bel_parameter_with_namespace
        ns    = namespace
        value = ns.values.keys.sample
        enc   = ns.values[value]
        BEL::Model::Parameter.new(
          ns,
          value.to_s,
          enc
        )
      end

      # Returns a BEL parameter without a namespace. The value will be
      # a random string.
      #
      # @return [BEL::Model::Parameter] a parameter without a namespace
      def bel_parameter_without_namespace
        value = Rantly.value {
          sized(range(3,10)) {
            string(/[[:alnum:]]|[[:blank:]]|[[:punct:]]/)
          }
        }
        BEL::Model::Parameter.new(
          nil,
          value,
          :A
        )
      end

      # Returns a BEL parameter that may or may not have a namespace.
      #
      # Note: This method has a better chance of selecting a BEL parameter
      # from a namespace.
      #
      # @see #bel_parameter_with_namespace
      # @see #bel_parameter_without_namespace
      # @return [BEL::Model::Parameter] a parameter that may or may not have
      #         a namespace
      def bel_parameter
        with_namespace    = bel_parameter_with_namespace
        without_namespace = bel_parameter_without_namespace
        Rantly {
          freq(
            [5, :literal, with_namespace],
            [1, :literal, without_namespace],
          )
        }
      end

      # Returns a randomly chosen function.
      # @return [Symbol] the function label (short or long form)
      def function
        Rantly {
          choose(*FUNCTIONS)
        }
      end

      # Returns a randomly chosen relationship.
      # @return [Symbol] the relationship label (short or long form)
      def relationship
        Rantly {
          choose(*RELATIONSHIPS)
        }
      end

      # Returns a randomly constructed BEL term.
      # @return [String] the term label
      def bel_term
        "#{function}(#{bel_parameter})"
      end

      # Returns a randomly constructed BEL statement.
      # @return [String] the statement label
      def bel_statement
        sub = bel_term
        obj = bel_term
        "#{sub} #{relationship} #{obj}"
      end
    end
  end
end
