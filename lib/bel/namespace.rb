require 'open-uri'

require_relative '../features'
require_relative './language' 

class String
  def split_by_last(char=" ")
    pos = self.rindex(char)
    pos != nil ? [self[0...pos], self[pos+1..-1]] : [self]
  end
end

module BEL
  module Namespace

    LATEST_PREFIX = 'http://resource.belframework.org/belframework/20131211/'
    DEFAULT_URI = 'http://www.openbel.org/bel/namespace/'

    NAMESPACE_LATEST = {
      AFFY: [
        LATEST_PREFIX + 'namespace/affy-probeset-ids.belns',
        'http://www.openbel.org/bel/namespace/affy-probeset/'
      ],
      CHEBI: [
        LATEST_PREFIX + 'namespace/chebi.belns',
        'http://www.openbel.org/bel/namespace/chebi/'
      ],
      CHEBIID: [
        LATEST_PREFIX + 'namespace/chebi-ids.belns',
        'http://www.openbel.org/bel/namespace/chebi/'
      ],
      DO: [
        LATEST_PREFIX + 'namespace/disease-ontology.belns',
        'http://www.openbel.org/bel/namespace/disease-ontology/'
      ],
      DOID: [
        LATEST_PREFIX + 'namespace/disease-ontology-ids.belns',
        'http://www.openbel.org/bel/namespace/disease-ontology/'
      ],
      EGID: [
        LATEST_PREFIX + 'namespace/entrez-gene-ids.belns',
        'http://www.openbel.org/bel/namespace/entrez-gene/'
      ],
      GOBP: [
        LATEST_PREFIX + 'namespace/go-biological-process.belns',
        'http://www.openbel.org/bel/namespace/go-biological-processes/'
      ],
      GOBPID: [
        LATEST_PREFIX + 'namespace/go-biological-process-ids.belns',
        'http://www.openbel.org/bel/namespace/go/'
      ],
      GOCC: [
        LATEST_PREFIX + 'namespace/go-cellular-component.belns',
        'http://www.openbel.org/bel/namespace/go-cellular-component/'
      ],
      GOCCID: [
        LATEST_PREFIX + 'namespace/go-cellular-component-ids.belns',
        'http://www.openbel.org/bel/namespace/go-cellular-component/'
      ],
      HGNC: [
        LATEST_PREFIX + 'namespace/hgnc-human-genes.belns',
        'http://www.openbel.org/bel/namespace/hgnc-human-genes/'
      ],
      MESHCS: [
        LATEST_PREFIX + 'namespace/mesh-cellular-structures.belns',
        'http://www.openbel.org/bel/namespace/mesh-cellular-structures/'
      ],
      MESHD: [
        LATEST_PREFIX + 'namespace/mesh-diseases.belns',
        'http://www.openbel.org/bel/namespace/mesh-diseases/',
      ],
      MESHPP: [
        LATEST_PREFIX + 'namespace/mesh-processes.belns',
        'http://www.openbel.org/bel/namespace/mesh-processes/'
      ],
      MGI: [
        LATEST_PREFIX + 'namespace/mgi-mouse-genes.belns',
        'http://www.openbel.org/bel/namespace/mgi-mouse-genes/'
      ],
      RGD: [
        LATEST_PREFIX + 'namespace/rgd-rat-genes.belns',
        'http://www.openbel.org/bel/namespace/rgd-rat-genes/'
      ],
      SCOMP: [
        LATEST_PREFIX + 'namespace/selventa-named-complexes.belns',
        'http://www.openbel.org/bel/namespace/selventa-named-complexes/'
      ],
      SCHEM: [
        LATEST_PREFIX + 'namespace/selventa-legacy-chemicals.belns',
        'http://www.openbel.org/bel/namespace/selventa-legacy-chemicals/'
      ],
      SDIS: [
        LATEST_PREFIX + 'namespace/selventa-legacy-diseases.belns',
        'http://www.openbel.org/bel/namespace/selventa-legacy-diseases/'
      ],
      SFAM: [
        LATEST_PREFIX + 'namespace/selventa-protein-families.belns',
        'http://www.openbel.org/bel/namespace/selventa-protein-families/'
      ],
      SP: [
        LATEST_PREFIX + 'namespace/swissprot.belns',
        'http://www.openbel.org/bel/namespace/swissprot/'
      ],
      SPAC: [
        LATEST_PREFIX + 'namespace/swissprot-ids.belns',
        'http://www.openbel.org/bel/namespace/swissprot-ids/'
      ]
    }

    # XXX 1.0 namespaces without rdf support
    NAMESPACE_BELNS = {
      HGU95AV2:  'http://resource.belframework.org/belframework/1.0/namespace/affy-hg-u95av2.belns',
      HGU133P2:  'http://resource.belframework.org/belframework/1.0/namespace/affy-hg-u133-plus2.belns',
      HGU133AB:  'http://resource.belframework.org/belframework/1.0/namespace/affy-hg-u133ab.belns',
      MGU74ABC:  'http://resource.belframework.org/belframework/1.0/namespace/affy-mg-u74abc.belns',
      MG430AB:   'http://resource.belframework.org/belframework/1.0/namespace/affy-moe430ab.belns',
      MG4302:    'http://resource.belframework.org/belframework/1.0/namespace/affy-mouse430-2.belns',
      MG430A2:   'http://resource.belframework.org/belframework/1.0/namespace/affy-mouse430a-2.belns',
      RG230AB:   'http://resource.belframework.org/belframework/1.0/namespace/affy-rae230ab-2.belns',
      RG2302:    'http://resource.belframework.org/belframework/1.0/namespace/affy-rat230-2.belns',
      CHEBIID:   'http://resource.belframework.org/belframework/1.0/namespace/chebi-ids.belns',
      CHEBI:     'http://resource.belframework.org/belframework/1.0/namespace/chebi-names.belns',
      EGID:      'http://resource.belframework.org/belframework/1.0/namespace/entrez-gene-ids-hmr.belns',
      GOAC:      'http://resource.belframework.org/belframework/1.0/namespace/go-biological-processes-accession-numbers.belns',
      GO:        'http://resource.belframework.org/belframework/1.0/namespace/go-biological-processes-names.belns',
      GOCCACC:   'http://resource.belframework.org/belframework/1.0/namespace/go-cellular-component-accession-numbers.belns',
      GOCCTERM:  'http://resource.belframework.org/belframework/1.0/namespace/go-cellular-component-terms.belns',
      HGNC:      'http://resource.belframework.org/belframework/1.0/namespace/hgnc-approved-symbols.belns',
      MESHPP:    'http://resource.belframework.org/belframework/1.0/namespace/mesh-biological-processes.belns',
      MESHCL:    'http://resource.belframework.org/belframework/1.0/namespace/mesh-cellular-locations.belns',
      MESHD:     'http://resource.belframework.org/belframework/1.0/namespace/mesh-diseases.belns',
      MGI:       'http://resource.belframework.org/belframework/1.0/namespace/mgi-approved-symbols.belns',
      RGD:       'http://resource.belframework.org/belframework/1.0/namespace/rgd-approved-symbols.belns',
      SCHEM:     'http://resource.belframework.org/belframework/1.0/namespace/selventa-legacy-chemical-names.belns',
      SDIS:      'http://resource.belframework.org/belframework/1.0/namespace/selventa-legacy-diseases.belns',
      NCH:       'http://resource.belframework.org/belframework/1.0/namespace/selventa-named-human-complexes.belns',
      PFH:       'http://resource.belframework.org/belframework/1.0/namespace/selventa-named-human-protein-families.belns',
      NCM:       'http://resource.belframework.org/belframework/1.0/namespace/selventa-named-mouse-complexes.belns',
      PFM:       'http://resource.belframework.org/belframework/1.0/namespace/selventa-named-mouse-protein-families.belns',
      NCR:       'http://resource.belframework.org/belframework/1.0/namespace/selventa-named-rat-complexes.belns',
      PFR:       'http://resource.belframework.org/belframework/1.0/namespace/selventa-named-rat-protein-families.belns',
      SPAC:      'http://resource.belframework.org/belframework/1.0/namespace/swissprot-accession-numbers.belns',
      SP:        'http://resource.belframework.org/belframework/1.0/namespace/swissprot-entry-names.belns'
    }

    class ResourceIndex
      include Enumerable

      attr_accessor :namespaces

      def initialize(index_url, namespaces = [], annotations = [])
        @index_url = index_url
        read_url
      end

      def read_url
        data = open(@index_url).read
        @namespaces = data.
          scan(%r{<idx:namespace idx:resourceLocation="(.*)"}).
          map { |url|
            prefix = open(url.first).read(200).
              match(%r{Keyword=(.*)})[1].to_sym
            NamespaceDefinition.new(prefix, url)
          }
      end
    end

    class NamespaceDefinition
      include Enumerable

      attr_reader :prefix
      attr_reader :url
      attr_reader :rdf_uri
      attr_reader :values

      def initialize(prefix, url, rdf_uri = DEFAULT_URI)
        @prefix = prefix
        @url = url
        @rdf_uri = rdf_uri
        @values = nil
      end

      def [](value)
        return nil unless value

        reload(@url) if not @values
        sym = value.to_sym
        Language::Parameter.new(self, sym,
                                @values[sym]) if @values.key?(sym)
      end

      def each &block
        reload(@url) if not @values
        @values.each do |val, enc|
          if block_given?
            block.call(Language::Parameter.new(self, val, enc))
          else
            yield Language::Parameter.new(self, val, enc)
          end
        end
      end

      def hash
        [@prefix, @url].hash
      end

      def ==(other)
        return false if other == nil
        @prefix == other.prefix && @url == other.url
      end

      alias_method :eql?, :'=='

      def to_s
        @prefix.to_s
      end

      def to_bel
        %Q{DEFINE NAMESPACE #{@prefix} AS URL "#{@url}"}
      end

      private
      # the backdoor
      def reload(url)
        @values = {}
        open(url).
          drop_while { |i| not i.start_with? "[Values]" }.
          drop(1).
          each do |s|
            val_enc = s.strip!.split_by_last('|').map(&:to_sym)
            @values[val_enc[0]] = val_enc[1]
          end
      end
    end

    if BEL::Features.rdf_support?
      require_relative 'rdf'

      class NamespaceDefinition
        def to_uri
          @rdf_uri
        end

        def to_rdf_vocabulary
          RUBYRDF::Vocabulary.new(@rdf_uri)
        end
      end
    end

    # create classes for each standard prefix
    DEFAULT_NAMESPACES = 
      NAMESPACE_LATEST.collect do |prefix, values|
        rdf_uri = NAMESPACE_LATEST[prefix][1] || DEFAULT_URI
        ns_definition = NamespaceDefinition.new(prefix, values[0], rdf_uri)
        Namespace.const_set(prefix, ns_definition)
        ns_definition
      end
  end
end
# vim: ts=2 sw=2:
# encoding: utf-8
