require 'bel'

include BEL::Completion

describe BEL::Completion, '#complete' do
  context "when completing ''" do
    subject(:text) { '' }
    it "returns one result" do
      expect(BEL::Completion.complete(text).length).to be 1
    end
    it "returns an option" do
      expect(BEL::Completion.complete(text).first).to be_a(Option)
    end
    it "option position is 0" do
      expect(BEL::Completion.complete(text).first.position).to be 0
    end
    it "option value is ''" do
      expect(BEL::Completion.complete(text).first.value).to eql ''
    end
    it "option value type is :function" do
      expect(BEL::Completion.complete(text).first.value_type).to be :function
    end
    it "option has all functions as options" do
      expect(BEL::Completion.complete(text).first.options).to eql SORTED_FUNCTIONS
    end
  end

  context "when completing 'abund'" do
    subject(:text) { 'abund' }
    it "returns one result" do
      expect(BEL::Completion.complete(text).length).to be 1
    end
    it "returns an option" do
      expect(BEL::Completion.complete(text).first).to be_a(Option)
    end
    it "option position is 0" do
      expect(BEL::Completion.complete(text).first.position).to be 0
    end
    it "option value is 'abund'" do
      expect(BEL::Completion.complete(text).first.value).to eql 'abund'
    end
    it "option value type is :function" do
      expect(BEL::Completion.complete(text).first.value_type).to be :function
    end
    it "option has abundance functions as options" do
      expect(BEL::Completion.complete(text).first.options).to eql [
        'abundance', 'complexAbundance', 'compositeAbundance', 'geneAbundance',
        'microRNAAbundance', 'proteinAbundance', 'rnaAbundance'
      ]
    end
  end

  context "when completing 'comple'" do
    subject(:text) { 'comple' }
    it "returns one result" do
      expect(BEL::Completion.complete(text).length).to be 1
    end
    it "returns an option" do
      expect(BEL::Completion.complete(text).first).to be_a(Option)
    end
    it "option position is 0" do
      expect(BEL::Completion.complete(text).first.position).to be 0
    end
    it "option value is 'comple'" do
      expect(BEL::Completion.complete(text).first.value).to eql 'comple'
    end
    it "option value type is :function" do
      expect(BEL::Completion.complete(text).first.value_type).to be :function
    end
    it "option has complex functions as options" do
      expect(BEL::Completion.complete(text).first.options).to eql [
        'complex', 'complexAbundance'
      ]
    end
  end

  context "when completing 'activity'" do
    subject(:text) { 'activity' }
    it "returns one result" do
      expect(BEL::Completion.complete(text).length).to be 1
    end
    it "returns an option" do
      expect(BEL::Completion.complete(text).first).to be_a(Option)
    end
    it "option position is 0" do
      expect(BEL::Completion.complete(text).first.position).to be 0
    end
    it "option value is 'activity'" do
      expect(BEL::Completion.complete(text).first.value).to eql 'activity'
    end
    it "option value type is :function" do
      expect(BEL::Completion.complete(text).first.value_type).to be :function
    end
    it "option has all activity functions as options" do
      expect(BEL::Completion.complete(text).first.options).to eql [
        'catalyticActivity', 'chaperoneActivity', 'gtpBoundActivity',
        'kinaseActivity', 'molecularActivity', 'peptidaseActivity',
        'phosphataseActivity', 'ribosylationActivity',
        'transcriptionalActivity', 'transportActivity'
      ]
    end
  end

  context "when completing 'complex'" do
    subject(:text) { 'complex' }
    it "returns two results" do
      expect(BEL::Completion.complete(text).length).to be 2
    end
    it "the first result is a match" do
      expect(BEL::Completion.complete(text).first).to be_a(Match)
    end
    it "match position is 0" do
      expect(BEL::Completion.complete(text).first.position).to be 0
    end
    it "match value is 'complex'" do
      expect(BEL::Completion.complete(text).first.value).to eql 'complex'
    end
    it "match value type is :function" do
      expect(BEL::Completion.complete(text).first.value_type).to be :function
    end
    it "the second result is an insert" do
      expect(BEL::Completion.complete(text)[1]).to be_a(Insert)
    end
    it "insert position is at end of text" do
      expect(BEL::Completion.complete(text)[1].position).to be text.length
    end
    it "insert value_type is :o_paren" do
      expect(BEL::Completion.complete(text)[1].value_type).to be :o_paren
    end
    it "single value for insert" do
      expect(BEL::Completion.complete(text)[1].values.length).to be 1
    end
    it "insert value to be '('" do
      expect(BEL::Completion.complete(text)[1].values.first).to eql '('
    end
  end

  context "when completing 'bp'" do
    subject(:text) { 'bp' }
    it "returns two results" do
      expect(BEL::Completion.complete(text).length).to be 2
    end
    it "returns a match" do
      expect(BEL::Completion.complete(text).first).to be_a(Match)
    end
    it "match position is 0" do
      expect(BEL::Completion.complete(text).first.position).to be 0
    end
    it "match value is 'bp'" do
      expect(BEL::Completion.complete(text).first.value).to eql 'bp'
    end
    it "match value type is :function" do
      expect(BEL::Completion.complete(text).first.value_type).to be :function
    end
    it "the second result is an insert" do
      expect(BEL::Completion.complete(text)[1]).to be_a(Insert)
    end
    it "insert position is at end of text" do
      expect(BEL::Completion.complete(text)[1].position).to be text.length
    end
    it "insert value_type is :o_paren" do
      expect(BEL::Completion.complete(text)[1].value_type).to be :o_paren
    end
    it "single value for insert" do
      expect(BEL::Completion.complete(text)[1].values.length).to be 1
    end
    it "insert value to be '('" do
      expect(BEL::Completion.complete(text)[1].values.first).to eql '('
    end
  end

  context "when completing 'p('" do
    subject(:text) { 'p(' }
    it "returns two results" do
      expect(BEL::Completion.complete(text).length).to be 2
    end
    it "returns an option" do
      expect(BEL::Completion.complete(text).first).to be_a(Option)
    end
    it "option position is at end of text" do
      expect(BEL::Completion.complete(text).first.position).to be text.length
    end
    it "option value is '('" do
      expect(BEL::Completion.complete(text).first.value).to eql '('
    end
    it "option value type is :namespace_prefix" do
      expect(BEL::Completion.complete(text).first.value_type).to be :namespace_prefix
    end
    it "option has all namespace prefixes as values" do
      expect(BEL::Completion.complete(text).first.options).to eql SORTED_NAMESPACES
    end
    it "the second result is an option" do
      expect(BEL::Completion.complete(text)[1]).to be_a(Option)
    end
    it "option position is at end of match" do
      expect(BEL::Completion.complete(text)[1].position).to be text.length
    end
    it "option value is '('" do
      expect(BEL::Completion.complete(text)[1].value).to eql '('
    end
    it "option value_type is :o_paren" do
      expect(BEL::Completion.complete(text)[1].value_type).to be :function
    end
    it "option has all functions as values" do
      expect(BEL::Completion.complete(text)[1].options).to eql SORTED_FUNCTIONS
    end
  end

  context "when completing 'p(HG'" do
    subject(:text) { 'p(HG' }
    it "returns two results" do
      expect(BEL::Completion.complete(text).length).to be 2
    end
    it "returns an option" do
      expect(BEL::Completion.complete(text).first).to be_a(Option)
    end
    it "option position is at start of last token" do
      expect(BEL::Completion.complete(text).first.position).to be text.index('HG')
    end
    it "option value is 'HG'" do
      expect(BEL::Completion.complete(text).first.value).to eql 'HG'
    end
    it "option value type is :namespace_prefix" do
      expect(BEL::Completion.complete(text).first.value_type).to be :namespace_prefix
    end
    it "option has 'HGNC' namespace prefix as value" do
      expect(BEL::Completion.complete(text).first.options).to eql ['HGNC']
    end
    it "the second result is a no match" do
      expect(BEL::Completion.complete(text)[1]).to be_a(NoMatch)
    end
    it "no match position is at start of last token" do
      expect(BEL::Completion.complete(text)[1].position).to be text.index('HG')
    end
    it "no match value is 'HG'" do
      expect(BEL::Completion.complete(text)[1].value).to eql 'HG'
    end
    it "no match value type is :function" do
      expect(BEL::Completion.complete(text)[1].value_type).to be :function
    end
  end

  context "when completing 'p(COM'" do
    subject(:text) { 'p(COM' }
    it "returns two results" do
      expect(BEL::Completion.complete(text).length).to be 2
    end
    it "returns an option" do
      expect(BEL::Completion.complete(text).first).to be_a(Option)
    end
    it "option position is at start of last token" do
      expect(BEL::Completion.complete(text).first.position).to be text.index('COM')
    end
    it "option value is 'COM'" do
      expect(BEL::Completion.complete(text).first.value).to eql 'COM'
    end
    it "option value type is :namespace_prefix" do
      expect(BEL::Completion.complete(text).first.value_type).to be :namespace_prefix
    end
    it "option has 'SCOMP' namespace prefix as value" do
      expect(BEL::Completion.complete(text).first.options).to eql ['SCOMP']
    end
    it "the second result is an option" do
      expect(BEL::Completion.complete(text)[1]).to be_a(Option)
    end
    it "option position is at start of last token" do
      expect(BEL::Completion.complete(text)[1].position).to be text.index('COM')
    end
    it "option value is 'COM'" do
      expect(BEL::Completion.complete(text)[1].value).to eql 'COM'
    end
    it "option value type is :namespace_prefix" do
      expect(BEL::Completion.complete(text)[1].value_type).to be :function
    end
    it "option has 'SCOMP' namespace prefix as value" do
      expect(BEL::Completion.complete(text)[1].options).to eql [
        'complex', 'complexAbundance', 'composite', 'compositeAbundance'
      ]
    end
  end

  context "when completing 'p(MGI'" do
    subject(:text) { 'p(MGI' }
    it "returns three results" do
      expect(BEL::Completion.complete(text).length).to be 3
    end
    it "returns a match" do
      expect(BEL::Completion.complete(text).first).to be_a(Match)
    end
    it "match position is at start of last token" do
      expect(BEL::Completion.complete(text).first.position).to be text.index('MGI')
    end
    it "match value is 'MGI'" do
      expect(BEL::Completion.complete(text).first.value).to eql 'MGI'
    end
    it "match value type is :namespace_prefix" do
      expect(BEL::Completion.complete(text).first.value_type).to be :namespace_prefix
    end
    it "the second result is a no match" do
      expect(BEL::Completion.complete(text)[1]).to be_a(NoMatch)
    end
    it "no match position is at start of last token" do
      expect(BEL::Completion.complete(text)[1].position).to be text.index('MGI')
    end
    it "no match value is 'MGI'" do
      expect(BEL::Completion.complete(text)[1].value).to eql 'MGI'
    end
    it "no match value type is :function" do
      expect(BEL::Completion.complete(text)[1].value_type).to be :function
    end
    it "the third result is an insert" do
      expect(BEL::Completion.complete(text)[2]).to be_a(Insert)
    end
    it "insert position is at end of text" do
      expect(BEL::Completion.complete(text)[2].position).to be text.length
    end
    it "insert value_type is :colon" do
      expect(BEL::Completion.complete(text)[2].value_type).to be :colon
    end
    it "single value for insert" do
      expect(BEL::Completion.complete(text)[2].values.length).to be 1
    end
    it "insert value to be '('" do
      expect(BEL::Completion.complete(text)[2].values.first).to eql ':'
    end
  end

  context "when completing 'tscript(complex'" do
    subject(:text) { 'tscript(complex' }
    it "returns three results" do
      expect(BEL::Completion.complete(text).length).to be 3
    end
    it "returns a no match" do
      expect(BEL::Completion.complete(text).first).to be_a(NoMatch)
    end
    it "no match position is at start of last token" do
      expect(BEL::Completion.complete(text)[0].position).to be text.index('complex')
    end
    it "no match value is 'complex'" do
      expect(BEL::Completion.complete(text)[0].value).to eql 'complex'
    end
    it "no match value type is :namespace_prefix" do
      expect(BEL::Completion.complete(text)[0].value_type).to be :namespace_prefix
    end
    it "the second result is a match" do
      expect(BEL::Completion.complete(text)[1]).to be_a(Match)
    end
    it "match position is at start of last token" do
      expect(BEL::Completion.complete(text)[1].position).to be text.index('complex')
    end
    it "match value is 'complex'" do
      expect(BEL::Completion.complete(text)[1].value).to eql 'complex'
    end
    it "match value type is :function" do
      expect(BEL::Completion.complete(text)[1].value_type).to be :function
    end
    it "the third result is an insert" do
      expect(BEL::Completion.complete(text)[2]).to be_a(Insert)
    end
    it "insert position is at end of text" do
      expect(BEL::Completion.complete(text)[2].position).to be text.length
    end
    it "insert value_type is :o_paren" do
      expect(BEL::Completion.complete(text)[2].value_type).to be :o_paren
    end
    it "single value for insert" do
      expect(BEL::Completion.complete(text)[2].values.length).to be 1
    end
    it "insert value to be '('" do
      expect(BEL::Completion.complete(text)[2].values.first).to eql '('
    end
  end

  context "when completing 'tscript(p()'" do
    subject(:text) { 'tscript(p()' }
    it "returns two results" do
      expect(BEL::Completion.complete(text).length).to be 2
    end
    it "returns an insert" do
      expect(BEL::Completion.complete(text)[0]).to be_a(Insert)
    end
    it "insert position is at end of text" do
      expect(BEL::Completion.complete(text)[0].position).to be text.length
    end
    it "insert value_type is :comma" do
      expect(BEL::Completion.complete(text)[0].value_type).to be :comma
    end
    it "single value for insert" do
      expect(BEL::Completion.complete(text)[0].values.length).to be 1
    end
    it "insert value to be ','" do
      expect(BEL::Completion.complete(text)[0].values.first).to eql ','
    end
    it "the second result is an insert" do
      expect(BEL::Completion.complete(text)[1]).to be_a(Insert)
    end
    it "insert position is at end of text" do
      expect(BEL::Completion.complete(text)[1].position).to be text.length
    end
    it "insert value_type is :c_paren" do
      expect(BEL::Completion.complete(text)[1].value_type).to be :c_paren
    end
    it "single value for insert" do
      expect(BEL::Completion.complete(text)[1].values.length).to be 1
    end
    it "insert value to be ')'" do
      expect(BEL::Completion.complete(text)[1].values.first).to eql ')'
    end
  end
end

describe BEL::Completion, '#inspect' do
  it 'returns function insert when empty' do
    actions = BEL::Completion.inspect('').to_a
    expect(actions.length).to be 1
    expect(actions[0]).to be_a(Insert)
  end

  it 'returns error when no matched function' do
    # test with non-match IDENT
    actions = BEL::Completion.inspect('foobar').to_a
    expect(actions.length).to be 1
    error = actions[0]
    expect(error).to be_a(Error)
    expect(error).to eql(Error.new(0, 'foobar', :IDENT, '"foobar" is not a BEL function', SORTED_FUNCTIONS))

    # test with non-IDENT
    actions = BEL::Completion.inspect(':').to_a
    expect(actions.length).to be 1
    error = actions[0]
    expect(error).to be_a(Error)
    expect(error).to eql(Error.new(0, ':', :IDENT, '":" is not a BEL function', SORTED_FUNCTIONS))
  end

  it 'returns multiple function options when partial match' do
    actions = BEL::Completion.inspect('abund').to_a
    expect(actions.length).to be 1
    replace = actions[0]
    expect(replace).to be_a(Replace)
    expect(replace).to eql(Replace.new(0, 'abund', :IDENT, [
      'abundance',
      'complexAbundance',
      'compositeAbundance',
      'geneAbundance',
      'microRNAAbundance',
      'proteinAbundance',
      'rnaAbundance'
    ]))
  end

  it 'returns multiple function options when full and partial match' do
    actions = BEL::Completion.inspect('complex').to_a
    expect(actions.length).to be 2
    (insert, replace) = actions
    expect(insert).to be_a(Insert)
    expect(insert).to eql(Insert.new(7, :O_PAREN, ['(']))
    expect(replace).to be_a(Replace)
    expect(replace).to eql(Replace.new(0, 'complex', :IDENT, [
      'complexAbundance'
    ]))
  end

  it 'returns single function option for close match' do
    actions = BEL::Completion.inspect('phosp').to_a
    expect(actions.length).to be 1
    replace = actions[0]
    expect(replace).to be_a(Replace)
    expect(replace).to eql(Replace.new(0, 'phosp', :IDENT, ['phosphataseActivity']))
  end

  it 'returns open parenthesis when complete match on function' do
    actions = BEL::Completion.inspect('complexAbundance').to_a
    expect(actions.length).to be 1
    replace = actions[0]
    expect(replace).to be_a(Insert)
    expect(replace).to eql(Insert.new(16, :O_PAREN, ['(']))
  end

  # it 'returns functions and namespaces after open parenthesis' do
  #   actions = BEL::Completion.inspect('complex(').to_a
  #   puts actions
  #   expect(actions.length).to be 1
  #   replace = actions[0]
  #   expect(replace).to be_a(Insert)
  #   expect(replace).to eql(Insert.new(16, :O_PAREN, ['(']))
  # end
end

