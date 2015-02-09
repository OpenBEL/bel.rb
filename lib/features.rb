# vim: ts=2 sw=2:
module BEL
  module Features

    # check for rdf support
    begin
      require 'rdf'
      require 'addressable/uri'
      require 'uuid'
      @@rdf_support = true
    rescue LoadError => e
      # exceptional condition; missing non-optional or downstream deps
      @@rdf_support = false
      raise unless e.message =~ /rdf/ or e.message =~ /addressable/
    end

    # check for sqlite3 support
    begin
      require 'sqlite3'
      @@sqlite3_support = true
    rescue LoadError => e
      # exceptional condition; missing non-optional or downstream deps
      @@sqlite3_support = false
      raise unless e.message =~ /sqlite3/
    end

    def self.rdf_support?
      @@rdf_support
    end

    def self.sqlite3_support?
      @@sqlite3_support
    end
  end
end
