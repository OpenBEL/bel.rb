require_relative '../gen'
BEL::Gen.soft_require('rantly', 'rantly/data')

module BEL
  module Gen

    # The {DocumentHeader} module defines methods that generate a random
    # document header for the {BEL::Nanopub::Nanopub} metadata.
    module DocumentHeader

      # Returns a randomly chosen document name.
      # @return [String] a random document name
      def document_name
        Rantly {
          array(range(1,4)) {
            string(:alpha).capitalize
          }.join(' ')
        }
      end

      # Returns a randomly chosen document description.
      # @return [String] a random document description
      def document_description
        Rantly {
          array(range(10,50)) {
            sized(range(3,8)) {
              string(:alpha).capitalize
            }
          }.join(' ').capitalize
        }
      end

      # Returns a randomly chosen document version.
      # @return [String] a random document version
      def document_version
        Rantly {
          if boolean
            # semver
            numeric = -> { range(0, 15) }
            "#{numeric.call}.#{numeric.call}.#{numeric.call}"
          else
            # rolling date
            year  = -> {
              range(2000, Time.now.year)
            }
            month = -> {
              choose(
                '01', '02', '03', '04', '05', '06',
                '07', '08', '09', '10', '11', '12'
              )
            }
            day   = -> {
              choose(
                '01', '02', '03', '04', '05', '06',
                '07', '08', '09', '10', '11', '12',
                '13', '14', '15', '16', '17', '18',
                '19', '20', '21', '22', '23', '24',
                '25', '26', '27', '28'
              )
            }
            "#{year.call}#{month.call}#{day.call}"
          end
        }
      end

      # Returns a randomly chosen document copyright.
      # @return [String] a random document copyright
      def document_copyright
        "You, (c) #{Time.now.year}"
      end

      # Returns a randomly chosen document contact info.
      # @return [String] a random document contact info
      def document_contact_info
        Rantly { email }
      end

      # Returns randomly chosen document authors.
      # @return [String] random document authors
      def document_authors
        Rantly {
          array(range(1, 5)) {
            "#{sized(6) { string(:alpha) }} #{sized(2) { string(:upper) }}"
          }.join('|')
        }
      end

      # Returns randomly chosen document licenses.
      # @return [String] random document licenses
      def document_licenses
        Rantly {
          choose(
            'Creative Commons Attribution (BY)',
            'Creative Commons Share-alike (BY-SA)',
            'Creative Commons Non-commercial (NC)',
            'Creative Commons No Derivative Works (ND)',
            'Open Data Commons Open Database License',
            'Open Data Commons Attribution License',
            'Open Data Commons Public Domain Dedication and License',
            'Public Domain',
          )
        }
      end

      # Returns a random document header.
      #
      # @option options [String] :name the document name override
      # @option options [String] :description the document description override
      # @option options [String] :version the document version override
      # @option options [String] :copyright the document copyright override
      # @option options [String] :contact_info the document contact info
      #         override
      # @option options [String] :authors the document authors override
      # @option options [String] :licenses the document licenses override
      # @return [Hash] random document header
      def document_header(options = {})
        {
          :Name        => options[:name]         || document_name,
          :Description => options[:description]  || document_description,
          :Version     => options[:version]      || document_version,
          :Copyright   => options[:copyright]    || document_copyright,
          :ContactInfo => options[:contact_info] || document_contact_info,
          :Authors     => options[:authors]      || document_authors,
          :Licenses    => options[:licenses]     || document_licenses,
        }
      end
    end
  end
end
