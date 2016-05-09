require 'bel'

include BEL::Language
include BEL::Nanopub

describe 'Reading BEL' do

  it "successfully parses with interleaved spaces" do
    bel_file = File.open(
      File.join(
        File.expand_path('..', __FILE__), 'bel', 'bel_with_spacing.bel'
      )
    )

    # Expect there to be two statement groups totalling 7 statements.
    objects = BEL::Script.parse(bel_file).group_by { |obj|
      obj.class
    }
    expect(objects[UnsetStatementGroup].length).to eql(2)
    expect(objects[Statement].length).to eql(7)
  end
end

# vim: ts=2 sw=2
# encoding: utf-8
