require 'bel'
require_relative 'document_header'
require_relative 'annotation'
require_relative 'citation'
require_relative 'namespace'
require_relative 'parameter'
require_relative 'term'
require_relative 'statement'

require_relative '../gen'
BEL::Gen.soft_require('rantly')

module BEL
  module Gen

    # The {Nanopub} module defines methods that generate random
    # {BEL::Nanopub::Nanopub nanopubs}.
    module Nanopub

      # Include other generators needed to create {BEL::Nanopub::Nanopub}.
      include BEL::Gen::DocumentHeader
      include BEL::Gen::Annotation
      include BEL::Gen::Citation
      include BEL::Gen::Namespace
      include BEL::Gen::Parameter
      include BEL::Gen::Statement
      include BEL::Gen::Term

      # Returns a random {BEL::Nanopub::Nanopub}.
      #
      # @return [BEL::Nanopub::Nanopub] a random nanopub
      def nanopub
        nanopub = BEL::Nanopub::Nanopub.new

        nanopub.bel_statement      = bel_statement
        nanopub.citation           = citation
        nanopub.support            = BEL::Nanopub::Support.new(
          Rantly { sized(120) {string(:alpha)} }
        )
        nanopub.experiment_context = BEL::Nanopub::ExperimentContext.new(
          (1..5).to_a.sample.times.map { annotation }
        )
        nanopub.references         = BEL::Nanopub::References.new({
          :namespaces  => referenced_namespaces.map { |prefix, ns_def|
            {
              :keyword => prefix,
              :uri     => ns_def.url
            }
          }.sort_by { |ns| ns[:keyword] },
          :annotations => referenced_annotations.map { |keyword, anno_def|
            {
              :keyword => keyword,
              :type    => :uri,
              :domain  => anno_def.url
            }
          }
        })
        nanopub.metadata           = BEL::Nanopub::Metadata.new({
          :document_header => document_header
        })

        nanopub
      end
    end
  end
end
