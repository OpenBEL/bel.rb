require 'bel_parser/expression/model'
require 'bel_parser/resources'

module BEL
  # DSL adds BEL functions and relationships as Ruby methods that allows
  # creation of {BELParser::Expression::Model::Term} and
  # {BELParser::Expression::Model::Statement} objects.
  #
  # DSL is an acronym for "Domain-specific language".
  #
  # @see https://en.wikipedia.org/wiki/Domain-specific_language
  module DSL
    # Defines ruby methods for BEL functions and relationships on
    # +another_module+. The functions and relationships from the
    # {BELParser::Language.default_specification default specification}
    # are included.
    #
    # This method is called when {BEL::DSL} is included, as in:
    #
    #    # calls this method
    #    include BEL::DSL
    #
    #    # Can access namespace constants.
    #    HGNC
    #
    #    # Create new terms.
    #    p(HGNC['AKT1'])
    #
    #    # Create new statements.
    #    p(HGNC['AKT1']).increases bp(GOBP['apoptotic process'])
    #
    # @param [Module] another_module the module receiving DSL functionality
    def self.included(another_module)
      self.include_in(
        another_module,
        BELParser::Language.default_specification)
    end

    # Defines ruby methods for BEL functions and relationships on _object_. The
    # functions and relationships from the provided _specification_ are used.
    #
    # @param [Object] object the object to include the DSL methods in
    # @param [BELParser::Language::Specification] spec the BEL specification
    def self.include_in(object, spec)
      if [Class, Module].none? { |type| object.is_a?(type) }
        raise(ArgumentError, "object: expected Class or Module, actual #{object}")
      end

      BELParser::Resources.included(object)
      spec.functions.each do |function|
        self.send(:_define_term_method, object, function.short, function, spec)
        self.send(:_define_term_method, object, function.long,  function, spec)
      end
      nil
    end

    # @api private
    def self._define_term_method(object, name, function, spec)
      object.send(:define_method, name) do |*args|
        object       = BELParser::Expression::Model::Term.new(function, *args)
        object_class = object.singleton_class
        spec.relationships.each do |relationship|
          object_class.send(:define_method, relationship.long) do |another|
            s              = BELParser::Expression::Model::Statement.new self
            s.relationship = relationship
            s.object       = another
            s
          end
        end
        object
      end
    end
    private_class_method :_define_term_method
  end
end
