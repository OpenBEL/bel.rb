# Example:
#   Illustrates how to add an Annotation definition and values to evidence
#   objects. Evidence is read from BEL script (e.g. bel formatter) and written
#   as JSON evidence (e.g. json formatter).
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
new_evidence = bel_formatter.deserialize(bel_file).each.lazy.map { |evidence|
  # for each piece of evidence

  # ...add definition and value
  evidence.references.annotations[:Status] = new_annotation
  evidence.metadata[:Status] = 'Approved'

  # ...return new evidence
  evidence
}

# serialize new evidence to BEL script and write out
json_formatter.serialize(new_evidence, $stdout)
