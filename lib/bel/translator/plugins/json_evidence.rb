module BEL::Translator::Plugins

  module JsonEvidence

    def self.create_translator(options = {})
      require_relative 'json_evidence/translator'

      JsonEvidenceTranslator.new
    end
  end
end
