require 'bel'
require_relative '../gen'
BEL::Gen.soft_require('rantly')

module BEL
  module Gen

    # The {Namespace} module defines methods that generate random
    # {BEL::Namespace::NamespaceDefinition}. The generated namespace are saved
    # and can be accessed from {Namespace#referenced_namespaces}.
    module Namespace

      # Array of the latest OpenBEL {BEL::Namespace::NamespaceDefinition}.
      NAMESPACES = BEL::Namespace::NAMESPACE_LATEST.map { |prefix, (url, rdf_uri)|
        BEL::Namespace::NamespaceDefinition.new(prefix, url, rdf_uri)
      }

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
    end
  end
end
