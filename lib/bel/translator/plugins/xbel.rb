module BEL::Translator::Plugins

  module Xbel

    def self.create_translator(options = {})
      require_relative 'xbel/translator'
      XbelTranslator.new
    end
  end
end
