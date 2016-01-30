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

warn <<-DEPRECATION.gsub(/^ {2}/, '')
  ======================================================================
  DEPRECATION WARNING

  bel2rdf command is deprecated and will be removed starting from 0.6.0.

  Instead use the bel command with the translate subcommand.

  Translate from BEL Script file to ntriples:

    bel translate --input-file small_corpus.bel bel ntriples

  Translate from XBEL on standard input to RDF/XML:

    cat small_corpus.xbel | bel translate xbel rdfxml
  ======================================================================
DEPRECATION

$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib'))
require 'bel'
require 'optparse'
require 'set'
require 'open-uri'

RDF_TRANSLATORS = %w(jsonld ntriples nquads rdfa rdfxml rj trig trix turtle)

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
unless RDF_TRANSLATORS.include? options[:format]
  $stderr.puts "Format must be one of: #{RDF_TRANSLATORS.join(', ')}"
  exit 1
end

def validate_translator!(value)
  translator = BEL.translator(value)

  unless translator
    $stderr.puts(
      value ?
        %Q{The translator "#{value}" is not available.} :
        "The translator was not specified."
    )
    $stderr.puts
    Trollop::educate
  end
end

# read bel content
input_io =
  if options[:bel]
    File.open(options[:bel], :external_encoding => 'UTF-8')
  else
    $stdin
  end

validate_translator!(:bel)
validate_translator!(options[:format])
begin
  BEL.translate(input_io, :bel, options[:format], $stdout)
ensure
  $stdout.close
end
# vim: ts=2 sw=2:
# encoding: utf-8
