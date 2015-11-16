module BEL::Translator::Plugins

  module JsonEvidence

    ID          = :json_evidence
    NAME        = 'JSON Evidence Translator'
    DESCRIPTION = 'A translator that can read and write evidence to individual JSON objects per the evidence schema (http://next.belframework.org/schemas/evidence.schema.json).'
    MEDIA_TYPES = %i(application/json)
    EXTENSIONS  = %i(json)
    EVIDENCE_ROOT = :evidence

    def self.create_translator(options = {})
      require_relative 'json_evidence/translator'

      JsonEvidenceTranslator.new
    end
    
    def self.id
      ID
    end

    def self.name
      NAME
    end

    def self.description
      DESCRIPTION
    end

    def self.media_types
      MEDIA_TYPES
    end

    def self.file_extensions
      EXTENSIONS
    end
  end
end
