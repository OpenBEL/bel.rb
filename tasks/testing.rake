require 'rspec/core'
require 'rspec/core/rake_task'

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
