#!/usr/bin/env ruby
# bel2rdf: Convert BEL to RDF triples.
#
# From BEL file
# usage: bel2rdf -b file.bel
#
# From file
# usage: bel2rdf --bel [FILE]
#
# From standard in
# usage: echo "<BEL DOCUMENT STRING>" | bel2rdf
#
# Format option
# usage: bel2rdf --bel [FILE] --format [ntriples | nquads | turtle]

$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib'))
require 'bel'
require 'optparse'
require 'set'
require 'open-uri'

# Check if RDF format extension is loaded
unless BEL::Extension::Format.formatters(:rdf)
  $stderr.puts "An RDF format extension is not loaded."
  $stderr.puts "Try loading one with:"
  $stderr.puts "    Try BEL::Extension.load_extension('rdf')"
  exit 1
end

# setup and parse options
options = {
  format: 'ntriples',
  schema: false
}
OptionParser.new do |opts|
  opts.banner = '''Converts BEL statements to RDF triples.
Usage: bel2rdf --bel [FILE]'''

  opts.on('-b', '--bel FILE', 'BEL file to convert.  STDIN (standard in) can also be used for BEL content.') do |bel|
    options[:bel] = bel
  end

  opts.on('-f', '--format FORMAT', 'RDF file format.') do |format|
    options[:format] = format.downcase
  end

  opts.on('-s', '--[no-]schema', 'Write BEL RDF schema?') do |schema|
    options[:schema] = schema
  end
end.parse!

if options[:bel] and not File.exists? options[:bel]
  $stderr.puts "No file for bel, #{options[:bel]}"
  exit 1
end
unless ['ntriples', 'nquads', 'turtle'].include? options[:format]
  $stderr.puts "Format was not one of: ntriples, nquads, or turtle"
  exit 1
end


class Main
  include BEL::Language
  include BEL::Model

  def initialize(content, writer)
    BEL::Script.parse(content).find_all { |obj|
      obj.is_a? Statement
    }.each do |stmt|
      triples = stmt.to_rdf[1]
      triples.each do |triple|
        writer << triple
      end
    end
  end
end

class Serializer
  attr_reader :writer

  def initialize(stream, format)
    rdf_writer = find_writer(format)
    @writer = rdf_writer.new($stdout, {
        :stream => stream
      }
    )
  end

  def <<(trpl)
    @writer.write_statement(RDF::Statement(*trpl))
  end

  def done
    @writer.write_epilogue
  end

  private

  def find_writer(format)
    case format
    when 'nquads'
      BEL::RDF::RDF::NQuads::Writer
    when 'turtle'
      begin
        require 'rdf/turtle'
        BEL::RDF::RDF::Turtle::Writer
      rescue LoadError
        $stderr.puts """Turtle format not supported.
Install the 'rdf-turtle' gem."""
        raise
      end
    when 'ntriples'
      BEL::RDF::RDF::NTriples::Writer
    end
  end
end

# create writer for format
rdf_writer = ::Serializer.new(true, options[:format])

# first write schema if desired
if options[:schema]
  BEL::RDF::vocabulary_rdf.each do |trpl|
    rdf_writer << trpl
  end
end

# read bel content
content =
  if options[:bel]
    File.open(options[:bel], :external_encoding => 'UTF-8')
  else
    $stdin
  end

# parse and write rdf
Main.new(content, rdf_writer)
# vim: ts=2 sw=2:
# encoding: utf-8
