require 'bel'
require 'pathname'
require 'tmpdir'

include BEL::Namespace

describe 'Loading BEL resources from a ResourceIndex object' do

  before(:all) do
    Dir[Pathname(Dir::tmpdir) + 'BEL_*'].each(&File.method(:delete))
    expect(Dir[Pathname(Dir::tmpdir) + 'BEL_*'].empty?).to eq(true)
  end

  describe ResourceIndex do

    it "loads resources from http urls" do
      URLS = [
        'http://resource.belframework.org/belframework/1.0/index.xml',
        'http://resource.belframework.org/belframework/20131211/index.xml'
      ]

      URLS.each do |url|
        index = ResourceIndex.new(url)
        expect(index.namespaces.size).to be > 0
        expect(index.annotations.size).to be > 0
      end
    end

    it "loads resources from local path" do
      local_path = "#{File.dirname(__FILE__)}/index.xml"
      expect(File.exist? local_path).to be_truthy

      index = ResourceIndex.new(local_path)
      expect(index.namespaces.size).to be > 0
      expect(index.annotations.size).to be > 0
    end

    it "loads resources from file urls" do
      local_path = "#{File.dirname(__FILE__)}/index.xml"
      expect(File.exist? local_path).to be_truthy
      local_uri = "file://#{local_path}"

      index = ResourceIndex.new(local_uri)
      expect(index.namespaces.size).to be > 0
      expect(index.annotations.size).to be > 0
    end

    it "can retrieve OpenBEL published resources" do
      ['1.0', '20131211'].each do |version|
        index = ResourceIndex.openbel_published_index(version)
        expect(index.namespaces.size).to be > 0
        expect(index.annotations.size).to be > 0
      end
    end

    it "fail if location is invalid" do
      expect {
        bogus_path = Pathname(Dir.tmpdir) + 'doesnotexist.foobar'
        ResourceIndex.openbel_published_index(bogus_path).namespaces
      }.to raise_error(OpenURI::HTTPError)

      expect {
        ResourceIndex.openbel_published_index('FOO_BAR').namespaces
      }.to raise_error(OpenURI::HTTPError)
    end
  end
end

# vim: ts=2 sw=2
# encoding: utf-8
