require 'bel'

describe 'Test fragments' do
  context 'in BEL Script format' do
    def bel_script_file
      File.open(
        File.join(
          File.expand_path('..', __FILE__), 'bel', 'fragment.bel'
        )
      )
    end

    def read_bel_script
      BEL.nanopub(bel_script_file, :bel).each.to_a
    end

    it 'is parsed correctly' do
      nanopub_from_bel = read_bel_script
      expect(nanopub_from_bel.size).to eql(1)
    end
  end

  context 'in XBEL v1 format' do
    def xbel_file
      File.open(
        File.join(
          File.expand_path('..', __FILE__), 'bel', 'fragment1.xbel'
        )
      )
    end

    def read_xbel
      BEL.nanopub(xbel_file, :xbel).each.to_a
    end

    it 'is parsed correctly' do
      nanopub_from_xbel = read_xbel
      expect(nanopub_from_xbel.size).to eql(1)
    end
  end

  context 'in XBEL v2 format' do
    def xbel_file
      File.open(
        File.join(
          File.expand_path('..', __FILE__), 'bel', 'fragment2.xbel'
        )
      )
    end

    def read_xbel
      BEL.nanopub(xbel_file, :xbel).each.to_a
    end

    it 'is parsed correctly' do
      nanopub_from_xbel = read_xbel
      expect(nanopub_from_xbel.size).to eql(1)
    end
  end

  context 'in JSON Nanopub format' do
    def json_nanopub_file
      File.open(
        File.join(
          File.expand_path('..', __FILE__), 'bel', 'fragment.json'
        )
      )
    end

    def read_json_nanopub
      BEL.nanopub(json_nanopub_file, :json).each.to_a
    end

    it 'is parsed correctly' do
      nanopub_from_json = read_json_nanopub
      expect(nanopub_from_json.size).to eql(1)
    end
  end
end
