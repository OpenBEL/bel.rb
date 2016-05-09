require 'bel'

describe BEL::Nanopub::Parameter, "#valid?" do
  include BEL::Language
  include BEL::Namespace
  include BEL::Nanopub

  it """false when parameter value is nil""" do
    expect(
      Parameter.new(HGNC, nil).valid?
    ).to be_falsey
    expect(
      Parameter.new(nil, nil).valid?
    ).to be_falsey
  end

  it """false when parameter value is not in namespace""" do
    expect(
      Parameter.new(HGNC, :not_in_namespace).valid?
    ).to be_falsey
  end

  it """
    false when namespace does not contain values
    (e.g. parameter namespace is not a data-backed NamespaceDefinition)
  """ do
    expect(
      Parameter.new("HGNC", :AKT1).valid?
    ).to be_falsey
  end

  it """
    true when parameter value is set without a namespace
    (e.g. some_value MAY exist because namespace constraint not provided)
  """ do
    expect(
      Parameter.new(nil, :some_value).valid?
    ).to be_truthy
  end

  it "true when the parameter value is in namespace" do
    expect(
      Parameter.new(HGNC, :AKT1).valid?
    ).to be_truthy
  end

end
# vim: ts=2 sw=2:
