module BEL
  module Quoting

    NonWordMatcher = Regexp.compile(/[^0-9a-zA-Z_]/)
    KeywordMatcher = Regexp.compile(/^(SET|DEFINE|a|g|p|r|m)$/)

    def ensure_quotes identifier
      identifier_string = identifier.to_s

      if quotes_required? identifier_string
        identifier_string.gsub!('"', '\"')
        %Q{"#{identifier_string}"}
      else
        identifier_string
      end
    end

    def remove_quotes identifier
      identifier.to_s.gsub!(/\A"|"\Z/, '')
      identifier
    end

    def always_quote identifier
      return "" unless identifier
      identifier.to_s.gsub! '"', '\"'
      %Q("#{identifier}")
    end

    def quotes_required? identifier
      [NonWordMatcher, KeywordMatcher].any? { |m| m.match identifier.to_s }
    end
  end
end
# vim: ts=2 sw=2:
# encoding: utf-8
