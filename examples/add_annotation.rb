# Example:
#   Illustrates how to add an Annotation definition and values to evidence
#   objects. The evidence results are then serializes out to BEL.
# Usage:
#   ruby examples/add_annotation.rb large_corpus.bel

require 'bel'

# read file from first command argument
bel_file       = File.open(ARGV.first)

# retrieve the formatter for BEL script
bel_formatter  = BEL::Extension::Format.formatters(:bel)

# create new LIST annotation definition
new_annotation = {
  :type   => :list,
  :domain => ['Draft', 'Review', 'Approved', 'Rejected']
}

# read BEL script from file
new_evidence = bel_formatter.deserialize(bel_file).each.lazy.map { |evidence|
  # for each piece of evidence

  # ...add definition and value
  evidence.metadata.annotation_definitions[:Status] = new_annotation
  evidence.experiment_context << {
    :name  => 'Status',
    :value => 'Approved'
  }

  # ...return new evidence
  evidence
}

# serialize new evidence to BEL script and write out
bel_formatter.serialize(new_evidence, $stdout)
