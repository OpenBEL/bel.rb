require 'bel'

include BEL::Completion

describe BEL::Completion, '#complete' do
  context "when completing ''" do
    subject(:text) { '' }
  end

  context "when completing 'abund'" do
    subject(:text) { 'abund' }
  end

  context "when completing 'comple'" do
    subject(:text) { 'comple' }
  end

  context "when completing 'activity'" do
    subject(:text) { 'activity' }
  end

  context "when completing 'complex'" do
    subject(:text) { 'complex' }
  end

  context "when completing 'bp'" do
    subject(:text) { 'bp' }
  end

  context "when completing 'p('" do
    subject(:text) { 'p(' }
  end

  context "when completing 'p(HG'" do
    subject(:text) { 'p(HG' }
  end

  context "when completing 'p(COM'" do
    subject(:text) { 'p(COM' }
  end

  context "when completing 'p(MGI'" do
    subject(:text) { 'p(MGI' }
  end

  context "when completing 'tscript(complex'" do
    subject(:text) { 'tscript(complex' }
  end

  context "when completing 'tscript(p()'" do
    subject(:text) { 'tscript(p()' }
  end
end
