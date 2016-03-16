require 'rubygems'
GEMSPEC = Gem::Specification.load("bel.gemspec")

require 'rake'
require 'rake/clean'

FileList['tasks/**/*.rake'].each { |task| import task }

if RUBY_PLATFORM =~ /java/
  # JRuby will not compile libbel. Native extensions are not supported.
  task :default => [:unit, :integration, :doctest]
else
  task :default => [:compile, :unit, :integration, :doctest]
end
# vim: ts=2 sw=2:
# encoding: utf-8
