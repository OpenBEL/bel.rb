require 'bel'
require 'rantly/rspec_extensions'

describe BEL::Quoting do

  describe 'methods included in module' do

    include BEL::Quoting

    describe "#quote" do

      it "always returns a double quoted value" do
        property_of {
          string(%r{[[:ascii:]]})
        }.check { |string|
          expect(
            quote(string)
          ).to match(
            /\A".*?"\Z/m
          )
        }
      end

      it "adds double quoting if does not end with double quote" do
        property_of {
          string = string(%r{[[:ascii:]]})
          string[-1] = 'X'
        }.check { |string|
          expect(quote(string)).to eql(%Q{"#{string}"})
        }
      end

      it "adds double quoting if does not start with double quote" do
        property_of {
          string = string(%r{[[:ascii:]]})
          string[0] = 'X'
        }.check { |string|
          expect(quote(string)).to eql(%Q{"#{string}"})
        }
      end

      it "escapes double quote within the value" do
        property_of {
          string = sized(50) { string(%r{[[:ascii:]]}) }
          range(5, 10).times do
            string.insert(range(0, string.length), '"')
          end
          string
        }.check { |string|
          unquoted          = quote(string).gsub(/\A"|"\Z/m, '')
          num_double_quotes = unquoted.scan(/"/m).length
          num_escape_quotes = unquoted.scan(/\\"/m).length

          expect(num_double_quotes).to eql(num_escape_quotes)
        }
      end

      it "[idempotent] multiple calls will only double quote once" do
        property_of {
          string(%r{[[:ascii:]]})
        }.check { |string|
          num_calls = Rantly { range(5, 100) }
          result    = num_calls.times.reduce(string) { |res, _|
            quote(res)
          }

          result_value = result[1...-1]

          expect(result_value).not_to start_with '"'

          unless result_value.end_with?('\"')
            expect(result[1...-1]).not_to end_with '"'
          end
        }
      end

      it "[idempotent] multiple calls will only escape once" do
        property_of {
          string = sized(50) { string(%r{[[:ascii:]]}) }
          range(5, 10).times do
            string.insert(range(0, string.length), '"')
          end
          string.gsub(/\\/, '')
        }.check { |string|
          num_calls = Rantly { range(5, 100) }
          result    = num_calls.times.reduce(string) { |res, _|
            quote(res)
          }

          expect(result).not_to match(/\\\\/)
        }
      end
    end

    describe "#unquote" do

      it "[idempotent] only removes the leading and trailing double quote" do
        property_of {
          %Q{"#{string(%r{[[:ascii:]]})}"}
        }.check { |string|
          num_calls = Rantly { range(5, 100) }
          result    = num_calls.times.reduce(string) { |res, _|
            unquote(res)
          }

          expect(result).not_to match(/\A"(?<!\\).*?(?<!\\)"\Z/m)
        }
      end

      it "[idempotent] will not remove double quotes within the value" do
        property_of {
          string = sized(50) { string(%r{[[:ascii:]]}) }
          range(5, 10).times do
            string.insert(range(0, string.length), '"')
          end
          string
        }.check { |string|
          num_calls = Rantly { range(5, 100) }
          result    = num_calls.times.reduce(string) { |res, _|
            unquote(res)
          }

          expect(result.scan(/\\"/)).to eql(string.scan(/\\"/))
        }
      end
    end

    describe "#quote_if_needed" do

      it "values with word characters (e.g. [0-9A-Za-z_]) are not quoted" do
        property_of {
          string = sized(range(1,20)) {
            string(/[0-9A-Za-z_]/)
          }
          guard string !~ BEL::Quoting::KeywordMatcher

          string
        }.check { |string|
          expect(quote_if_needed(string)).not_to match(/\A".*?"\Z/)
        }
      end

      it "BEL keywords are always quoted" do
        property_of {
          choose(*BEL::Quoting::Keywords)
        }.check { |string|
          expect(quote_if_needed(string)).to match(/\A".*?"\Z/)
        }
      end
    end

    describe "#quoted?" do

      it "double quoted values shall report true" do
        property_of {
          string = sized(50) { string(%r{[[:ascii:]]}) }
          range(5, 10).times do
            string.insert(range(0, string.length), '"')
          end
          %Q{"#{string}"}
        }.check { |string|
          expect(quoted?(string)).to be_truthy
        }
      end

      it "not double quoted values shall report false" do
        property_of {
          string = sized(50) { string(%r{[[:ascii:]]}) }
          range(5, 10).times do
            string.insert(range(0, string.length), '"')
          end

          while string.match(/\A".*?"\Z/m)
            string = string.sub(/\A"/, '').sub(/"\Z/, '')
          end
        }.check { |string|
          expect(quoted?(string)).to be_falsey
        }
      end
    end

    describe "#unquoted?" do

      it "double quoted values shall report false" do
        property_of {
          string = sized(50) { string(%r{[[:ascii:]]}) }
          range(5, 10).times do
            string.insert(range(0, string.length), '"')
          end
          %Q{"#{string}"}
        }.check { |string|
          expect(unquoted?(string)).to be_falsey
        }
      end

      it "not double quoted values shall report true" do
        property_of {
          string = sized(50) { string(%r{[[:ascii:]]}) }
          range(5, 10).times do
            string.insert(range(0, string.length), '"')
          end

          while string.match(/\A".*?"\Z/m)
            string = string.sub(/\A"/, '').sub(/"\Z/, '')
          end
        }.check { |string|
          expect(unquoted?(string)).to be_truthy
        }
      end
    end

    describe "#identifier_value?" do

      it "values with word characters (e.g. [0-9A-Za-z_]) are identifiers" do
        property_of {
          string = sized(range(1,20)) {
            string(/[0-9A-Za-z_]/)
          }
          guard string !~ BEL::Quoting::KeywordMatcher

          string
        }.check { |string|
          expect(identifier_value?(string)).to be_truthy
        }
      end

      it "some BEL keywords are not identifiers" do
        property_of {
          choose(*BEL::Quoting::Keywords)
        }.check { |string|
          expect(identifier_value?(string)).to be_falsey
        }
      end

      it "values with non-word characters are not identifiers" do
        property_of {
          string = sized(range(1,20)) {
            string(:ascii)
          }
          guard string !~ /^[0-9A-Za-z_]+$/

          string
        }.check { |string|
          expect(identifier_value?(string)).to be_falsey
        }
      end
    end

    describe "#string_value?" do

      it "values with non-word characters are not identifiers" do
        property_of {
          string = sized(range(1,20)) {
            string(:ascii)
          }
          guard string !~ /^[0-9A-Za-z_]+$/

          string
        }.check { |string|
          expect(string_value?(string)).to be_truthy
        }
      end

      it "some BEL keywords are string values" do
        property_of {
          choose(*BEL::Quoting::Keywords)
        }.check { |string|
          expect(string_value?(string)).to be_truthy
        }
      end

      it "values with word characters (e.g. [0-9A-Za-z_]) are not string values" do
        property_of {
          string = sized(range(1,20)) {
            string(/[0-9A-Za-z_]/)
          }
          guard string !~ BEL::Quoting::KeywordMatcher

          string
        }.check { |string|
          expect(string_value?(string)).to be_falsey
        }
      end
    end
  end
end
