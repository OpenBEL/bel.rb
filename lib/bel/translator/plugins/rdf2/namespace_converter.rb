module BEL
  module BELRDF
    class NamespaceConverter

      PREFIX_TERMINAL = '/'

      # Convert a {BELParser::Expression::Model::Namespace} to {RDF::Graph} of
      # RDF statements.
      #
      # @param  [BELParser::Expression::Model::Namespace] namespace
      # @return [RDF::Graph] graph of RDF statements representing the namespace
      def convert(namespace)
        return nil if namespace.nil? || !namespace.uri?
        NamespaceConverter.resolve_vocabulary(namespace.uri)
      end

      @namespace_vocabulary_hash = {}
      def self.resolve_vocabulary(uri)
        @namespace_vocabulary_hash[uri] ||=
          RDF::Vocabulary.new("#{uri}#{PREFIX_TERMINAL}")
      end
    end
  end
end
