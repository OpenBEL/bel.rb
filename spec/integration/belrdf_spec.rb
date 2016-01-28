require 'bel'

describe 'Reading RDF from BEL' do

  it "successfully translates BEL with unicode characters" do
    bel_file = File.open(
      File.join(
        File.expand_path('..', __FILE__), 'bel', 'bel_unicode.bel'
      )
    )

    writer = StringIO.new
    BEL.translate(bel_file, :bel, :ntriples, writer)

    rdf_triples = writer.string
    expect(rdf_triples.each_line.count).to eql(372)
  end
end

# vim: ts=2 sw=2
# encoding: utf-8
