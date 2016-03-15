require_relative '../spec_helper'
require 'bel'
require 'rantly'
require 'rantly/rspec_extensions'

BEL.translator(:bel)

class Rantly

  def random_annotation
    Rantly {
      annotation = {
        keyword: choose('Species__', 'Id', 'Code', 'Tissue__', 'Cell', 'TextLocation', 'On-Target__'),
        type:    choose('url', 'list', 'pattern'),
      }

      annotation[:domain] =
        case annotation[:type]
        when 'url'
          sized(20) { string(:alnum) }
        when 'list'
          array(10) { range(10, 100) }
        when 'pattern'
          sized(10) { string(:ascii) }
        end

      annotation
    }
  end

  def random_namespace
    Rantly {
      {
        keyword: choose('HGNC__', 'EGID', 'MGI', 'GO__', 'SP', 'MESHPP', 'CHEBI__'),
        uri:     string(:alnum)
      }
    }
  end
end

describe BEL::Translator::Plugins::BelScript::BelYielder do

  def combine_by_keyword(destination, source, suffix = '__')
    # find new
    new            = source - destination
    suffix_pattern = /#{Regexp.escape(suffix)}([0-9]+)$/
    remap_result   = {}

    combined = destination + new.map { |new_obj|
      new_key = new_obj[:keyword]

      # find a match where the keyword differs
      new_value      = new_obj.reject { |key, value| key == :keyword }
      match_by_value = destination.find { |dest|
        new_value == dest.reject { |key, value| key == :keyword }
      }

      if match_by_value
        new_obj[:keyword] = match_by_value[:keyword]
      else
        # find max suffix match
        max_suffix = destination.map { |dest|
          key, suffix_number = dest[:keyword].split(suffix_pattern)
          if new_key.start_with?(key)
            suffix_number
          else
            nil
          end
        }.compact.max { |suffix_number|
          suffix_number.to_i
        }

        rewritten_key =
          if max_suffix
            new_key + suffix + max_suffix.next
          else
            if destination.any? { |dest| dest[:keyword] == new_key }
              "#{new_key}#{suffix}1"
            else
              new_key
            end
          end

        new_obj[:keyword] = rewritten_key
      end

      remap_result[new_key] = new_obj[:keyword]
      new_obj
    }

    [combined, remap_result]
  end

  it "can assume a remapped keyword" do
    annotations = [
      [
        {keyword: 'Species', type: 'url', domain: 'species.belanno'},
      ],
      [
        {keyword: 'Species', type: 'url', domain: 'taxonomy.belanno'},
      ],
      [
        {keyword: 'Species', type: 'url', domain: 'taxonomy.belanno'},
      ],
    ]

    result1 = combine_by_keyword(annotations[0], annotations[1], '__')[0]
    result2 = combine_by_keyword(result1, annotations[2], '__')[0]

    expect(
      result2
    ).to eql([
      {keyword: 'Species',   type: 'url', domain: 'species.belanno'},
      {keyword: 'Species__1', type: 'url', domain: 'taxonomy.belanno'},
      {keyword: 'Species__1', type: 'url', domain: 'taxonomy.belanno'},
    ])
  end

  it "removes duplicates" do
    annotations = [
      [
        {keyword: 'Species', type: 'url',     domain: 'species.belanno'},
        {keyword: 'Id',      type: 'list',    domain: [1,2,3,4,5]},
        {keyword: 'Code',    type: 'pattern', domain: '[A-Z][A-Z][A-Z]'},
      ],
      [
        {keyword: 'Species', type: 'url',     domain: 'species.belanno'},
        {keyword: 'Id',      type: 'list',    domain: [1,2,3,4,5]},
        {keyword: 'Code',    type: 'pattern', domain: '[A-Z][A-Z][A-Z]'},
      ],
    ]

    expect(
      combine_by_keyword(annotations[0], annotations[1], '__')[0]
    ).to eql([
      {keyword: 'Species', type: 'url',     domain: 'species.belanno'},
      {keyword: 'Id',      type: 'list',    domain: [1,2,3,4,5]},
      {keyword: 'Code',    type: 'pattern', domain: '[A-Z][A-Z][A-Z]'},
    ])
  end

  it "combines annotations" do
    annotations = [
      [
        {keyword: 'Species', type: 'url',     domain: 'species.belanno'},
        {keyword: 'Id',      type: 'list',    domain: [1,2,3,4,5]},
        {keyword: 'Code__1', type: 'pattern', domain: '[A-Z][A-Z][A-Z]'},
      ],
      [
        {keyword: 'Species', type: 'url',     domain: 'ncbi-taxonomy.belanno'},
        {keyword: 'Id',      type: 'list',    domain: [1,2,3,4,5]},
        {keyword: 'Code',    type: 'pattern', domain: '[a-z0-9]+'},
      ],
    ]

    expect(
      combine_by_keyword(annotations[0], annotations[1], '__')[0]
    ).to eql([
      {keyword: 'Species',    type: 'url',     domain: 'species.belanno'},
      {keyword: 'Id',         type: 'list',    domain: [1,2,3,4,5]},
      {keyword: 'Code__1',    type: 'pattern', domain: '[A-Z][A-Z][A-Z]'},
      {keyword: 'Species__1', type: 'url',     domain: 'ncbi-taxonomy.belanno'},
      {keyword: 'Code__2',    type: 'pattern', domain: '[a-z0-9]+'},
    ])
  end

  it "[property test] combination does not contain duplicates" do
    # annotations
    property_of {
      array(range(5, 50)) {
        annotations = []
        while annotations.length < 5 do
          anno = random_annotation
          annotations << anno unless annotations.find { |x| x[:keyword] == anno[:keyword] }
        end
        annotations
      }
    }.check { |annotation_set|
      combined = annotation_set.reduce([]) { |result, annotations|
        combine_by_keyword(result, annotations)[0]
      }

      keywords = combined.map { |x| x[:keyword] }
      expect(keywords.length).to eql(keywords.uniq.length)
    }

    # namespaces
    property_of {
      array(range(5, 50)) {
        namespaces = []
        while namespaces.length < 5 do
          ns = random_namespace
          namespaces << ns unless namespaces.find { |x| x[:keyword] == ns[:keyword] }
        end
        namespaces
      }
    }.check { |namespace_set|
      combined = namespace_set.reduce([]) { |result, namespaces|
        combine_by_keyword(result, namespaces)[0]
      }

      keywords = combined.map { |x| x[:keyword] }
      expect(keywords.length).to eql(keywords.uniq.length)
    }

  end
end
