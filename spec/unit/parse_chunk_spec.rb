require 'bel'
require 'rantly'
require 'rantly/rspec_extensions'

# Tests property that parsing BEL Script records, with varying IO chunk sizes,
# are equivalent to parsing data fully read/buffered:
#
# @sanea observed the loss of namespace prefix occurred between parsed chunks.
# This was happening because the namespace prefix was a local variable which
# was reinitialized on the next IO chunk. Changing "pfx" to an instance
# variable fixed this behavior. This property test checks this behavior holds.
#
# @see https://github.com/OpenBEL/bel.rb/issues/71
describe BEL::Script, "#parse" do

  context 'when parsing IO with variable chunk size' do

    it 'BEL statement parsing is consistent for all chunk sizes' do
      # Parse buffered string for comparison.
      bel_statement    = 'path(SDIS:"tissue damage") -> bp(GOBP:"cell proliferation")'
      buffered_results = BEL::Script.parse(bel_statement).each.to_a

      # Check that parsed IO is equal to buffered result for varying
      # chunk sizes.
      property_of {
        range(1, bel_statement.size)
      }.check(1000) { |chunk_size|
        io         = StringIO.new(bel_statement)
        io_results = BEL::Script.parse_chunked(io, {}, chunk_size).each.to_a
        expect(io_results).to eql(buffered_results)
      }
    end
  end
end
# vim: ts=2 sw=2:
