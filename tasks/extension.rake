require 'rake/extensiontask'

CLEAN.include(
  "lib/libbel.so",
  "lib/libbel.bundle",
  "lib/2.0",
  "lib/2.1",
  "lib/2.2",
  "pkg",
  "tmp"
)

if RUBY_PLATFORM =~ /java/
  # TODO support java

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
  Rake::ExtensionTask.new('libbel', GEMSPEC) do |ext|
    ext.ext_dir = 'ext/mri'
    ext.lib_dir = 'lib/bel'
    ext.cross_compile = true
    ext.cross_platform = [
      'i386-mingw32',
      'x64-mingw32'
    ]
  end
end

task 'gem:win32' => ['gem:win32-i386', 'gem:win32-x64']

task 'gem:win32-i386' do
  sh("rake cross native:i386-mingw32 gem RUBY_CC_VERSION='2.0.0:2.1.6:2.2.2'") || raise('win32-i386 build failed.')
end

task 'gem:win32-x64' do
  sh("rake cross native:x64-mingw32 gem RUBY_CC_VERSION='2.0.0:2.1.6:2.2.2'") || raise('win32-x64 build failed.')
end
