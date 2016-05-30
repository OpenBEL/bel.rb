require 'bel'
require 'yaml'

describe 'XBEL support' do
  context 'With test fragment 1' do
    def fragment_path
      path = File.expand_path('..', __FILE__)
      File.open(File.join(path, 'bel', 'fragment1.xbel'))
    end

    def read_fragment
      BEL.nanopub(fragment_path, :xbel).each.to_a
    end

    it 'can be parsed' do
      nanopubs = read_fragment()
      expect(nanopubs).to_not be_nil
      expect(nanopubs.size).to be(1)

      nanopub = nanopubs[0]
      expect(nanopub.metadata).to_not be_nil
      expect(nanopub.metadata.bel_version).to eql('1.0')

      expect(nanopub.experiment_context).to_not be_nil
      exp_ctxt = nanopub.experiment_context
      expect(exp_ctxt.values).to_not be_nil
      expect(exp_ctxt.values.size).to be(3)

      expect(nanopub.references).to_not be_nil
      expect(nanopub.references.values).to_not be_nil
      expect(nanopub.references.values.size).to be(2)

      expect(nanopub.references.annotations).to_not be_nil
      ref_annotations = nanopub.references.annotations
      expect(ref_annotations.size).to be(3)

      expect(nanopub.references.namespaces).to_not be_nil
      ref_namespaces = nanopub.references.namespaces
      expect(ref_namespaces.size).to be(1)

      expect(nanopub.bel_statement).to_not be_nil
      $stderr.puts nanopub.to_yaml
    end

  end

  context 'With test fragment 2' do
    def fragment_path
      path = File.expand_path('..', __FILE__)
      File.open(File.join(path, 'bel', 'fragment2.xbel'))
    end

    def read_fragment
      BEL.nanopub(fragment_path, :xbel).each.to_a
    end

    it 'can be parsed' do
      nanopubs = read_fragment()
      expect(nanopubs).to_not be_nil
      expect(nanopubs.size).to be(1)

      nanopub = nanopubs[0]
      expect(nanopub.metadata).to_not be_nil
      expect(nanopub.metadata.bel_version).to eql('2.0')

      expect(nanopub.experiment_context).to_not be_nil
      exp_ctxt = nanopub.experiment_context
      expect(exp_ctxt.values).to_not be_nil
      expect(exp_ctxt.values.size).to be(3)

      expect(nanopub.references).to_not be_nil
      expect(nanopub.references.values).to_not be_nil
      expect(nanopub.references.values.size).to be(2)

      expect(nanopub.references.annotations).to_not be_nil
      ref_annotations = nanopub.references.annotations
      expect(ref_annotations.size).to be(3)

      expect(nanopub.references.namespaces).to_not be_nil
      ref_namespaces = nanopub.references.namespaces
      expect(ref_namespaces.size).to be(1)

      expect(nanopub.bel_statement).to_not be_nil
    end

  end

  context 'With test fragments' do

    it 'is equal between Nanopub and XBEL' do
      # xbel_file = Tempfile.open('xbel_conversion')
      # BEL.translate(bel_script_file, :bel, :xbel, xbel_file)
      # xbel_file.rewind
      #
      # bel_nanopubs = read_bel_script
      # expect(bel_nanopubs).to_not be_nil
      # expect(bel_nanopubs.size).to be(1)
      #
      # xbel_nanopubs = BEL.nanopub(xbel_file, :xbel).each.to_a
      # expect(xbel_nanopubs).to_not be_nil
      # expect(xbel_nanopubs.size).to be(1)
      #
      # x = bel_nanopubs[0]
      # y = xbel_nanopubs[0]
      #
      # expect(x.bel_statement).to eql(y.bel_statement)
      # expect(x.citation).to eql(y.citation)
      # expect(x.support).to eql(y.support)
      # expect(x.experiment_context).to eql(y.experiment_context)
      #
      # expect(x.metadata).to eql(y.metadata)
    end
  end

  context 'From a JSON Nanopub fragment' do

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

    it 'is equal between Nanopub and XBEL' do
      # xbel_file = Tempfile.open('xbel_conversion')
      # BEL.translate(json_nanopub_file, :json, :xbel, xbel_file)
      # xbel_file.rewind

      # json_nanopub                = read_json_nanopub.first
      # json_nanopub.bel_statement = json_nanopub.bel_statement.to_bel_long_form

      # xbel_nanopub               = BEL.nanopub(xbel_file, :xbel).each.to_a.first
      # xbel_nanopub.bel_statement = xbel_nanopub.bel_statement.to_bel_long_form

      # expect(
      #   xbel_nanopub.to_h
      # ).to eql(
      #   json_nanopub.to_h
      # )
    end
  end

  context 'From an XBEL fragment' do

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

    it 'is equal between XBEL and BEL Script' do
      # bel_script_file = Tempfile.open('bel_conversion')
      # BEL.translate(xbel_file, :xbel, :bel, bel_script_file)
      # bel_script_file.rewind

      # xbel_nanopub               = read_xbel.first
      # xbel_nanopub.bel_statement = xbel_nanopub.bel_statement.to_s

      # bel_script_nanopub               = BEL.nanopub(bel_script_file, :bel).each.to_a.first
      # bel_script_nanopub.bel_statement = bel_script_nanopub.bel_statement.to_s

      # expect(
      #   bel_script_nanopub.to_h
      # ).to eql(
      #   xbel_nanopub.to_h
      # )
    end

    it 'is equal between XBEL and JSON Nanopub' do
      # json_file = Tempfile.open('json_conversion')
      # BEL.translate(xbel_file, :xbel, :json, json_file)
      # json_file.rewind

      # xbel_nanopub               = read_xbel.first
      # xbel_nanopub.bel_statement = xbel_nanopub.bel_statement.to_bel_long_form

      # json_nanopub               = BEL.nanopub(json_file, :json).each.to_a.first
      # json_nanopub.bel_statement = json_nanopub.bel_statement.to_bel_long_form

      # expect(
      #   json_nanopub.to_h
      # ).to eql(
      #   xbel_nanopub.to_h
      # )
    end
  end
end
# vim: ts=2 sw=2
# encoding: utf-8
