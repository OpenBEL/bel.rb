module BEL
  autoload :Language,  "#{File.dirname(__FILE__)}/bel/language"
  autoload :Namespace, "#{File.dirname(__FILE__)}/bel/namespace"
  autoload :Script,    "#{File.dirname(__FILE__)}/bel/script"
  autoload :RDF,       "#{File.dirname(__FILE__)}/bel/rdf"

  require_relative './features.rb'
end
# vim: ts=2 sw=2:
# encoding: utf-8
