# vim: ts=2 sw=2:
require 'bel'

describe BEL::Script, "#parse" do

  it "interprets CRLF by itself" do
    new_lines = BEL::Script.
      parse("\r\n" * 3).
      select { |obj| obj.is_a? Newline }.
      to_a

    expect(new_lines.length).to eql(3)
  end

  it "interprets LF by itself" do
    new_lines = BEL::Script.
      parse("\n" * 3).
      select { |obj| obj.is_a? Newline }.
      to_a

    expect(new_lines.length).to eql(3)
  end

  it "interprets CRLF before records" do
    new_lines = BEL::Script.
      parse(("\r\n" * 3) + "# Comment\r\n").
      select { |obj| obj.is_a? Newline }.
      to_a

    expect(new_lines.length).to eql(3)
  end

  it "interprets LF before records" do
    new_lines = BEL::Script.
      parse(("\n" * 3) + "# Comment\n").
      select { |obj| obj.is_a? Newline }.
      to_a

    expect(new_lines.length).to eql(3)
  end

  it "interprets CRLF between records" do
    new_lines = BEL::Script.
      parse("p(HGNC:AKT1)\r\n" + ("\r\n" * 3) + "p(HGNC:AKT2)").
      select { |obj| obj.is_a? Newline }.
      to_a

    expect(new_lines.length).to eql(3)
  end

  it "interprets LF between records" do
    new_lines = BEL::Script.
      parse("p(HGNC:AKT1)\n" + ("\n" * 3) + "p(HGNC:AKT2)").
      select { |obj| obj.is_a? Newline }.
      to_a

    expect(new_lines.length).to eql(3)
  end

  it "interprets CRLF after a record" do
    new_lines = BEL::Script.
      parse("p(HGNC:AKT1)\r\n" + ("\r\n" * 3)).
      select { |obj| obj.is_a? Newline }.
      to_a

    expect(new_lines.length).to eql(3)
  end

  it "interprets LF after a record" do
    new_lines = BEL::Script.
      parse("p(HGNC:AKT1)\n" + ("\n" * 3)).
      select { |obj| obj.is_a? Newline }.
      to_a

    expect(new_lines.length).to eql(3)
  end

  it "interprets CRLF accurately from BEL file" do
    bel_crlf = File.open(
      File.join(
        File.expand_path('..', __FILE__),
        'bel',
        'full_abstract1_crlf.bel'
      )
    )
    
    new_lines = BEL::Script.
      parse(bel_crlf).
      select { |obj| obj.is_a? Newline }.
      to_a

    expect(new_lines.length).to eql(9)
  end

  it "interprets LF accurately from BEL file" do
    bel_lf = File.open(
      File.join(
        File.expand_path('..', __FILE__),
        'bel',
        'full_abstract1_lf.bel'
      )
    )
    
    new_lines = BEL::Script.
      parse(bel_lf).
      select { |obj| obj.is_a? Newline }.
      to_a

    expect(new_lines.length).to eql(9)
  end
end
