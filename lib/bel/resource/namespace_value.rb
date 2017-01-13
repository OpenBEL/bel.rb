require          'rdf'
require          'rdf/vocab'
require_relative 'concept'
require_relative 'namespace'
require_relative 'namespaces'

module BEL
  module Resource
    # NamespaceValue represents a NamespaceConcept RDF Resource and
    # associated properties.
    class NamespaceValue
      include Concept

      attr_reader :uri

      DC   = RDF::Vocab::DC
      SKOS = RDF::Vocab::SKOS
      BELV = RDF::Vocabulary.new('http://www.openbel.org/vocabulary/')

      def initialize(rdf_repository, uri)
        @rdf_repository = rdf_repository
        @uri            = RDF::URI(uri.to_s)
        @uri_hash       = @uri.hash
        @eq_query       = [
          :subject   => @uri,
          :predicate => SKOS.exactMatch
        ]
        @ortho_query    = [
          :subject   => @uri,
          :predicate => BELV.orthologousMatch
        ]
      end

      def namespace
        schemes = in_scheme
        return nil if schemes.empty?
        Namespace.new(@rdf_repository, schemes.first)
      end

      def in_scheme
        @rdf_repository
        .query([:subject => @uri, :predicate => SKOS.inScheme])
        .select { |solution|
          scheme_uri = solution.object
          @rdf_repository.has_statement?(
            RDF::Statement(scheme_uri, RDF.type, BELV.NamespaceConceptScheme)
          )
        }.map { |solution| solution.object.to_s }
      end

      def equivalents(target_namespaces = :all)
        return to_enum(:equivalents, target_namespaces) unless block_given?
        if target_namespaces == :all
          @rdf_repository.
            query(@eq_query) { |solution|
              yield NamespaceValue.new(@rdf_repository, solution.object)
            }
        else
          target_namespaces = Namespaces.new(@rdf_repository).
            find([target_namespaces].flatten).to_a
          target_namespaces.compact!
          target_namespaces.map! { |ns| ns.uri }

          @rdf_repository.
            query(@eq_query).map { |solution|
              NamespaceValue.new(@rdf_repository, solution.object)
            }.select { |value|
              scheme_uri = value.in_scheme
              target_namespaces.include?(scheme_uri)
            }.each { |value|
              yield value
            }
        end
			end

      def orthologs(target_namespaces = :all)
        return to_enum(:orthologs, target_namespaces) unless block_given?
        if target_namespaces == :all
          @rdf_repository.
            query(@ortho_query) { |solution|
              yield NamespaceValue.new(@rdf_repository, solution.object)
            }
        else
          target_namespaces = Namespaces.new(@rdf_repository).
            find([target_namespaces].flatten).to_a
          target_namespaces.compact!
          target_namespaces.map! { |ns| ns.uri }

          @rdf_repository.
            query(@ortho_query).map { |solution|
              NamespaceValue.new(@rdf_repository, solution.object)
            }.select { |value|
              scheme_uri = value.in_scheme
              target_namespaces.include?(scheme_uri)
            }.each { |value|
              yield value
            }
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
    end
  end
end
