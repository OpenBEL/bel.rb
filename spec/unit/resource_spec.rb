require 'bel'

describe BEL::Resource do

  let(:rdf_repository) {
    repo = BEL::RdfRepository.plugins[:memory].create_repository
    repo.load(
      File.expand_path('resource_spec.nt', File.dirname(__FILE__)),
      :format => :ntriples
    )
    repo
  }

  describe BEL::Resource::Namespaces do

    let(:namespaces) {
      BEL::Resource::Namespaces.new(rdf_repository)
    }

    it 'enumerates all namespaces using block syntax' do
      count = 0
      namespaces.each do |namespace|
        count += 1
      end
      expect(count).to eq(2)
    end

    it 'enumerates all namespaces using enumerator' do
      expect(namespaces.each.count).to eq(2)
    end

    it 'BEL::Resource::Namespace objects are initialized with their URIs' do
      namespaces.each.all? { |namespace|
        expect(namespace).to respond_to(:uri)
      }
    end

    it 'find BEL::Resource::Namespace objects by prefix' do
      expect(namespaces.find('egid', 'hgnc').count).to eq(2)
    end

    it 'find BEL::Resource::Namespace objects by prefLabel' do
      expect(namespaces.find('Entrez Gene', 'Hgnc Human Genes').count).to eq(2)
    end

    it 'find BEL::Resource::Namespace objects by RDF::URI' do
      expect(
        namespaces.find(
          RDF::URI('http://www.openbel.org/bel/namespace/entrez-gene'),
          RDF::URI('http://www.openbel.org/bel/namespace/hgnc-human-genes')
        ).count
      ).to eq(2)
    end

    it 'find BEL::Resource::Namespace objects by multiple types' do
      expect(
        namespaces.find(
          'hgnc',
          'Hgnc Human Genes',
          RDF::URI('http://www.openbel.org/bel/namespace/hgnc-human-genes'),
          nil,
        ).count
      ).to eq(4)
    end

    describe BEL::Resource::Namespace do

      let(:hgnc) {
        namespaces.find('hgnc').first
      }

      it 'enumerates all namespace values using block syntax' do
        count = 0
        hgnc.each do |namespace_value|
          count += 1
        end
        expect(count).to eq(1)
      end

      it 'enumerates all namespace values using enumerator' do
        expect(hgnc.each.count).to eq(1)
      end

      it 'BEL::Resource::NamespaceValue objects are initialized with their URIs' do
        hgnc.each.all? { |namespace_value|
          expect(namespace_value).to respond_to(:uri)
          expect(namespace_value).to be_kind_of(BEL::Resource::NamespaceValue)
        }
      end

      it 'find incorrect value returns nil indicating no match' do
        expect(hgnc.find('FOOBARBAZ').count).to eq(1)
        expect(hgnc.find('FOOBARBAZ').first).to be_nil
      end

      it 'find BEL::Resource::NamespaceValue objects by identifier' do
        expect(hgnc.find('391').count).to eq(1)
        expect(hgnc.find('391').first).to be_kind_of(BEL::Resource::NamespaceValue)
      end

      it 'find BEL::Resource::NamespaceValue objects by prefLabel' do
        expect(hgnc.find('AKT1').count).to eq(1)
        expect(hgnc.find('AKT1').first).to be_kind_of(BEL::Resource::NamespaceValue)
      end

      it 'find BEL::Resource::NamespaceValue objects by RDF::URI' do
        uri = RDF::URI('http://www.openbel.org/bel/namespace/hgnc-human-genes/391')
        expect(hgnc.find(uri).count).to     eq(1)
        expect(hgnc.find(uri).first).to be_kind_of(BEL::Resource::NamespaceValue)
      end

      it 'find BEL::Resource::Namespace objects by multiple types' do
        results = hgnc.find(
          nil,
          '',
          '391',
          'AKT1',
          'v-akt murine thymoma viral oncogene homolog 1',
          RDF::URI('http://www.openbel.org/bel/namespace/hgnc-human-genes/391')
        )
        expect(results.count).to eq(6)
        expect(results.to_a).to eq([
          nil,
          nil,
          hgnc.find('391').first,
          hgnc.find('391').first,
          hgnc.find('391').first,
          hgnc.find('391').first
        ])
      end

      describe BEL::Resource::NamespaceValue do

        let(:akt1) {
          hgnc.find('AKT1').first
        }

        it 'returns uri' do
          expect(akt1).to     respond_to(:uri)
          expect(akt1.uri).to eq(RDF::URI('http://www.openbel.org/bel/namespace/hgnc-human-genes/391'))
        end

        it 'returns identifier value (i.e. through dc:identifier predicate)' do
          expect(akt1).to            respond_to(:identifier)
          expect(akt1.identifier).to eq(['391'])
        end

        it 'returns prefLabel value (i.e. through skos:prefLabel predicate)' do
          expect(akt1).to            respond_to(:pref_label)
          expect(akt1.pref_label).to  eq(['AKT1'])
        end

        it 'returns title value (i.e. through dc:title predicate)' do
          expect(akt1).to            respond_to(:title)
          expect(akt1.title).to      eq(['v-akt murine thymoma viral oncogene homolog 1'])
        end

        it 'returns inScheme value (i.e. through skos:inScheme predicate)' do
          expect(akt1).to            respond_to(:in_scheme)
          expect(akt1.in_scheme).to  eq(['http://www.openbel.org/bel/namespace/hgnc-human-genes'])
        end

        it 'returns equivalent namespace values' do
          expect(akt1.equivalents.count).to eq(1)
          expect(akt1.equivalents.first).to eq(namespaces.find('egid').first.find('207').first)
        end

        it 'returns orthologous namespace values' do
          expect(akt1.orthologs.count).to eq(2)
          expect(akt1.orthologs.to_a).to(
            include(
              BEL::Resource::NamespaceValue.new(
                rdf_repository,
                RDF::URI('http://www.openbel.org/bel/namespace/mgi-mouse-genes/87986'))
            ))
          expect(akt1.orthologs.to_a).to(
            include(
            BEL::Resource::NamespaceValue.new(
              rdf_repository,
              RDF::URI('http://www.openbel.org/bel/namespace/rgd-rat-genes/2081'))
            ))
        end
      end
    end
  end
end
