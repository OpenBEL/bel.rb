#!/usr/bin/env ruby
# bel_validate: Show parsed objects from XBEL file or stdin content for debugging purposes.
#
# From file
# usage: bel_validate -f file.xbel
#
# From standard in
# usage: echo "<BEL DOCUMENT STRING>" | bel_validate

$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib'))
require 'bel'
require 'optparse'

# additive String helpers
class String
  def rjust_relative(distance, string)
    rjust(distance - string.size + size)
  end
end

# setup and parse options
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: bel_validate [options] [.xbel file]"
  opts.on('-x', '--xbel FILE', 'XBEL file to parse.  STDIN (standard in) can also be used for XBEL content.') do |xbel|
    options[:xbel] = xbel
  end
end.parse!

if options[:xbel] and not File.exists? options[:xbel]
  $stderr.puts "No file for xbel, #{options[:xbel]}"
  exit 1
end

# read xbel content
content =
if options[:xbel]
  File.open(options[:xbel], :external_encoding => 'UTF-8')
else
  $stdin
end

#namespaces = ... # bel2_validate

class Main

  def initialize(content)
    BEL.nanopub(content, :xbel).each do |obj|
      spec = BELParser::Language.specification obj.metadata.bel_version
      namespaces = obj.references.namespaces.each.map do |ns|
      end
      stmt_str = obj.bel_statement.to_s
      namespaces = {}
      BELParser::Expression::Validator
        .new(spec, namespaces, BELParser::Resource.default_uri_reader, BELParser::Resource.default_url_reader)
        .each(StringIO.new stmt_str) do |(line_number, line, ast, results)|
        puts "#{line_number}: #{line}"
        puts "  AST Type: #{ast.type}"
      
        puts "  Syntax results:"
        
        results.syntax_results.each do |res|
          puts "    #{res}"
        end

        puts "  Semantics results:" 
        results.semantics_results.each do |res|
          if res.is_a?(BELParser::Language::Semantics::SignatureMappingSuccess)
            puts "    Matched signature: #{res.signature.string_form}"
          end
          if res.is_a?(BELParser::Language::Semantics::SignatureMappingWarning)
            puts "    Failed signature: #{res.signature.string_form}"
            res.results.select(&:failure?).each do |warning|
              puts "      #{warning}"
            end
          end
        end 
      end        
    end
  end

  end
Main.new(content)
# vim: ts=2 sw=2:
# encoding: utf-8
