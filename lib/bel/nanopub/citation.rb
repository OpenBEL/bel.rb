module BEL
  module Nanopub

    # A Citation describes a cited reference which {Nanopub} is derived from.
    #
    # @attr [String] type the type of resource the cited material appears in
    #       (e.g. PubMed, Journal, Book, Online Resource, etc...)
    # @attr [String] name the name of the cited resource
    # @attr [String] id the unique identifier for the cited resource. For
    #       example, a +"PubMed"+ type should have a PMID (i.e. 12102192).
    # @attr [String] date the date the resource was published
    # @attr [String] authors the authors of the resource
    # @attr [String] comment an additional comment related to this resource
    class Citation

      # The ordering of citation attributes to allow processing of sequential
      # input of citation fields.
      #
      # The ordered attributes are:
      MEMBER_ORDER = %i(type name id date authors comment)

      attr_accessor(*MEMBER_ORDER)

      # Creates a {Citation} object from variable arguments.
      #
      # @param [Array<Object>] args Argument array of Object; If the array
      #        contains a single value then it is expected to either respond
      #        to +:each+ (according to #MEMBER_ORDER) or +:each_pair+
      #        (keys matching that of #MEMBER_ORDER). If the array has
      #        multiple values then they are set sequentially according to
      #        #MEMBER_ORDER.
      # @example Create an empty {Citation}.
      #   Citation.new
      # @example Create a minimal {Citation} by positional members.
      #   Citation.new('PubMed', 'Biocompatibility study of...', '12102192')
      # @example Create a minimal {Citation} by positional members in array.
      #   Citation.new(
      #     ['PubMed', 'Biocompatibility study of...', '12102192']
      #   )
      # @example Create a full {Citation} by hash using keys for members.
      #   Citation.new(
      #     {
      #       :type    => 'PubMed',
      #       :name    => 'Biocompatibility study of biological tissues fixed
      #                    by a natural compound (reuterin) produced by
      #                    Lactobacillus reuteri.',
      #       :id      => '12102192',
      #       :date    => '2002-08-23',
      #       :authors => 'Sung HW|Chen CN|Chang Y|Liang HF',
      #       :comment => 'This article is primary research.'
      #     }
      #   )
      def initialize(*args)
        return if !args || args.empty?

        if args.length == 1
          enumerable = args.first
          if enumerable.respond_to? :each_pair
            enumerable.keys.each do |key|
              enumerable[key.to_s.to_sym] = enumerable.delete(key)
            end
            (MEMBER_ORDER & enumerable.keys).each do |member|
              self.send(:"#{member}=", enumerable[member])
            end
          elsif enumerable.respond_to? :each
            MEMBER_ORDER.zip(enumerable.each).each do |member, value|
              self.send(:"#{member}=", value)
            end
          end
        else
          (MEMBER_ORDER & args).each do |member|
            self.send(:"#{member}=", hash[member])
          end
        end
      end

      # Returns the +Array+ of +String+ authors.
      #
      # @return [Array<String>] array of authors
      def authors
        @authors
      end

      # Sets the authors value.
      #
      # @param [#each, #each_pair, #to_s] authors an authors value
      def authors=(authors)
        @authors = convert_authors(authors)
      end

      # Returns whether the citation has enough pertinent information to be
      # considered valid.
      #
      # @return [true, false] whether the citation is valid
      def valid?
        type != nil && id != nil && name != nil
      end

      def hash
        [id, type, name, authors, date, comment].hash
      end

      def ==(other)
        return false if other == nil

        id == other.id && type == other.type &&
          name == other.name && authors == other.authors &&
          date == other.date && comment == other.comment
      end
      alias_method :eql?, :'=='

      # Returns a +Hash+ of the citation members accoring to #MEMBER_ORDER.
      #
      # @return [Hash] citation +Hash+
      def to_h
        MEMBER_ORDER.reduce({}) { |hash, member|
          hash[member] = self.send(member)
          hash
        }
      end

      def to_a
        MEMBER_ORDER.reduce([]) { |array, member|
          array << self.send(member)
          array
        }
      end

      private

      def convert_authors(authors)
        return nil unless authors

        if authors.respond_to? :to_a
          authors.to_a.map(&:to_s)
        elsif authors.respond_to? :each
          @authors = authors.each.to_a.map(&:to_s)
        elsif authors.respond_to? :to_s
          authors.to_s.split('|').map(&:strip)
        else
          raise ArgumentError.new("authors must be a string-like or iterable")
        end
      end
    end
  end
end
