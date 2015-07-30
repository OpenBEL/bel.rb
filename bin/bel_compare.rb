#!/usr/bin/env ruby
# vim: ts=2 sw=2

$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'optparse'
require 'bel'
include BEL::Language
include BEL::Namespace

USAGE = "Usage: #{File.basename(__FILE__)} [options] [file] [file]"

options = {}
OptionParser.new do |opts|
  opts.banner = USAGE

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
  opts.on_tail("-h", "--help", "Show usage and options") do
    puts opts
    exit
  end
end.parse!

if ARGV.length != 2
  $stderr.puts "Need to specify two BEL files."
  $stderr.puts USAGE
  exit 1
end

def fetch_groups(bel)
  groups = {}
  active_group = nil
  BEL::Script.parse(bel) do |obj|
    if obj.is_a? BEL::Language::StatementGroup
      active_group = obj
    end
    if obj.is_a? BEL::Language::UnsetStatementGroup
      groups[obj.name] = active_group
    end
  end
  groups
end

threads = []
first_groups = {}
second_groups = {}
threads << Thread.new {
  first_groups.update(fetch_groups(File.open(ARGV[0], :external_encoding => 'UTF-8')))
}

threads << Thread.new {
  second_groups.update(fetch_groups(File.open(ARGV[1], :external_encoding => 'UTF-8')))
}

threads.each { |t| t.join }

group_diff = second_groups.length - first_groups.length
if group_diff == 0
  puts "Equal number of statement groups."
elsif group_diff > 0
  puts "Second file has #{group_diff} more statement groups."
else
  puts "Second file has #{group_diff.abs} less statement groups."
end

first_statements = first_groups.values.
  map {|group| group.statements.map {|s| s.to_bel} }.flatten
puts "First file has #{first_statements.length} statements."
second_statements = second_groups.values.
  map {|group| group.statements.map {|s| s.to_bel}}.flatten
puts "Second file has #{second_statements.length} statements."

# statement groups in 1st, but not 2nd
first_groups.each do |name,first|
  second = second_groups[name]
  if not second
    puts "#{name}, in 1st but not 2nd."
  end
end

# statement groups in 2nd, but not 1st
second_groups.each do |name,second|
  first = first_groups[name]
  if not first
    puts "#{name}, in 2nd but not 1st."
  end
end

# differences between statement group intersection
first_groups.each do |name,first|
  second = second_groups[name]
  if second
    first_stmt = first.statements ? first.statements.map {|s| s.to_bel } : []
    second_stmt = second.statements ? second.statements.map {|s| s.to_bel } : []
    if first_stmt == second_stmt
      if options[:verbose]
        puts "#{name}, both contain zero statements" if first_stmt.empty?
        puts "#{name}, both contain #{first_stmt.length} statements"
      end
    else
      puts "#{name}:"
      if options[:verbose]
        puts "  1st contains #{first_stmt.length} statements"
        puts "  2nd contains #{second_stmt.length} statements"
        puts "  common to both, #{(first_stmt & second_stmt).length}"
        puts (first_stmt & second_stmt).map {|stmt| stmt.to_s}.join("\n    ").prepend("    ")
      end

      ab = first_stmt - second_stmt
      puts "  statements only in 1st, #{ab.length} (1st - 2nd)"
      if ab.length > 0
        puts ab.map {|stmt| stmt.to_s}.join("\n    ").prepend("    ")
      end

      ba = second_stmt - first_stmt
      puts "  statements only in 2nd, #{ba.length} (2nd - 1st)"
      if ba.length > 0
        puts ba.map {|stmt| stmt.to_s}.join("\n    ").prepend("    ")
      end
    end
  end
end

first_terms = first_groups.values.
  map { |group| group.statements }.flatten.
  map { |stmt|
    l = [stmt.subject.to_bel]
    if stmt.simple?
      l << stmt.object.to_bel
    elsif stmt.nested?
      l << stmt.object.subject.to_bel
      l << stmt.object.object.to_bel
    end
    l
  }.flatten.uniq.
  sort {|term1,term2| term1.to_s <=> term2.to_s}
second_terms = second_groups.values.
  map { |group| group.statements }.flatten.
  map { |stmt|
    l = [stmt.subject.to_bel]
    if stmt.simple?
      l << stmt.object.to_bel
    elsif stmt.nested?
      l << stmt.object.subject.to_bel
      l << stmt.object.object.to_bel
    end
    l
  }.flatten.uniq.
  sort {|term1,term2| term1.to_s <=> term2.to_s}

# statements
puts "Statements:"
ab = first_statements - second_statements
puts "  only in 1st, #{ab.length} (1st - 2nd)"
if ab.length > 0
  puts ab.map {|t| t.to_s}.join("\n    ").prepend("    ")
end

ba = second_statements - first_statements
puts "  only in 2nd, #{ba.length} (2nd - 1st)"
if ba.length > 0
  puts ba.map {|t| t.to_s}.join("\n    ").prepend("    ")
end

# terms
puts "Terms:"
ab = first_terms - second_terms
puts "  only in 1st, #{ab.length} (1st - 2nd)"
if ab.length > 0
  puts ab.map {|t| t.to_s}.join("\n    ").prepend("    ")
end

ba = second_terms - first_terms
puts "  only in 2nd, #{ba.length} (2nd - 1st)"
if ba.length > 0
  puts ba.map {|t| t.to_s}.join("\n    ").prepend("    ")
end
