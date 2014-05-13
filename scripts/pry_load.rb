# vim: ts=2 sw=2:
require '../lib/bel.rb'

begin
  include BEL::RDF
rescue LoadError
  $stderr.puts "Warning: BEL::RDF not loaded"
end
