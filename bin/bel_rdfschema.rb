#!/usr/bin/env ruby
# bel_rdfschema: Dump RDF schema for BEL.
# usage: bel_rdfschema --format [RDF-based translator]

$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib'))
require 'bel'
require 'optparse'
require 'set'
require 'open-uri'

options = {
  format: 'ntriples'
}
OptionParser.new do |opts|
  opts.banner = <<-USAGE
    Dumps RDF schema for BEL.
    Usage: bel_rdfschema --format [RDF-based translator]
  USAGE

  opts.on('-f', '--format FORMAT', 'RDF file format.') do |format|
    options[:format] = format.downcase
  end
end.parse!

begin
  empty_input = StringIO.new

  BEL.translate(empty_input, :bel, options[:format], $stdout,
    {
      :write_schema => true
    }
  )
ensure
  $stdout.close
end
# vim: ts=2 sw=2:
# encoding: utf-8
