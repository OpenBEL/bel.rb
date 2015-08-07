# Disable extension building for JRuby.
unless RUBY_PLATFORM =~ /java/
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

  Rake::ExtensionTask.new('libbel', GEMSPEC) do |ext|
    ext.ext_dir = 'ext/mri'
    ext.lib_dir = 'lib/bel/libbel/ext'
    ext.cross_compile = true
    ext.cross_platform = [
      'i386-mingw32',
      'x64-mingw32'
    ]
  end

  task 'gem:win32' => ['gem:win32-i386', 'gem:win32-x64']

  task 'gem:win32-i386' do
    sh("rake cross native:i386-mingw32 gem RUBY_CC_VERSION='2.0.0:2.1.6:2.2.2'") || raise('win32-i386 build failed.')
  end

  task 'gem:win32-x64' do
    sh("rake cross native:x64-mingw32 gem RUBY_CC_VERSION='2.0.0:2.1.6:2.2.2'") || raise('win32-x64 build failed.')
  end
end
