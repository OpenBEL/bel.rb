#!/usr/bin/env ruby
# vim: ts=2 sw=2

$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib'))
require 'bel'
require 'csv'
require 'optparse'
include BEL::Language
include BEL::Namespace

options = {}
OptionParser.new do |opts|
  opts.banner = '''Statistic report for BEL script.
Usage: bel_summarize --bel [FILE]'''

  opts.on('-b', '--bel FILE', 'BEL file to summarize.  STDIN (standard in) can also be used for BEL content.') do |bel|
    options[:bel] = bel
  end
end.parse!

# read bel content
content =
  if options[:bel]
    File.open(options[:bel], :external_encoding => 'UTF-8')
  else
    $stdin
  end

CSV do |csv_out|
  report = {
    statement_group_count: 0,
    empty_statement_groups: 0,
    statement_count: 0,
    support_count: 0
  }

  FUNCTIONS.each do |k, v|
    report['fx_' + v[:long_form].to_s] = 0
  end

  RELATIONSHIPS.values.each do |r|
    report['rel_' + r.to_s] = 0
  end

  active_group = nil
  BEL::Script.parse(content) do |obj|
    if obj.is_a? BEL::Language::StatementGroup
      report[:statement_group_count] += 1
      active_group = obj
    end
    if obj.is_a? BEL::Language::UnsetStatementGroup
      if active_group.statements.empty?
        report[:empty_statement_groups] += 1
      end
    end
    if obj.is_a? BEL::Nanopub::Term
      fx = obj.fx
      fx = fx.respond_to?(:long_form) ?
             fx.long_form.to_s :
             fx.to_s
      fx = FUNCTIONS[fx.to_sym][:long_form]
      report["fx_#{fx}"] += 1
    end
    if obj.is_a? BEL::Nanopub::Statement
      report[:statement_count] += 1
      obj.relationship = case obj.relationship
      when :"->"
        :increases
      when :"-|"
        :decreases
      when :"=>"
        :directlyIncreases
      when :"=|"
        :directlyDecreases
      when :"--"
        :association
      else
        obj.relationship
      end

      if obj.relationship
        report['rel_' + obj.relationship.to_s] += 1
      end
    end
    if obj.is_a? BEL::Language::Annotation
      report[:support_count] += 1 if obj.name == 'Support'
    end
  end

  csv_out << report.keys
  csv_out << report.values
end
