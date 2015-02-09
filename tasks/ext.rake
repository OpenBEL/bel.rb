require 'rake/extensiontask'

Rake::ExtensionTask.new('bel_c') do |ext|
  ext.lib_dir = 'lib/bel'
end
