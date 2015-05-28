module BEL
  module Quoting

    NonWordMatcher = Regexp.compile(/[^0-9a-zA-Z_]/)
    KeywordMatcher = Regexp.compile(/^(SET|DEFINE|a|g|p|r|m)$/)

    def ensure_quotes identifier
      return "" unless identifier
      identifier.to_s.gsub! '"', '\"'
      if quotes_required? identifier
        %Q{"#{identifier}"}
      else
        identifier
      end
    end

    def remove_quotes identifier
      identifier.gsub!(/\A"|"\Z/, '')
      identifier
    end

    def always_quote identifier
      return "" unless identifier
      identifier.to_s.gsub! '"', '\"'
      %Q("#{identifier}")
    end

    def quotes_required? identifier
      [NonWordMatcher, KeywordMatcher].any? { |m| m.match identifier }
    end
  end
end
# vim: ts=2 sw=2:
# encoding: utf-8
