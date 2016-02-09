require 'open-uri'

require_relative 'language'
require_relative 'util'

module BEL
  module Annotation

    LATEST_PREFIX = 'http://resource.belframework.org/belframework/latest-release/'
    DEFAULT_URI = 'http://www.openbel.org/bel/namespace/'

    ANNOTATION_LATEST = {
      Anatomy: [
        LATEST_PREFIX + 'annotation/anatomy.belanno',
        'http://www.openbel.org/bel/namespace/uberon/'
      ],
      CellLine: [
        LATEST_PREFIX + 'annotation/cell-line.belanno',
        'http://www.openbel.org/bel/namespace/cell-line-ontology/'
      ],
      CellStructure: [
        LATEST_PREFIX + 'annotation/cell-structure.belanno',
        'http://www.openbel.org/bel/namespace/mesh-cellular-structures/'
      ],
      Cell: [
        LATEST_PREFIX + 'annotation/cell.belanno',
        'http://www.openbel.org/bel/namespace/cell-ontology/'
      ],
      Disease: [
        LATEST_PREFIX + 'annotation/disease.belanno',
        'http://www.openbel.org/bel/namespace/disease-ontology/'
      ],
      MeSHAnatomy: [
        LATEST_PREFIX + 'annotation/mesh-anatomy.belanno',
        'http://www.openbel.org/bel/namespace/mesh-anatomy/'
      ],
      MeSHDisease: [
        LATEST_PREFIX + 'annotation/mesh-diseases.belanno',
        'http://www.openbel.org/bel/namespace/mesh-diseases/'
      ],
      Species: [
        LATEST_PREFIX + 'annotation/species-taxonomy-id.belanno',
        'http://www.openbel.org/bel/namespace/ncbi-taxonomy/'
      ],
    }

    class AnnotationDefinition
      include Enumerable

      attr_reader :keyword
      attr_reader :url
      attr_reader :rdf_uri

      def initialize(keyword, url, rdf_uri = DEFAULT_URI)
        @keyword = keyword
        @url = url
        @rdf_uri = rdf_uri
        @values = nil
      end

      def values
        unless @values
          reload(@url)
        end
        @values
      end

      def [](value)
        return nil unless value
        reload(@url) if not @values
        sym = value.to_sym
        Language::Annotation.new(keyword, sym)
      end

      def each
        reload(@url) if not @values
        if block_given?
          annotation_keyword = keyword
          @values.each do |val, _|
            yield Language::Annotation.new(annotation_keyword, val.to_sym)
          end
        else
          to_enum(:each)
        end
      end

      def hash
        [@keyword, @url].hash
      end

      def ==(other)
        return false if other == nil
        @keyword == other.keyword && @url == other.url
      end

      alias_method :eql?, :'=='

      def to_s
        @keyword.to_s
      end

      def to_bel
        %Q{DEFINE ANNOTATION #@keyword AS URL "#@url"}
      end

      private

      def reload(url)
        @values = BEL::read_resource(url)
      end
    end

    # create classes for each standard keyword
    DEFAULT_ANNOTATIONS =
      ANNOTATION_LATEST.collect do |keyword, values|
        rdf_uri  = ANNOTATION_LATEST[keyword][1] || DEFAULT_URI
        anno_def = AnnotationDefinition.new(keyword, values[0], rdf_uri)
        Annotation.const_set(keyword, anno_def)
        anno_def
      end
  end
end
# vim: ts=2 sw=2:
# encoding: utf-8
