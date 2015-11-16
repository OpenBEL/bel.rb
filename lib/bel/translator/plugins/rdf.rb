module BEL::Translator::Plugins

  module Rdf

    def self.create_translator(options = {})
      require_relative 'rdf/translator'
      RdfTranslator.new
    end
  end
end
