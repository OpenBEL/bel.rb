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

    def self.rdf_support?
      @@rdf_support
    end
  end
end
