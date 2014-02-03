# vim: ts=2 sw=2:
require '../lib/bel.rb'
include BEL::Language
include BEL::Namespace
include BEL::Script

begin
  include BEL::RDF
rescue LoadError
  $stderr.puts "Warning: BEL::RDF not loaded"
end
