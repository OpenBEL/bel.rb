Gem::Specification.new do |spec|
  spec.name               = 'bel'
  spec.version            = '0.3.0'
  spec.summary            = %q{Process BEL with ruby.}
  spec.description        = %q{The BEL gem allows the reading, writing,
                               and processing of BEL (Biological Expression
                               Language) with a natural DSL.}.
                            gsub(%r{^\s+}, ' ').gsub(%r{\n}, '')
  spec.license            = 'Apache-2.0'
  spec.authors            = ['Anthony Bargnesi']
  spec.date               = %q{2014-01-13}
  spec.email              = %q{abargnesi@selventa.com}
  spec.files              = Dir.glob('lib/**/*.rb') << 'LICENSE'
  spec.executables        = Dir.glob('bin/*').map(&File.method(:basename))
  spec.homepage           = 'https://github.com/OpenBEL/bel.rb'
  spec.require_paths      = ["lib"]

  spec.required_ruby_version \
                          = '>= 1.9.2'

  # runtime
  spec.add_dependency             'ffi',         '~> 1.9'

  # test rdf functionality
  spec.add_development_dependency 'uuid',        '~> 2.3'
  spec.add_development_dependency 'addressable', '~> 2.3'
  spec.add_development_dependency 'rdf',         '~> 1.1'

  # development gems
  spec.add_development_dependency 'bundler',     '~> 1.7'
  spec.add_development_dependency 'rake',        '~> 10.3'
  spec.add_development_dependency 'rspec',       '~> 2.14'
  spec.add_development_dependency 'yard',        '~> 0.8'
  spec.add_development_dependency 'rdoc',        '~> 4.0'
end
# vim: ts=2 sw=2:
# encoding: utf-8
