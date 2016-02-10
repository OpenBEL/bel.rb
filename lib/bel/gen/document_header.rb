require 'rantly'
require 'rantly/data'

module BEL
  module Gen
    module DocumentHeader

      def document_name
        Rantly {
          array(range(1,4)) {
            string(:alpha).capitalize
          }.join(' ')
        }
      end

      def document_description
        Rantly {
          array(range(10,50)) {
            sized(range(3,8)) {
              string(:alpha).capitalize
            }
          }.join(' ').capitalize
        }
      end

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

      def document_copyright
        "You, (c) #{Time.now.year}"
      end

      def document_contact_info
        Rantly { email }
      end

      def document_authors
        Rantly {
          array(range(1, 5)) {
            "#{sized(6) { string(:alpha) }} #{sized(2) { string(:upper) }}"
          }.join('|')
        }
      end

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
