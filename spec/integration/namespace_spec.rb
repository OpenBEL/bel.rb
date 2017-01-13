require 'bel'

include BEL::Namespace

describe BEL::Namespace do

  describe 'Loading valid BEL namespace URL' do

    it 'can resolve values from a namespace' do
      scomp = NamespaceDefinition.new(
        :SCOMP,
        'http://resource.belframework.org/belframework/20150611/namespace/selventa-named-complexes.belns',
        'http://www.openbel.org/bel/namespace/selventa-named-complexes'
      )
      
      expect(scomp.values.size).to be > 0
    end

    it 'resolves value to BEL::Nanopub::Parameter' do
      scomp = NamespaceDefinition.new(
        :SCOMP,
        'http://resource.belframework.org/belframework/20150611/namespace/selventa-named-complexes.belns',
        'http://www.openbel.org/bel/namespace/selventa-named-complexes'
      )
      
      expect(scomp['9-1-1 Complex']).not_to be_nil
      expect(scomp['9-1-1 Complex']).to     be_a(BEL::Nanopub::Parameter)
    end
  end

  describe 'Retrieving values from a non-resolvable BEL namespace URL' do

    it 'raises error when namespace HTTP URL is 404 Not Found' do
      hgnc = NamespaceDefinition.new(
        :HGNC,
        'http://www.openbel.org/will-never-be-found',
        'http://www.openbel.org/bel/namespace/hgnc-human-genes'
      )

      expect {
        hgnc['AKT1']
      }.to raise_error(OpenURI::HTTPError, '404 Not Found')
    end

    it 'raises error when namespace file does not exist' do
      hgnc = NamespaceDefinition.new(
        :HGNC,
        'file:///my-namespace.belns',
        'http://www.openbel.org/bel/namespace/hgnc-human-genes'
      )

      expect {
        hgnc['AKT1']
      }.to raise_error(Errno::ENOENT)

    end

    it 'warns when namespace URL is not found (includes file, http)' do
      namespaces = [
        NamespaceDefinition.new(:HGNC,
          'http://www.openbel.org/will-never-be-found',
          'http://www.openbel.org/bel/namespace/hgnc-human-genes'
        ),
        NamespaceDefinition.new(:HGNC,
          'file:///my-namespace.belns',
          'http://www.openbel.org/bel/namespace/hgnc-human-genes'
        ),
      ]

      namespaces.each do |ns|
        expect(ns).to receive(:warn).with(/.*Could not retrieve namespace\..*/)
      end

      namespaces.each do |ns|
        begin
          ns['AKT1']
        rescue
          # swallow error because we are not asserting an error is raised.
        end
      end
    end

    it 'warns when namespace HTTP URL is 404 Not Found' do
      hgnc = NamespaceDefinition.new(
        :HGNC,
        'http://www.openbel.org/will-never-be-found',
        'http://www.openbel.org/bel/namespace/hgnc-human-genes'
      )

      expect(hgnc).to receive(:warn).with(/.*Could not retrieve namespace\..*/)
      begin
        hgnc['AKT1']
      rescue
        # swallow error because we are not asserting an error is raised.
      end
    end
  end
end

# vim: ts=2 sw=2
# encoding: utf-8
