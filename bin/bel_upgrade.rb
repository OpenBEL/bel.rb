#!/usr/bin/env ruby
# bel_upgrade: Upgrade BEL content to a new set of resources.
#
# From BEL file
# usage: bel_upgrade -b file.bel -c file.json
#
# From standard in
# usage: echo "<BEL DOCUMENT STRING>" | bel_upgrade -c file.json

$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib'))
require 'bel'
require 'json'
require 'optparse'
require 'set'
require 'open-uri'

# setup and parse options
options = {
  :change_log => 'http://resource.belframework.org/belframework/latest-release/change_log.json'
}
OptionParser.new do |opts|
  opts.banner = "Usage: bel_upgrade [options] [.bel file]"
  opts.on('-b', '--bel FILE', 'BEL file to upgrade.  STDIN (standard in) can also be used for BEL content.') do |bel|
    options[:bel] = bel
  end
  opts.on("-c", "--changelog [FILE | URI]", "Change log JSON") do |change_log|
    options[:change_log] = change_log
  end
  #opts.on('-k', '--preserve-keywords','preserve anno keywords during upgrade') do |preserve|
  #  options[:preserve] = preserve
  #end
end.parse!

if not File.exists? options[:change_log]
  begin
    open(options[:change_log]) do |f|
      unless f.content_type == 'application/json'
        $stderr.puts "Expected application/json content type, actual: #{f.content_type}"
        exit 1
      end
    end
  rescue OpenURI::HTTPError => e
    $stderr.puts "Cannot read URI for change_log, #{options[:change_log]}, status: #{e}"
    exit 1
  end
end
if options[:bel] and not File.exists? options[:bel]
  $stderr.puts "No file for bel, #{options[:bel]}"
  exit 1
end

# read bel content
content =
if options[:bel]
  File.open(options[:bel], :external_encoding => 'UTF-8')
else
  $stdin
end

# read change log
changelog = nil
if File.exists? options[:change_log]
  File.open(options[:change_log], :external_encoding => 'UTF-8') do |f|
    changelog = JSON.parse(f.read)
  end
else
  open(options[:change_log]) do |file|
    changelog = JSON.parse(file.read)
  end
end

unless changelog
  $stderr.puts "Cannot retrieve change_log #{options[:change_log]}"
end

