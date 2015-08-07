if RUBY_PLATFORM =~ /java/i

  # Don't do anything when run in JRuby; this allows gem installation to pass.
  # We need to write a dummy Makefile so that RubyGems doesn't think compilation
  # failed.
  File.open('Makefile', 'w') do |f|
    f.puts "all:"
    f.puts "\t@true"
    f.puts "install:"
    f.puts "\t@true"
  end
  exit 0
else

  require 'mkmf'
  # if set in environment, set compiler for make
  # example:
  #   CC=gcc-4.8 gem install bel.rb
  RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

  create_makefile('bel/libbel/ext/libbel')
end
