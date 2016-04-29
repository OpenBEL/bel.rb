require          'rdf'
require          'rdf/vocab'
require_relative 'concept_scheme'
require_relative 'namespace_value'

module BEL
  module Resource
    # Namespace represents a NamespaceConceptScheme RDF Resource and
    # associated properties.
    class Namespace
      include ConceptScheme

      attr_reader :uri

      DC   = RDF::Vocab::DC
      SKOS = RDF::Vocab::SKOS
      BELV = RDF::Vocabulary.new('http://www.openbel.org/vocabulary/')

      def initialize(rdf_repository, uri)
        @rdf_repository = rdf_repository
        @uri            = RDF::URI(uri.to_s)
        @uri_hash       = @uri.hash
        @concept_query  = [
          :predicate => SKOS.inScheme,
          :object    => @uri
        ]
      end

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

        # input handled as literal identifier; empty literals match in a
        # pattern as if it was nil so return nil if empty string
        vstr  = value.to_s
        return nil if vstr.empty?

        # URI handled by regex match on string
        return find_namespace_value_uri(vstr) if vstr =~ FULL_URI_REGEX

        # match input as namespace value prefLabel
				vlit  = RDF::Literal(vstr)
				label = value_query(
					:predicate => SKOS.prefLabel,
					:object    => vlit
				)
			  return NamespaceValue.new(@rdf_repository, label.subject) if label

        # match input as namespace value identifier
				ident = value_query(
					:predicate => DC.identifier,
					:object    => vlit
				)
				return NamespaceValue.new(@rdf_repository, ident.subject) if ident

        # match input as namespace value title
				title = value_query(
					:predicate => DC.title,
					:object    => vlit
				)
				return NamespaceValue.new(@rdf_repository, title.subject) if title
      end

      def find_namespace_value_uri(uri_s)
        subject            = RDF::URI(uri_s)
        in_namespace_check = @rdf_repository.has_statement?(
          RDF::Statement(subject, SKOS.inScheme, @uri)
        )
        return nil if !in_namespace_check

        type_check = RDF::Statement(subject, RDF.type, BELV.NamespaceConcept)
				if @rdf_repository.has_statement?(type_check)
          return NamespaceValue.new(@rdf_repository, subject)
        end
			end

      def value_query(pattern)
				@rdf_repository.query(pattern).find { |solution|
				  @rdf_repository.has_statement?(
						RDF::Statement(solution.subject, SKOS.inScheme, @uri)
					)
				}
      end
    end
  end
end
