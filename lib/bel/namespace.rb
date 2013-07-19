# vim: ts=2 sw=2:
require 'open-uri'
require_relative './language' 

class String
  def split_by_last(char=" ")
    pos = self.rindex(char)
    pos != nil ? [self[0...pos], self[pos+1..-1]] : [self]
  end
end

module BEL
  module Namespace

    NAMESPACE_HASH = {
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

    class NamespaceDefinition

      attr_reader :url
      attr_reader :values

      def initialize(prefix, url)
        @prefix = prefix
        @url = url
        @values = nil
      end

      def [](value)
        reload(@url) if not @values
        return nil unless value
        sym = value.to_sym
        Language::Parameter.new(@prefix, sym,
                                @values[sym]) if @values.key?(sym)
      end

      def each &block
        ns = @prefix.to_sym
        @values.each do |val, enc|
          if block_given?
            block.call(Language::Parameter.new(ns, val, enc))
          else
            yield Language::Parameter.new(ns, val, enc)
          end
        end
      end

      private
      # the backdoor
      def reload(url)
        @values = {}
        open(url).
          drop_while { |i| i != "[Values]\n" }.
          drop(1).
          each do |s|
            val_enc = s.strip!.split_by_last('|').map(&:to_sym)
            @values[val_enc[0]] = val_enc[1]
          end
      end
    end

    # create classes for each standard prefix
    DEFAULT_NAMESPACES = [
      NAMESPACE_HASH.collect do |prefix, default_url|
        ns_definition = NamespaceDefinition.new(prefix, default_url)
        Namespace.const_set(prefix, ns_definition)
        ns_definition
      end
    ]
  end
end
