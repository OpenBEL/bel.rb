require 'bel'

describe 'Compare Evidence Model across Translator plugins' do

  context 'Starting with a BEL Script fragment' do

    def bel_script_file
      File.open(
        File.join(
          File.expand_path('..', __FILE__), 'bel', 'fragment.bel'
        )
      )
    end

    def read_bel_script
      BEL.evidence(bel_script_file, :bel).each.to_a
    end

    it 'BEL Script fragment parses correctly' do
      evidence_from_bel = read_bel_script
      expect(evidence_from_bel.size).to eql(1)
    end

    it 'equal to Evidence translated to JSON Evidence' do
      json_file = Tempfile.open('json_conversion')
      BEL.translate(bel_script_file, :bel, :json, json_file)
      json_file.rewind

      bel_evidence               = read_bel_script.first
      bel_evidence.bel_statement = bel_evidence.bel_statement.to_s

      json_evidence               = BEL.evidence(json_file, :json).each.to_a.first
      json_evidence.bel_statement = json_evidence.bel_statement.to_s

      expect(
        json_evidence.to_h
      ).to eql(
        bel_evidence.to_h
      )
    end

    it 'equal to Evidence translated to XBEL' do
      xbel_file = Tempfile.open('xbel_conversion')
      BEL.translate(bel_script_file, :bel, :xbel, xbel_file)
      xbel_file.rewind

      bel_evidence               = read_bel_script.first
      bel_evidence.bel_statement = bel_evidence.bel_statement.to_bel_long_form

      xbel_evidence               = BEL.evidence(xbel_file, :xbel).each.to_a.first
      xbel_evidence.bel_statement = xbel_evidence.bel_statement.to_bel_long_form

      expect(
        xbel_evidence.to_h
      ).to eql(
        bel_evidence.to_h
      )
    end
  end

  context 'Starting with a JSON Evidence fragment' do

    def json_evidence_file
      File.open(
        File.join(
          File.expand_path('..', __FILE__), 'bel', 'fragment.json'
        )
      )
    end

    def read_json_evidence
      BEL.evidence(json_evidence_file, :json).each.to_a
    end

    it 'JSON Evidence fragment parses correctly' do
      evidence_from_json = read_json_evidence
      expect(evidence_from_json.size).to eql(1)
    end

    it 'equal to Evidence translated to BEL Script' do
      bel_script_file = Tempfile.open('bel_conversion')
      BEL.translate(json_evidence_file, :json, :bel, bel_script_file)
      bel_script_file.rewind

      json_evidence               = read_json_evidence.first
      json_evidence.bel_statement = json_evidence.bel_statement.to_s

      bel_script_evidence               = BEL.evidence(bel_script_file, :bel).each.to_a.first
      bel_script_evidence.bel_statement = bel_script_evidence.bel_statement.to_s

      expect(
        bel_script_evidence.to_h
      ).to eql(
        json_evidence.to_h
      )
    end

    it 'equal to Evidence translated to XBEL' do
      xbel_file = Tempfile.open('xbel_conversion')
      BEL.translate(json_evidence_file, :json, :xbel, xbel_file)
      xbel_file.rewind

      json_evidence                = read_json_evidence.first
      json_evidence.bel_statement = json_evidence.bel_statement.to_bel_long_form

      xbel_evidence               = BEL.evidence(xbel_file, :xbel).each.to_a.first
      xbel_evidence.bel_statement = xbel_evidence.bel_statement.to_bel_long_form

      expect(
        xbel_evidence.to_h
      ).to eql(
        json_evidence.to_h
      )
    end
  end

  context 'Starting with an XBEL fragment' do

    def xbel_file
      File.open(
        File.join(
          File.expand_path('..', __FILE__), 'bel', 'fragment.xbel'
        )
      )
    end

    def read_xbel
      BEL.evidence(xbel_file, :xbel).each.to_a
    end

    it 'XBEL fragment parses correctly' do
      evidence_from_xbel = read_xbel
      expect(evidence_from_xbel.size).to eql(1)
    end

    it 'equal to Evidence translated to BEL Script' do
      bel_script_file = Tempfile.open('bel_conversion')
      BEL.translate(xbel_file, :xbel, :bel, bel_script_file)
      bel_script_file.rewind

      xbel_evidence               = read_xbel.first
      xbel_evidence.bel_statement = xbel_evidence.bel_statement.to_s

      bel_script_evidence               = BEL.evidence(bel_script_file, :bel).each.to_a.first
      bel_script_evidence.bel_statement = bel_script_evidence.bel_statement.to_s

      expect(
        bel_script_evidence.to_h
      ).to eql(
        xbel_evidence.to_h
      )
    end

    it 'equal to Evidence translated to JSON Evidence' do
      json_file = Tempfile.open('json_conversion')
      BEL.translate(xbel_file, :xbel, :json, json_file)
      json_file.rewind

      xbel_evidence               = read_xbel.first
      xbel_evidence.bel_statement = xbel_evidence.bel_statement.to_bel_long_form

      json_evidence               = BEL.evidence(json_file, :json).each.to_a.first
      json_evidence.bel_statement = json_evidence.bel_statement.to_bel_long_form

      expect(
        json_evidence.to_h
      ).to eql(
        xbel_evidence.to_h
      )
    end
  end
end
# vim: ts=2 sw=2
# encoding: utf-8
