# vim: ts=2 sw=2:
$: << File.join(File.expand_path('.'), '..', 'lib')
require 'bel'

begin
  include BEL::RDF
rescue LoadError
  $stderr.puts "Warning: BEL::RDF not loaded"
end
