module BEL
  module Nanopub

    def self.union_namespace_references(destination, source, suffix = 'incr')
      BEL::Nanopub.union_by_keyword(
        destination,
        source,
        suffix
      )
    end

    def self.union_annotation_references(destination, source, suffix = 'incr')
      BEL::Nanopub.union_by_keyword(
        destination,
        source,
        suffix
      )
    end

    # Combines annotation/namespace references together by disambiguating
    # the keywords. The references in @source@ are combined into
    # @destination@.
    #
    # @param  [Array<Hash>] destination existing references to merge with; may
    #         be an empty @[]@ array
    # @param  [Array<Hash>] source references to union with @destination@
    # @param  [String]      suffix the suffix to apply to reference keywords
    #         in @source@ for disambiguation
    # @return [Array<Array<Hash>,Hash>] array where the first item is and
    #         Array of combined references and the second item is a Hash that
    #         remaps references from source
    def self.union_by_keyword(destination, source, suffix = 'incr')
      # find new
      new            = source - destination
      suffix_pattern = /#{Regexp.escape(suffix)}([0-9]+)$/
      remap_result   = {}

      combined = destination + new.map { |new_obj|
        new_key = new_obj[:keyword].to_s

        # find a match where the keyword differs
        new_value      = new_obj.reject { |key, value| key == :keyword }
        match_by_value = destination.find { |dest|
          new_value == dest.reject { |key, value| key == :keyword }
        }

        rewrite_key =
          if match_by_value
            match_by_value[:keyword]
          else
            # find max suffix match
            max_suffix = destination.map { |dest|
              key, suffix_number = dest[:keyword].to_s.split(suffix_pattern)
              if new_key == key
                suffix_number
              else
                nil
              end
            }.compact.max { |suffix_number|
              suffix_number.to_i
            }

            if max_suffix
              new_key + suffix + max_suffix.next
            else
              if destination.any? { |dest| dest[:keyword] == new_key }
                "#{new_key}#{suffix}1"
              else
                new_key
              end
            end
          end

        rewrite_obj           = new_obj.merge({:keyword => rewrite_key})
        remap_result[new_obj] = rewrite_obj
        rewrite_obj
      }
      combined.uniq!

      [combined, remap_result]
    end

  end
end
