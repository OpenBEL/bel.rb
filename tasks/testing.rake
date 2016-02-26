require 'rake/testtask'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'yard'
require 'yard-doctest'

# Tests using a classical xunit-style.
TEST_UNIT_TESTS        = FileList['test/unit/**/test_*.rb']
TEST_INTEGRATION_TESTS = FileList['test/integration/**/test_*.rb']

# Tests using a specification style.
SPEC_UNIT_TESTS        = FileList['spec/unit/**/*_spec.rb']
SPEC_INTEGRATION_TESTS = FileList['spec/integration/**/*_spec.rb']

task :unit        => [:spec_unit,        :test_unit       ]
task :integration => [:spec_integration, :test_integration]
task :doctest     => [:"yard:doctest"                     ]

# unit tests
RSpec::Core::RakeTask.new(:spec_unit) do |r|
  r.ruby_opts = '-Ilib/'
  r.rspec_opts = "--format documentation"
  r.pattern = SPEC_UNIT_TESTS
end
Rake::TestTask.new(:test_unit) do |t|
  t.test_files = TEST_UNIT_TESTS
  t.verbose = true
end

# integration tests
RSpec::Core::RakeTask.new(:spec_integration) do |r|
  r.ruby_opts = '-Ilib/'
  r.rspec_opts = "--format documentation"
  r.pattern = SPEC_INTEGRATION_TESTS
end
Rake::TestTask.new(:test_integration) do |t|
  t.test_files = TEST_INTEGRATION_TESTS
  t.verbose = true
end

# yardoc example tests
YARD::Config.options[:autoload_plugins] << 'doctest'
YARD::Config.save
YARD::Doctest::RakeTask.new do |task|
  task.doctest_opts = %w[-v]
  task.pattern = 'lib/**/*.rb'
end
