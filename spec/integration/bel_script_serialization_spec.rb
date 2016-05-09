require 'bel'
require 'bel/gen'
require 'rantly/rspec_extensions'

describe 'BEL Script serializations produce equivalent nanopubs' do

  class Rantly
    include BEL::Gen::Nanopub
  end

  def round_trip(nanopub, serialization)
    bel_script     = BEL.translator(:bel)
    bel_script_io  = StringIO.new
    bel_script.write(
      [nanopub],
      bel_script_io,
      :write_header => true,
      :serialization => serialization
    )
    bel_script.read(bel_script_io).each.to_a
  end

  it 'Nanopub is equivalent between BEL Script serialization strategies' do
    property_of {
      nanopub
    }.check { |nanopub|
      [:discrete, :topdown, :citation].combination(2).each do |(fmt1, fmt2)|
        expect(
          round_trip(nanopub, fmt1)
        ).to eql(
          round_trip(nanopub, fmt2)
        )
      end
    }
  end

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

    it 'equal to Nanopub translated to BNJ' do
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

    it 'equal to Nanopub translated to XBEL' do
      xbel_file = Tempfile.open('xbel_conversion')
      BEL.translate(bel_script_file, :bel, :xbel, xbel_file)
      xbel_file.rewind

      bel_nanopub               = read_bel_script.first
      bel_nanopub.bel_statement = bel_nanopub.bel_statement.to_bel_long_form

      xbel_nanopub               = BEL.nanopub(xbel_file, :xbel).each.to_a.first
      xbel_nanopub.bel_statement = xbel_nanopub.bel_statement.to_bel_long_form

      expect(
        xbel_nanopub.to_h
      ).to eql(
        bel_nanopub.to_h
      )
    end
  end

  context 'Starting with a BNJ fragment' do

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

    it 'BNJ fragment parses correctly' do
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

    it 'equal to Nanopub translated to XBEL' do
      xbel_file = Tempfile.open('xbel_conversion')
      BEL.translate(json_nanopub_file, :json, :xbel, xbel_file)
      xbel_file.rewind

      json_nanopub                = read_json_nanopub.first
      json_nanopub.bel_statement = json_nanopub.bel_statement.to_bel_long_form

      xbel_nanopub               = BEL.nanopub(xbel_file, :xbel).each.to_a.first
      xbel_nanopub.bel_statement = xbel_nanopub.bel_statement.to_bel_long_form

      expect(
        xbel_nanopub.to_h
      ).to eql(
        json_nanopub.to_h
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
      BEL.nanopub(xbel_file, :xbel).each.to_a
    end

    it 'XBEL fragment parses correctly' do
      nanopub_from_xbel = read_xbel
      expect(nanopub_from_xbel.size).to eql(1)
    end

    it 'equal to Nanopub translated to BEL Script' do
      bel_script_file = Tempfile.open('bel_conversion')
      BEL.translate(xbel_file, :xbel, :bel, bel_script_file)
      bel_script_file.rewind

      xbel_nanopub               = read_xbel.first
      xbel_nanopub.bel_statement = xbel_nanopub.bel_statement.to_s

      bel_script_nanopub               = BEL.nanopub(bel_script_file, :bel).each.to_a.first
      bel_script_nanopub.bel_statement = bel_script_nanopub.bel_statement.to_s

      expect(
        bel_script_nanopub.to_h
      ).to eql(
        xbel_nanopub.to_h
      )
    end

    it 'equal to Nanopub translated to BNJ' do
      json_file = Tempfile.open('json_conversion')
      BEL.translate(xbel_file, :xbel, :json, json_file)
      json_file.rewind

      xbel_nanopub               = read_xbel.first
      xbel_nanopub.bel_statement = xbel_nanopub.bel_statement.to_bel_long_form

      json_nanopub               = BEL.nanopub(json_file, :json).each.to_a.first
      json_nanopub.bel_statement = json_nanopub.bel_statement.to_bel_long_form

      expect(
        json_nanopub.to_h
      ).to eql(
        xbel_nanopub.to_h
      )
    end
  end
end
# vim: ts=2 sw=2
# encoding: utf-8
