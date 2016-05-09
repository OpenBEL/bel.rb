require_relative '../gen'
BEL::Gen.soft_require('rantly')

module BEL
  module Gen

    # The {Citation} module defines methods that generate random citation
    # fields. See {Citation#citation} to generate a {BEL::Nanopub::Citation}.
    module Citation

      # Returns a random citation type.
      # @return [String] a random citation type
      def citation_type
        Rantly {
          choose('PubMed', 'Journal', 'Book', 'Online Resource', 'Other')
        }
      end

      # Returns a random citation name.
      # @return [String] a random citation name
      def citation_name
        Rantly {
          sized(32) {
            string(:alpha)
          }
        }
      end

      # Returns a random citation id.
      # @return [String] a random citation id
      def citation_id
        Rantly {
          sized(8) {
            string(:alnum)
          }
        }
      end

      # Returns a random citation date.
      # @return [String] a random citation date
      def citation_date
        ''
      end

      # Returns a random {Array} of citation authors.
      # @return [Array<String>] a random {Array} of citation authors
      def citation_authors
        Rantly {
          array(range(1, 5)) {
            "#{sized(6) { string(:alpha) }} #{sized(2) { string(:upper) }}"
          }.join('|')
        }
      end

      # Returns a random citation comment.
      # @return [String] a random citation comment
      def citation_comment
        Rantly {
          freq(
            [5, :literal, ''],
            [1, :literal, sized(50) { string(:alnum) }]
          )
        }
      end

      # Returns a random {BEL::Nanopub::Citation}.
      #
      # Note: This method has a good chance to return the last generated
      # {BEL::Nanopub::Citation}. This behavior better models curated BEL
      # nanopubs where many BEL statements have the same citation.
      #
      # @return [BEL::Nanopub::Citation] a random citation
      def citation
        choice = 
          @citation_hash == nil ?
            :new :
            Rantly {
              freq(
                [5, :literal, :reuse],
                [1, :literal, :new]
              )
            }

        if choice == :new
          @citation_hash = {
            :type    => citation_type,
            :name    => citation_name,
            :id      => citation_id,
            :date    => citation_date,
            :authors => citation_authors,
            :comment => citation_comment
          }
        end

        ::BEL::Nanopub::Citation.new(@citation_hash)
      end
    end
  end
end
