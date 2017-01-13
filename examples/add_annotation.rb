# Example:
#   Illustrates how to add an Annotation definition and values to nanopub
#   objects. Nanopubs are read from BEL script (e.g. bel formatter) and written
#   as BNJ (i.e. BEL Nanopub JSON).
# Usage:
#   ruby examples/add_annotation.rb large_corpus.bel

require 'bel'

# read file from first command argument
bel_file       = File.open(ARGV.first)

# retrieve the formatter for BEL script
bel_formatter   = BEL::Extension::Format.formatters(:bel)
json_formatter  = BEL::Extension::Format.formatters(:json)

# create new LIST annotation definition
new_annotation = {
  :type   => :list,
  :domain => ['Draft', 'Review', 'Approved', 'Rejected']
}

# read BEL script from file
new_nanopub = bel_formatter.deserialize(bel_file).each.lazy.map { |nanopub|
  # for each nanopub

  # ...add definition and value
  nanopub.references.annotations[:Status] = new_annotation
  nanopub.metadata[:Status] = 'Approved'

  # ...return new nanopub
  nanopub
}

# serialize new nanopub to BEL script and write out
json_formatter.serialize(new_nanopub, $stdout)
