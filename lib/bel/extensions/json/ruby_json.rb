require 'json'

module BEL::Extension::Format
  module JSONImplementation

    class JSONReader
      def initialize(data)
        @data = data
      end

      def each(&block)
        if block_given?
          JSON.load(@data, nil, :symbolize_names => true).each do |obj|
            yield obj
          end
        else
          to_enum(:each)
        end
      end
    end

    class JSONWriter

      def write_json_object(json_object)
        JSON.dump(json_object)
      end
    end
  end
end
