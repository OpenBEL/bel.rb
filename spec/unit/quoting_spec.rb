require 'bel'
require 'rantly/rspec_extensions'

describe BEL::Quoting do
  include BEL::Quoting

  describe "#quotes_required?" do

    it "does not require quotes for word character strings (alphanumeric, _)" do
      property_of {
        string(%r{[[:word:]]})
      }.check { |string|
        expect(quotes_required?(string)).to be_falsey
      }
    end

    it "requires quotes for non-word character strings (spaces, punctuation, etc)" do
      [
        %r{[[:blank:]]}, %r{[[:cntrl:]]}, %r{[[:space:]]}
      ].each do |char_regex|
        property_of {
          string(char_regex)
        }.check { |string|
          expect(quotes_required?(string)).to be_truthy
        }
      end
    end
  end

  describe "#ensure_quotes" do
    it "does not place quotes around word character strings (alphanumeric, _)" do
      property_of {
        string(%r{[[:word:]]})
      }.check { |string|
        expect(ensure_quotes(string)).to equal(string)
      }
    end

    it "places quotes around non-word character strings (spaces, punctuation, etc)" do
      [
        %r{[[:blank:]]}, %r{[[:cntrl:]]}, %r{[[:space:]]}
      ].each do |char_regex|
        property_of {
          string(char_regex)
        }.check { |string|
          expect(ensure_quotes(string)).to eq(%Q{"#{string}"})
        }
      end
    end
  end

  describe "#always_quote" do
    it "places quotes around any string" do
      Rantly::Chars::CLASSES.keys.each do |char_class|
        regexp = Regexp.new("[[:#{char_class}:]]")
        property_of {
          string(regexp)
        }.check { |string|
          expect(always_quote(string)).to eq(%Q{"#{string}"})
        }
      end
    end
  end
end
# vim: ts=2 sw=2:
