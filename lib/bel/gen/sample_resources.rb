require_relative '../gen'
BEL::Gen.soft_require('rantly')

module BEL
  module Gen

    # The {SampleResources} module defines methods that sample data from actual
    # resources.
    #
    # {BEL::Nanopub::Parameter BEL parameters} are sampled from a
    # {BEL::Namespace::NamespaceDefinition}.
    #
    # Annotations are sampled from a {BEL::Annotation::AnnotationDefinition}.
    module SampleResources
      include BEL::Gen::Annotation

      # Returns a sampled annotation as a hash of +:name+ and +:value+. These
      # can be added directly to a nanopubs's {BEL::Nanopub::ExperimentContext}.
      #
      # @return [Hash] sampled annotation; hash of +:name+ and +:value+
      def annotation
        # pick annotation definition
        anno = Rantly {
          choose(*ANNOTATIONS)
        }

        # track annotation definitions
        referenced_annotations[anno.keyword] = anno

        {
          :name  => anno.keyword,
          :value => anno.values.keys.sample
        }
      end

      # Returns a BEL parameter with a value sampled from a random namespace.
      #
      # @return [BEL::Nanopub::Parameter] a parameter with value sampled from a
      #         random namespace
      def bel_parameter_with_namespace
        ns    = namespace
        value = ns.values.keys.sample
        enc   = ns.values[value]
        BEL::Nanopub::Parameter.new(
          ns,
          value,
          enc
        )
      end
    end
  end
end
