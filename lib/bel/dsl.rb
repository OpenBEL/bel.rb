module BEL
  # DSL adds BEL functions and relationships as Ruby methods that allows
  # creation of {BEL::Nanopub::Term} and {BEL::Nanopub::Statement} objects.
  #
  # DSL is an acronym for "Domain-specific language".
  #
  # @see https://en.wikipedia.org/wiki/Domain-specific_language
  module DSL
    # Defines ruby methods for BEL functions and relationships on _object_. The
    # functions and relationships from the provided _specification_ are used.
    #
    # @param [Object] object the object to include the DSL methods in
    # @param [BELParser::Language::Specification] spec the BEL specification
    def self.include_in(object, spec)
      spec.functions.each do |function|
        self._define_term_method(object, function.short, function, spec)
        self._define_term_method(object, function.long,  function, spec)
      end
      nil
    end

    def self._define_term_method(object, name, function, spec)
      object.send(:define_method, name) do |*args|
        object       = BEL::Nanopub::Term.new(function, *args)
        object_class = object.singleton_class
        spec.relationships.each do |relationship|
          object_class.send(:define_method, relationship.long) do |another|
            s              = BEL::Nanopub::Statement.new self
            s.relationship = relationship
            s.object       = another
            s
          end
        end
        object
      end
    end
  end
end
