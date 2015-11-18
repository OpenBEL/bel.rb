require_relative '../resource'

module BEL
  module Resource

    # TODO Document
    class NamespaceValue

      attr_reader :uri

      # TODO Document
      def initialize(rdf_repository, uri)
        @rdf_repository = rdf_repository
        @uri            = uri
        @uri_hash       = uri.hash
        @eq_query       = [
          :subject   => uri,
          :predicate => RDF::SKOS.exactMatch
        ]
        @ortho_query    = [
          :subject   => uri,
          :predicate => BELV.orthologousMatch
        ]
        @predicates     = @rdf_repository.query(:subject => uri).
                            each.map(&:predicate).uniq
      end

      def equivalents
        return to_enum(:equivalents) unless block_given?
				@rdf_repository.
					query(@eq_query) { |solution|
						yield NamespaceValue.new(@rdf_repository, solution.object)
					}
			end

      def orthologs
        return to_enum(:orthologs) unless block_given?
				@rdf_repository.
					query(@ortho_query) { |solution|
						yield NamespaceValue.new(@rdf_repository, solution.object)
					}
			end

      def hash
        @uri_hash
      end

      def ==(other)
        return false if other == nil
        @uri == other.uri
      end
      alias_method :eql?, :'=='

      protected

      def method_missing(method)
        method_predicate = @predicates.find { |p|
          p.qname[1].to_sym == method.to_sym
        }
        return nil unless method_predicate
        objects = @rdf_repository.query(
          :subject   => @uri,
          :predicate => method_predicate
        ).each.map(&:object)
        objects.size == 1 ? objects.first : objects.to_a
      end
    end
  end
end
