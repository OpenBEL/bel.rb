Gem::Specification.new do |spec|
  spec.name               = 'bel'
  spec.version            = '0.0.1'
  spec.summary            = %q{Process BEL with ruby.}
  spec.description        = %q{The bel gem allows the reading, writing,
                               and processing of BEL (Biological Expression
                               Language) with a natural DSL.}.
                            gsub(%r{^\s+}, ' ').gsub(%r{\n}, '')
  spec.authors            = ['Anthony Bargnesi']
  spec.date               = %q{2013-07-18}
  spec.email              = %q{abargnesi@selventa.com}
  spec.files              = Dir.glob('lib/**/*.rb')
  spec.homepage           = 'https://github.com/OpenBEL/bel-ruby'
  spec.require_paths      = ["lib"]

  # dependencies
  # antlr3: [1.10.0 - 1.10.1)
  spec.add_runtime_dependency 'antlr3', '~> 1.10.0'
end
