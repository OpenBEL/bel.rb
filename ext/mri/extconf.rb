require 'mkmf'

# if set in environment, set compiler for make
# example:
#   CC=gcc-4.8 gem install bel.rb
RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

create_makefile('libbel')
