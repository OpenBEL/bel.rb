require_relative 'bel/version'
require_relative 'bel/vendor/little-plugger'
require_relative 'bel/language'
require_relative 'bel/namespace'
require_relative 'bel/util'

require_relative 'bel/evidence_model'
require_relative 'bel/translator'
require_relative 'bel/translate'

require_relative 'bel/rdf_repository'
require_relative 'bel/resource'

require_relative 'bel/script'

require_relative 'bel/libbel.rb'
require_relative 'bel/parser'
require_relative 'bel/completion'

include BEL::Language
include BEL::Namespace

module BEL
  extend BEL::Translate::ClassMethods
end
# vim: ts=2 sw=2:
# encoding: utf-8
