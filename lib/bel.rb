require_relative 'bel/version'
require_relative 'bel/language'
require_relative 'bel/namespace'
require_relative 'bel/util'

require_relative 'bel/extension'
require_relative 'bel/extension_format'
require_relative 'bel/evidence_model'
require_relative 'bel/format'

require_relative 'bel/script'

unless RUBY_PLATFORM =~ /java/
  require_relative 'bel/libbel.rb'
  require_relative 'bel/parser'
  require_relative 'bel/completion'
end

include BEL::Language
include BEL::Namespace

BEL::Extension.load_extension('jgf', 'json/json', 'bel', 'xbel')

begin
  BEL::Extension.load_extension('rdf/rdf')
rescue LoadError => e
  # No RDF support.
  # TODO Report extension load failure.
end
# vim: ts=2 sw=2:
# encoding: utf-8
