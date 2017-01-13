# Example:
#   Detects bad namespace prefixes and tries to correct them.
# Usage:
#   ruby examples/fix_bad_namespaces.rb

require 'bel'

# Helpers
# -------

# Returns all {BEL::Nanopub::Parameter} arguments referenced within the
# {BEL::Nanopub::Term term}.
def parameters(term, parameters = [])
  term.arguments.reduce(parameters) { |res, arg|
    if arg.respond_to? :arguments
      parameters(arg, parameters)
    else
      parameters << arg
    end
    parameters
  }
end

# Returns +true+ if the {BEL::Nanopub::Parameter parameter} has an invalid
# namespace, +false+ if it is valid.
def invalid_namespace(parameter)
  return false unless parameter.ns
  ! NAMESPACE_LATEST.include? parameter.ns.prefix.to_sym
end

# Update the namespace of {BEL::Nanopub::Parameter parameter} if one can be
# determined by prefix and inclusion of parameter value.
def fix_namespace(parameter)
  return parameter unless parameter.ns and invalid_namespace(parameter)

  ns      = parameter.ns.prefix
  NAMESPACE_LATEST.
    select { |prefix, _|
      prefix.to_s =~ %r{.*#{ns}.*}
    }.
    select { |prefix, (belns_url, rdf_uri)|
      ns = NamespaceDefinition.new(prefix, belns_url, rdf_uri)
      ns[parameter.value]
    }.
    each { |prefix, (belns_url, rdf_uri)|
      parameter.ns = NamespaceDefinition.new(prefix, belns_url, rdf_uri)
    }
end
# -------


# Main flow
# ---------

# Parse and find all terms.
terms = BEL::Script.parse(DATA).
  select { |obj| obj.respond_to? :arguments }.
  to_a

# Flatten and map to BEL parameters, select the invalid ones, and try to
# fix them.
terms.
  flat_map(&self.method(:parameters)).
  select(&self.method(:invalid_namespace)).
  each(&self.method(:fix_namespace))

# Write out all terms.
puts terms.to_a
# ---------

__END__
# BEL content read in at line 50. Using Ruby's DATA file section.
p(EGID:207) -> bp(GOBP:"apoptotic process")
p(HGN:AKT1) -> bp(MESH:Apoptosis)
