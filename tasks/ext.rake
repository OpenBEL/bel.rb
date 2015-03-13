require 'rake/extensiontask'

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
