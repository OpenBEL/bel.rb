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

RDF_TRANSLATORS = %w(jsonld ntriples nquads rdfa rdfxml rj trig trix turtle)

# setup and parse options
options = {
  format: 'ntriples',
  schema: true
}
OptionParser.new do |opts|
  opts.banner = <<-USAGE
    Converts BEL nanopubs to RDF...

    From a BEL file.
    Usage: bel2rdf --bel [FILE]

    From BEL data on standard input (i.e. stdin).
    Usage: cat  | bel2rdf

  USAGE

  opts.on('-b', '--bel FILE', 'BEL file to convert.  Standard input (i.e. stdin) can also be used for BEL input.') do |bel|
    options[:bel] = bel
  end

  opts.on('-f', '--format FORMAT', 'RDF file format. The default output format is N-Triples.') do |format|
    options[:format] = format.downcase
  end


  opts.on('-p', '--rdf-prefix-file FILE', "A YAML file mapping prefix containing key/value pairs. The key is an RDF prefix to use in the RDF output; the value is the RDF URI for that prefix. For example, belv: 'http://www.openbel.org/vocabulary/'.") do |prefix_file|
    options[:rdf_prefix_file] = prefix_file
  end

  opts.on('-s', '--[no-]schema', 'Write BEL RDF schema? The default is to include the schema in the output.') do |schema|
    options[:schema] = schema
  end

  opts.on('-r', '--remap-file FILE', 'A YAML file that remaps annotation and namespace definitions. Run "bel remapfile" to get an example of the YAML format.') do |remap_file|
    options[:remap_file] = remap_file
  end
end.parse!

if options[:bel] and not File.exists? options[:bel]
  $stderr.puts "No file for bel, #{options[:bel]}"
  exit 1
end

if options[:rdf_prefix_file] and not File.exists? options[:rdf_prefix_file]
  $stderr.puts "No file for rdf_prefix_file, #{options[:rdf_prefix_file]}"
  exit 1
end

if options[:remap_file] and not File.exist? options[:remap_file]
  $stderr.puts "No file for remap_file, #{options[:remap_file]}"
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
    File.open(options[:bel], external_encoding: 'UTF-8')
  else
    $stdin
  end

validate_translator!(:bel)
validate_translator!(options[:format])
begin
  BEL.translate(input_io, :bel, options[:format], $stdout,
    {
      write_schema:    options[:schema],
      rdf_prefix_file: options[:rdf_prefix_file],
      remap_file:      options[:remap_file]
    }
  )
ensure
  $stdout.close
end
# vim: ts=2 sw=2:
# encoding: utf-8
