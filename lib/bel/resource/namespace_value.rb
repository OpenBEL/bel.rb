require          'rdf'
require_relative 'namespaces'

module BEL
  module Resource

    # TODO Document
    class NamespaceValue

      attr_reader :uri

      # TODO Document
      def initialize(rdf_repository, uri)
        @rdf_repository = rdf_repository
        @uri            = RDF::URI(uri.to_s)
        @uri_hash       = @uri.hash
        @eq_query       = [
          :subject   => @uri,
          :predicate => RDF::SKOS.exactMatch
        ]
        @ortho_query    = [
          :subject   => @uri,
          :predicate => BELV.orthologousMatch
        ]
        @predicates     = @rdf_repository.query(:subject => @uri).
                            each.map(&:predicate).uniq
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
              scheme_uri = value.inScheme
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
              scheme_uri = value.inScheme
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
