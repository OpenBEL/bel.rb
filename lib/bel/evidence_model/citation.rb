module BEL
  module Model

    # A Citation provides a reference to the resource containing the
    # {Evidence} information. The fields are defined as:
    #
    # - +date+
    #   - The date represents when the article was published.
    # - +authors+
    #   - The authors refer to the authors of the article.
    #
    # @attr [String] type the type of the article commonly defined by
    #       +"PubMed"+, +"Journal"+, +"Book"+, or +"Online Resource"+
    # @attr [String] name the name of the article
    # @attr [String] id the identifier of the article. For example, for a
    #       +"PubMed"+ type the identifier is the PMID (i.e. 12102192)
    # @attr [String] date the date when the article was published
    # @attr [String] authors the authors of the article
    # @attr [String] comment a comment on the citation
    class Citation < Struct.new(
      :type,
      :name,
      :id,
      :date,
      :authors,
      :comment
    )

      # Creates a {Citation} struct from a +Hash+.
      # @param [Hash] fields the citation fields to populate based on hash
      #        keys
      # @example Create a minimal {Citation}.
      #   Citation.create(
      #     {
      #       :type => 'PubMed',
      #       :name => 'Biocompatibility study of biological tissues fixed
      #                 by a natural compound (reuterin) produced by
      #                 Lactobacillus reuteri.',
      #       :id   => '12102192'
      #     }
      #   )
      # @example Create a full {Citation}.
      #   Citation.create(
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
      def self.create(fields = {})
        citation = Citation.new
        (Citation.members & fields.keys).each { |member|
          citation.send(:"#{member}=", fields[member])
        }
        citation
      end
    end
  end
end