class Main

  SupportMatcher = Regexp.compile(/SET Support = ([0-9a-zA-Z]+)/)
  LostReplaceValues = ['unresolved', 'withdrawn']
  attr_reader :ttl

  def initialize(content, change_log)
    @change_log = change_log
    @redefine_section = @change_log['redefine']
    if @redefine_section
      if @redefine_section['namespaces'] 
        @redefine_section = @change_log['redefine']['namespaces']
        @redefine_annotations = @change_log['redefine']['annotations']
      end
    end
    if @redefine_annotations # map old_url to new_url
      @annotation_url_map = Hash.new{ |h,k| h[k] = Hash.new()}
      @redefine_annotations.each do |prefix, items|
        old_url = items['old_url']
        new_url = items['new_url']
        @annotation_url_map[old_url]['new_url'] = new_url
        if @annotation_url_map[old_url]['prefix']
          @annotation_url_map[old_url]['prefix'].add(prefix)
        else
          @annotation_url_map[old_url]['prefix'] = Set.new.add(prefix)
        end
      end
    end
    @annotation_keyword_map = Hash.new # Keys - keywords from AnnotationDefinition, values - prefix associated with ann dataset in changelog
    @keywords_seen = Set.new
    BEL::Script.parse(content) do |obj|
      # redefine namespace based on change log's `redefine` blocik
      # use 'namespaces' block, if available
      if obj.is_a? BEL::Namespace::NamespaceDefinition
        if @change_log.has_key? 'redefine'
          redefine = @change_log['redefine']['namespaces']
          if not redefine
            redefine = @change_log['redefine']
          end
          if redefine.has_key? obj.prefix.to_s
            entry = redefine[obj.prefix.to_s]
            new_keyword = entry['new_keyword'].to_sym
            new_url = entry['new_url']
            obj = BEL::Namespace::NamespaceDefinition.new(new_keyword, new_url)
          end
        end

        # deduplicate namespaces for output purposes
        if @keywords_seen.include? obj.prefix
          next
        end
        @keywords_seen.add(obj.prefix)
      end

      # update annotation definitions
      if obj.is_a? BEL::Language::AnnotationDefinition and obj.type.eql? :url
        if @redefine_annotations
          old_url = obj.value
          if @annotation_url_map.has_key? old_url.to_s
            kw = obj.prefix
            new_url = @annotation_url_map[old_url]['new_url']
            prefix = @annotation_url_map[old_url]['prefix']
            obj = BEL::Language::AnnotationDefinition.new(:url, kw, new_url)
            @annotation_keyword_map[kw] = prefix # map bel doc annotation kw to set of changelog prefixes
          end
        end
      end

      # support always needs quoting; backwards-compatibility
      if obj.is_a? BEL::Language::Annotation
        if obj.name == 'Support'
          ev = obj.to_s
          ev.gsub!(SupportMatcher, 'SET Support = "\1"')
          puts ev.to_s
          next
        # look for replacement values for annotations  
        elsif @annotation_keyword_map.has_key? obj.name
          prefixes = @annotation_keyword_map[obj.name]
          # prefixes is a Set, since multiple data sources can be combined in a .belanno (e.g., CLO and EFO)
          prefixes.each do |prefix|
            replacements = @change_log[prefix]
            if replacements
              if obj.value.respond_to?(:map!) # Annotation value is a list
                obj.value.map! do |v|
                  replacement_value = replacements[v.to_s]
                  if replacement_value
                    if LostReplaceValues.include? replacement_value
                      $stderr.puts "no replacement value for #{obj.name} '#{v}' - value '#{replacement_value}'"
                    else
                      $stderr.puts "Annotation #{obj.name}:#{v} replaced by '#{replacement_value}'"
                      v = replacement_value
                    end
                  end
                  v
                end
              else # single Annotation value
                replacement_value = replacements[obj.value.to_s]
                if replacement_value
                  if LostReplaceValues.include? replacement_value
                    $stderr.puts "no replacement value for #{obj.name} '#{obj.value}' - value '#{replacement_value}'"
                  else
                    $stderr.puts " Annotation #{obj.name}:#{obj.value} replaced by '#{replacement_value}'"
                    obj.value = replacement_value
                    next
                  end
                end
              end
            end
          end
        end
      end

      if obj.is_a? BEL::Nanopub::Parameter and obj.ns
        # first try replacing by existing namespace prefix...
        prefix = obj.ns.prefix.to_s
        replacements = @change_log[prefix]
        if replacements
          replacement_value = replacements[obj.value]
          if replacement_value
            if LostReplaceValues.include? replacement_value
              $stderr.puts "no replacement value for #{obj.ns} '#{obj.value}' - value '#{replacement_value}'"
            else
              $stderr.puts " #{obj.ns}:#{obj.value} replaced by '#{replacement_value}'"
              obj.value = replacement_value
            end
          end
        end

        # ...then change namespace if redefined...
        if @redefine_section
          redefinition = @redefine_section[prefix]
          if redefinition
            new_prefix = redefinition['new_keyword']
            new_url = redefinition['new_url']
            obj.ns = BEL::Namespace::NamespaceDefinition.new(new_prefix, new_url)

            # ...and replace value using new namespace prefix
            replacements = @change_log[new_prefix]
            if replacements
              replacement_value = replacements[obj.value]
              if replacement_value
                if LostReplaceValues.include? replacement_value
                  $stderr.puts "no replacement value for #{obj.ns} '#{obj.value}' - value '#{replacement_value}'"
                else
                  obj.value = replacement_value
                end
              end
            end
          end
        end
      end
      # do not print Parameter and Term; they are included in Statement
      if not obj.is_a? BEL::Nanopub::Parameter and not obj.is_a? BEL::Nanopub::Term
        puts obj.to_bel
      end
    end
  end

  private

  def error_file(file_name)
    $stderr.puts "#{file_name} is not readable"
    exit 1
  end
end

Main.new(content, changelog)
# vim: ts=2 sw=2:
# encoding: utf-8
