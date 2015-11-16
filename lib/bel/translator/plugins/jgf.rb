module BEL::Translator::Plugins

  module Jgf

    def self.create_translator(options = {})
      require_relative 'jgf/translator'

      JgfTranslator.new
    end
  end
end
