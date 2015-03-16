require 'rake/extensiontask'

CLEAN.include(
  "lib/libbel.so",
  "lib/libbel.bundle",
  "pkg",
  "tmp"
)

if RUBY_PLATFORM =~ /java/
  # support java
else
  Rake::ExtensionTask.new('libbel', GEMSPEC) do |ext|
    ext.ext_dir = 'ext/mri'
    ext.cross_compile = true
    ext.cross_platform = [
      'i386-mingw32',
      'x64-mingw32'
    ]
  end
end

task 'gem:win32' => ['gem:win32-i386', 'gem:win32-x64']

task 'gem:win32-i386' do
  sh("rake cross native:i386-mingw32 gem RUBY_CC_VERSION='1.9.3:2.0.0:2.1.5'") || raise('win32-i386 build failed.')
end

task 'gem:win32-x64' do
  sh("rake cross native:x64-mingw32 gem RUBY_CC_VERSION='1.9.3:2.0.0:2.1.5'") || raise('win32-x64 build failed.')
end
