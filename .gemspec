Gem::Specification.new do |spec|
  spec.name                     = 'bel'
  spec.version                  = File.read(File.join(
                                    File.expand_path(File.dirname(__FILE__)),
                                    'VERSION'))
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
                                    Dir.glob('lib/**/*.rb'),
                                    Dir.glob('lib/**/*.yml'),
                                    Dir.glob('ext/**/*.{c,h,def}'),
                                    Dir.glob('lib/bel/libbel/ext/{java,mingw}/**/*.{so,bundle}'),
                                    __FILE__,
                                    'CHANGELOG.md',
                                    'CONTRIBUTING.md',
                                    'INSTALL.md',
                                    'INSTALL_RUBY.md',
                                    'LICENSE',
                                    'README.md',
                                    'VERSION',
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
                                    'CHANGELOG.md',
                                    'CONTRIBUTING.md',
                                    'INSTALL.md',
                                    'INSTALL_RUBY.md',
                                    'LICENSE',
                                    'README.md',
                                  ]

  spec.extensions              << 'ext/mri/extconf.rb'
  spec.required_ruby_version    = '>= 2.0.0'

  spec.add_runtime_dependency 'bel_parser', '~> 1.0.0.alpha'
  spec.add_runtime_dependency 'rdf',        '2.0.1'
  spec.add_runtime_dependency 'rdf-vocab',  '2.0.1'
  spec.add_runtime_dependency 'ffi',        '1.9.8'

  # Example post-install message.
  #
  # These aren't real BEL-related gems, but if we can sneak the names passed
  # abargnesi, maybe one day... ;)
  # spec.post_install_message = %q(
  # -- bel.rb notice --
  # Install any of these additional gems for more functionality:
  # bel-rdf, clapper, carillon, peal, ...
  # )
end
# vim: ts=2 sw=2:
# encoding: utf-8
