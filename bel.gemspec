require './lib/bel/version'

Gem::Specification.new do |spec|
  spec.name                     = 'bel'
  spec.version                  = BEL::VERSION
  spec.summary                  = '''
                                    Process BEL with ruby.
                                  '''.gsub(%r{^\s+}, ' ').gsub(%r{\n}, '')
  spec.description              = '''
                                    The BEL gem allows the reading, writing,
                                    and processing of BEL (Biological Expression
                                    Language) with a natural DSL.
                                  '''.gsub(%r{^\s+}, ' ').gsub(%r{\n}, '')
  spec.license                  = 'Apache-2.0'
  spec.authors                  = [
                                    'Anthony Bargnesi',
                                    'Natalie Catlett',
                                    'Nick Bargnesi',
                                    'William Hayes'
                                  ]
  spec.email                    = [
                                    'abargnesi@selventa.com',
                                    'ncatlett@selventa.com',
                                    'nbargnesi@selventa.com',
                                    'whayes@selventa.com'
                                  ]
  spec.files                    = [
                                    Dir.glob("lib/**/*.rb"),
                                    Dir.glob("ext/**/*.{c,h,def}"),
                                    __FILE__,
                                    'LICENSE',
                                    'INSTALL.md',
                                    'INSTALL_RUBY.md',
                                    'README.md'
                                  ].flatten!
  spec.executables              = Dir.glob('bin/*').map(&File.method(:basename))
  spec.homepage                 = 'https://github.com/OpenBEL/bel.rb'
  spec.rdoc_options             = [
                                    '--title', 'BEL Ruby Documentation',
                                    '--main', 'README.md',
                                    '--line-numbers',
                                    '--exclude', 'lib/bel/script.rb',
                                    '--exclude', 'lib/1.9/*',
                                    '--exclude', 'lib/2.0/*',
                                    '--exclude', 'lib/2.1/*',
                                    '--exclude', 'lib/2.2/*',
                                    'README.md',
                                    'INSTALL.md',
                                    'INSTALL_RUBY.md',
                                    'LICENSE'
                                  ]

  spec.extensions              << 'ext/mri/extconf.rb'
  spec.required_ruby_version    = '>= 2.0.0'

  # runtime
  spec.add_dependency             'ffi',           '1.9.8'

  # test rdf functionality
  spec.add_development_dependency 'addressable',   '~> 2.3'
  spec.add_development_dependency 'rdf',           '~> 1.1'
  spec.add_development_dependency 'rdf-turtle',    '~> 1.1'
  spec.add_development_dependency 'uuid',          '~> 2.3'

  # development gems
  spec.add_development_dependency 'minitest',      '~> 5.7'
  spec.add_development_dependency 'rake',          '~> 10.4'
  spec.add_development_dependency 'rake-compiler', '~> 0.9'
  spec.add_development_dependency 'rdoc',          '~> 4.2'
  spec.add_development_dependency 'rspec',         '~> 3.2'
  spec.add_development_dependency 'yard',          '~> 0.8'
end
# vim: ts=2 sw=2:
# encoding: utf-8
