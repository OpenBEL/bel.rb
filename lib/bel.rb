# Load core objects
require_relative './bel/libbel.rb'
require_relative 'bel/parser'
require_relative 'bel/completion'
require_relative 'bel/language'
require_relative 'bel/namespace'
require_relative 'bel/version'

module BEL
  autoload :Script,    "#{File.dirname(__FILE__)}/bel/script"
  autoload :RDF,       "#{File.dirname(__FILE__)}/bel/rdf"

  require_relative './features.rb'
  require_relative './util.rb'
end
# vim: ts=2 sw=2:
# encoding: utf-8
