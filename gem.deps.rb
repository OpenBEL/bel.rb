# See the following for reference:
# - http://docs.ruby-lang.org/en/2.2.0/Gem/RequestSet/GemDependencyAPI.html
# - http://docs.ruby-lang.org/en/2.2.0/Gem/RequestSet/GemDependencyAPI.html#method-i-group
# - http://docs.ruby-lang.org/en/2.2.0/Gem/RequestSet/GemDependencyAPI.html#method-i-platform
# - http://docs.ruby-lang.org/en/2.2.0/Gem.html#method-c-use_gemdeps
source 'https://rubygems.org'

# Gems used in development.
gem 'minitest', '~> 5.7'
gem 'rake', '~> 10.4'
gem 'rake-compiler', '~> 0.9'
gem 'rdoc', '~> 4.2'
gem 'rspec', '~> 3.2'
gem 'yard', '~> 0.8'
gem 'pry', '~> 0.10'
gem 'pry-byebug', '~> 3.2'
gem 'rubocop', '~> 0.34'
gem 'rantly', '~> 0.3'

# For testing RDF functionality.
gem 'addressable', '~> 2.3'
gem 'rdf', '~> 1.1'
gem 'rdf-turtle', '~> 1.1'
gem 'uuid', '~> 2.3'

# Platform-specific example.
# platform(:jruby) {
#     gem 'json-jruby', '~> 1.5'
# }
