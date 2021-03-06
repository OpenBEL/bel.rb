require 'rdf'

module BEL
  module Resource

    class BELV < RDF::StrictVocabulary('http://www.openbel.org/vocabulary/')
      term     :AnnotationConcept
      term     :AnnotationConceptScheme
      term     :NamespaceConcept
      term     :NamespaceConceptScheme

      property :prefix
      property :domain
      property :species
      property :inScheme
      property :orthologousMatch
    end

    FULL_URI_REGEX = /\A#{URI::regexp}\z/
  end
end

require_relative 'resource/annotations'
require_relative 'resource/annotation'
require_relative 'resource/annotation_value'
require_relative 'resource/namespaces'
require_relative 'resource/namespace'
require_relative 'resource/namespace_value'
require_relative 'resource/search'
