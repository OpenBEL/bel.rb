# Guardfile: Configuration for guard.
#   More info at https://github.com/guard/guard#readme

GUARD_CTAG_OPTIONS = {
  :src_path => ".",
  :emacs => false,
  :stdlib => true,
  :binary => 'ripper-tags',
  :arguments => '-R --exclude lib/bel/script.rb',
}
guard 'ctags-bundler', GUARD_CTAG_OPTIONS do
  watch(/^(bin|examples|lib|spec)\/.*\.rb$/)
  watch('Gemfile.lock')
end

guard 'rake', :task => 'unit' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})
end
