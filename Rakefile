require 'rubygems'
require 'bundler'

GEMSPEC = Gem::Specification.load("bel.gemspec")

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'rake/clean'
require 'rspec/core'
require 'rspec/core/rake_task'

CLEAN.include(
  "tmp",
  "lib/libbel.so"
)

CLOBBER.include(
  "doc",
  "pkg"
)

UNIT = FileList['spec/unit/**/*_spec.rb']
INTEGRATION = FileList['spec/integration/**/*_spec.rb']

# unit tests
RSpec::Core::RakeTask.new(:unit) do |r|
  r.ruby_opts = '-Ilib/'
  r.rspec_opts = "--format documentation"
  r.pattern = (not UNIT.empty? and UNIT) or fail "No unit tests"
end

# integration tests
RSpec::Core::RakeTask.new(:integration) do |r|
  r.ruby_opts = '-Ilib/'
  r.rspec_opts = "--format documentation"
  r.pattern = (not INTEGRATION.empty? and INTEGRATION) or fail "No integration tests"
end

task :default => :unit

require 'yard'
YARD::Rake::YardocTask.new

FileList['tasks/**/*.rake'].each { |task| import task }
# vim: ts=2 sw=2:
# encoding: utf-8
