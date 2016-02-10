require 'rantly'

module BEL
  module Gen
    module Citation

      def citation_type
        Rantly {
          choose('PubMed', 'Journal', 'Book', 'Online Resource', 'Other')
        }
      end

      def citation_name
        Rantly {
          sized(32) {
            string(:alpha)
          }
        }
      end

      def citation_id
        Rantly {
          sized(8) {
            string(:alnum)
          }
        }
      end

      def citation_date
        ''
      end

      def citation_authors
        Rantly {
          array(range(1, 5)) {
            "#{sized(6) { string(:alpha) }} #{sized(2) { string(:upper) }}"
          }.join('|')
        }
      end

      def citation_comment
        Rantly {
          freq(
            [5, :literal, ''],
            [1, :literal, sized(50) { string(:alnum) }]
          )
        }
      end

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

        ::BEL::Model::Citation.new(@citation_hash)
      end
    end
  end
end
