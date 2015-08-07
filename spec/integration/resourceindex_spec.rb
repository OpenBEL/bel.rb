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

    def load_with_retry(index_location, tries = 3)
      index =
        if !index_location.to_i.zero?
          ResourceIndex.openbel_published_index(index_location)
        else
          ResourceIndex.new(index_location)
        end

      # force resources to load
      index.namespaces
      index.annotations

      index
    rescue StandardError => err
      tries -= 1
      $stderr.puts "Error: #{err.class} (#{tries} tries left), message: #{err.message}"
      retry unless tries.zero?
    end

    it "loads resources from http urls" do
      URLS = [
        'http://resource.belframework.org/belframework/1.0/index.xml',
        'http://resource.belframework.org/belframework/20131211/index.xml'
      ]

      URLS.each do |url|
        index = load_with_retry(url)
        expect(index.namespaces.size).to be > 0
        expect(index.annotations.size).to be > 0
      end
    end

    it "loads resources from local path" do
      local_path = "#{File.dirname(__FILE__)}/index.xml"
      expect(File.exist? local_path).to be_truthy

      index = load_with_retry(local_path)
      expect(index.namespaces.size).to be > 0
      expect(index.annotations.size).to be > 0
    end

    it "loads resources from file urls" do
      local_path = "#{File.dirname(__FILE__)}/index.xml"
      expect(File.exist? local_path).to be_truthy
      local_uri = "file://#{local_path}"

      index = load_with_retry(local_uri)
      expect(index.namespaces.size).to be > 0
      expect(index.annotations.size).to be > 0
    end

    it "can retrieve OpenBEL published resources" do
      ['1.0', '20131211'].each do |version|
        index = load_with_retry(version)

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
