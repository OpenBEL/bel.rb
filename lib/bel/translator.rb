module BEL

  # The Translator module defines a plugin that reads a specific document
  # format into BEL evidence and writes BEL evidence back to this document
  # format.
  #
  # - Metadata
  #   - {#id}:              the runtime-wide unique extension id
  #   - {#media_types}:     the media types this format supports
  #   - {#file_extensions}: the file extensions this format supports
  # - Read
  #   - {#read}:            read the implemented document format and return
  #     {::BEL::Model::Evidence} objects
  # - Write
  #   - {#write}:           write {::BEL::Model::Evidence} objects to the
  #     implemented document format
  #
  # @example Create a YAML format extension.
  #   class FormatYAML
  #     include BEL::Translator
  #
  #     ID          = :yaml
  #     MEDIA_TYPES = %i(text/yaml)
  #     EXTENSIONS  = %i(yaml)
  #
  #     def id
  #       ID
  #     end
  #
  #     def media_types
  #       MEDIA_TYPES
  #     end
  #
  #     def file_extensions
  #       EXTENSIONS
  #     end
  #
  #     def read(data, options = {})
  #       objects = YAML.load(data)
  #       # map objects to BEL evidence
  #       # return enumerator
  #     end
  #
  #     def write(data, writer = nil, options = {})
  #       # map BEL evidence to YAML objects
  #       YAML.dump(data)
  #     end
  #   end
  module Translator

    module Plugins; end

    extend LittlePlugger(
      :path   => 'bel/translator/plugins',
      :module => BEL::Translator::Plugins
    )

    def id
      raise NotImplementedError.new("#{__method__} is not implemented.")
    end

    def media_types
      # optional
      nil
    end

    def file_extensions
      # optional
      nil
    end

    def evidence_hash(object)
      raise NotImplementedError.new("#{__method__} is not implemented.")
    end

    def read(data, options = {})
      raise NotImplementedError.new("#{__method__} is not implemented.")
    end

    def write(data, writer = nil, options = {})
      raise NotImplementedError.new("#{__method__} is not implemented.")
    end
  end

  # TranslateError represents an error when the specified format is not
  # supported by the {Format} extension framework.
  class TranslateError < StandardError

    FORMAT_ERROR = %Q{Format "%s" is not supported.}

    def initialize(format)
      super(FORMAT_ERROR % format)
    end
  end
end
