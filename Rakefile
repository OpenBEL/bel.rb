require 'rubygems'
GEMSPEC = Gem::Specification.load("bel.gemspec")

require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'rake/clean'

FileList['tasks/**/*.rake'].each { |task| import task }
task :default => [:compile, :unit, :integration]
# vim: ts=2 sw=2:
# encoding: utf-8
