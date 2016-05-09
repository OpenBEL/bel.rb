#!/usr/bin/env ruby
# filter_bel.rb: Filter BEL statements that match all restrictions (e.g. composed with AND)
#
# Filter statements containing pmod function
# usage: filter_bel -b file.bel --function pmod
#
# Filter statements containing p(HGNC:AKT1) term and pmod
# usage: filter_bel -b file.bel --term "p(HGNC:AKT1)" --function pmod
require 'bel'
require 'json'
require 'optparse'
require 'set'
require 'open-uri'

include BEL::Language
include BEL::Namespace
include BEL::Quoting

# setup and parse options
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: filter_by_function [options] [.bel file]"
  opts.on('-b', '--bel FILE', 'BEL file to filter.  STDIN (standard in) can also be used for BEL content.') do |bel|
    options[:bel] = bel
  end
  opts.on("-f", "--function TYPE", "Function type to filter for") do |function|
    (options[:functions] ||= []) << function
  end
end.parse!

# option guards
unless options[:bel] or not STDIN.tty?
  $stderr.puts "No bel content provided.  Either use --bel option or STDIN (standard in).  Use -h / --help for details." 
  exit 1
end
unless options[:functions]
  $stderr.puts "Missing --function option. Use -h / --help for details."
  exit 1
end
if options[:bel] and not File.exists? options[:bel]
  $stderr.puts "No file for bel, #{options[:bel]}"
  exit 1
end

# read bel content
content =
if options[:bel]
  File.open(options[:bel]).read
else
  $stdin.read
end

class Main

  attr_reader :ttl

  def initialize(content, options = {})
    @functions = options.fetch(:functions, []).map { |fx|
      Function.new(FUNCTIONS[fx.to_sym])
    }
    @keywords_seen = Set.new
    @active_group = nil
    @document_number = 0
    @header = []
    BEL::Script.parse(content) do |obj|
      if [DocumentProperty, AnnotationDefinition, NamespaceDefinition].include?(obj.class)
        @header << obj.to_bel
      end

      if obj.is_a? UnsetStatementGroup
        matches = @active_group.statements.find_all { |statement|
          functions_for(:statement => statement).any? { |fx|
            @functions.include? fx
          }
        }

        matches.each do |statement|
          File.open("documents/#{@document_number}.bel", "w:UTF-8") do |f|
            @header.each do |line|
              if line.start_with? "SET DOCUMENT Name"
                f.puts %Q{SET DOCUMENT Name = "Statement #{@document_number}"}
              else
                f.puts line
              end
            end

            annotations = @active_group.annotations.merge(statement.annotations)
            annotations.each do |k, v|
              if v.name == 'Support'
                # always quote Support; openbel-framework parse issue
                cleaned = v.value.gsub(/"/, '\\"')
                f.puts %Q{SET Support = "#{cleaned}"}
              else
                f.puts v
              end
            end

            f.puts statement.to_bel
          end
          @document_number += 1
        end
      end

      if obj.is_a? StatementGroup
        @active_group = obj
      end
    end
  end

  private

  def functions_for(options = {})
    functions = []
    if options[:statement]
      obj = options[:statement]
      functions += functions_for(:term => obj.subject)
      if obj.object
        if obj.object.is_a? Term
          functions += functions_for(:term => obj.object)
        else
          nested = obj.object
          functions += functions_for(:term => nested.subject)
          functions += functions_for(:term => nested.object)
        end
      end
    elsif options[:term]
      obj = options[:term]
      functions << obj.fx
      functions += obj.arguments.find_all { |arg|
        arg.is_a? Term
      }.map { |term|
        functions_for(:term => term)
      }.flatten
    end

    functions
  end

  def error_file(file_name)
    $stderr.puts "#{file_name} is not readable"
    exit 1
  end
end

Main.new(content, :functions => options[:functions])
# vim: ts=2 sw=2:
# encoding: utf-8
