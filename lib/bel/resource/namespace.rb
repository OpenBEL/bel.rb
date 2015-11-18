require_relative '../resource'
require_relative 'namespace_value'

module BEL
  module Resource

    # TODO Document
    class Namespace

      attr_reader :uri

      # TODO Document
      def initialize(rdf_repository, uri)
        @rdf_repository = rdf_repository
        @uri            = uri
        @uri_hash       = uri.hash
        @concept_query  = [
          :predicate => RDF::SKOS.inScheme,
          :object    => uri
        ]
        @predicates     = @rdf_repository.query(:subject => uri).
                            each.map(&:predicate)
      end

      # TODO Document
      def each
        return to_enum(:each) unless block_given?
				@rdf_repository.
					query(@concept_query) { |solution|
						yield NamespaceValue.new(@rdf_repository, solution.subject)
					}
      end

      def find(*values)
        return to_enum(:find, *values) unless block_given?

        values.flatten.each do |v|
          yield find_value(v)
				end
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

      def find_value(value)
        # nil input always yield nil
        return nil if value == nil

        # RDF::URI input handled as a special case
        return find_namespace_value_uri(value) if value.is_a?(RDF::URI)

        # input handled as literal identifier; empty literals match in a
        # pattern as if it was nil so return nil if empty string
        vstr  = value.to_s
        return nil if vstr.empty?

        # match input as namespace value prefLabel
				vlit  = RDF::Literal(vstr)
				label = value_query(
					:predicate => RDF::SKOS.prefLabel,
					:object    => vlit
				)
			  return NamespaceValue.new(@rdf_repository, label.subject) if label

        # match input as namespace value identifier
				ident = value_query(
					:predicate => RDF::DC.identifier,
					:object    => vlit
				)
				return NamespaceValue.new(@rdf_repository, ident.subject) if ident

        # match input as namespace value title
				title = value_query(
					:predicate => RDF::DC.title,
					:object    => vlit
				)
				return NamespaceValue.new(@rdf_repository, title.subject) if title
      end

      def find_namespace_value_uri(uri)
        in_namespace_check = @rdf_repository.has_statement?(
          RDF::Statement(uri, RDF::SKOS.inScheme, @uri)
        )
        return nil if !in_namespace_check

        type_check = RDF::Statement(uri, RDF.type, BELV.NamespaceConcept)
				if @rdf_repository.has_statement?(type_check)
          return NamespaceValue.new(@rdf_repository, uri)
        end
			end

      def value_query(pattern)
				@rdf_repository.query(pattern).find { |solution|
				  @rdf_repository.has_statement?(
						RDF::Statement(solution.subject, RDF::SKOS.inScheme, @uri)
					)
				}
      end

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
