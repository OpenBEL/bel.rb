require 'bel'

describe 'Compare Nanopub model across Translator plugins' do

  context 'Starting with a BEL Script fragment' do

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

    it 'BEL Script fragment parses correctly' do
      nanopub_from_bel = read_bel_script
      expect(nanopub_from_bel.size).to eql(1)
    end

    it 'equal to Nanopub translated to JSON Nanopub' do
      json_file = Tempfile.open('json_conversion')
      BEL.translate(bel_script_file, :bel, :json, json_file)
      json_file.rewind

      bel_nanopub               = read_bel_script.first
      bel_nanopub.bel_statement = bel_nanopub.bel_statement.to_s

      json_nanopub               = BEL.nanopub(json_file, :json).each.to_a.first
      json_nanopub.bel_statement = json_nanopub.bel_statement.to_s

      expect(
        json_nanopub.to_h
      ).to eql(
        bel_nanopub.to_h
      )
    end
  end

  context 'Starting with a JSON Nanopub fragment' do

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

    it 'JSON Nanopub fragment parses correctly' do
      nanopub_from_json = read_json_nanopub
      expect(nanopub_from_json.size).to eql(1)
    end

    it 'equal to Nanopub translated to BEL Script' do
      bel_script_file = Tempfile.open('bel_conversion')
      BEL.translate(json_nanopub_file, :json, :bel, bel_script_file)
      bel_script_file.rewind

      json_nanopub               = read_json_nanopub.first
      json_nanopub.bel_statement = json_nanopub.bel_statement.to_s

      bel_script_nanopub               = BEL.nanopub(bel_script_file, :bel).each.to_a.first
      bel_script_nanopub.bel_statement = bel_script_nanopub.bel_statement.to_s

      expect(
        bel_script_nanopub.to_h
      ).to eql(
        json_nanopub.to_h
      )
    end
  end
end
# vim: ts=2 sw=2
# encoding: utf-8
