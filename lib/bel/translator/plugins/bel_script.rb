module BEL::Translator::Plugins

  module BelScript

    def self.create_translator(options = {})
      require_relative 'bel_script/translator'
      BelScriptTranslator.new
    end
  end
end
