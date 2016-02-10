require 'digest'
require 'open-uri'
require 'pathname'
require 'tempfile'

module BEL

  # The default delimiter to use when parsing values from BEL Resource files.
  DEFAULT_RESOURCE_VALUE_DELIMITER = '|'

  # Retrieves values from a BEL resource file (e.g. .belns, .belanno).
  #
  # The file parser respects the +DelimiterString+ value specified in the file
  # but will default to {#DEFAULT_RESOURCE_VALUE_DELIMITER} if not present.
  #
  # @param [String] url the resource file URL to fetch
  # @return [Hash] hash of value symbol to extra argument symbol; the extra
  # argument is the value encoding for a BEL namespace file
  # (e.g. lung disease|O) and a database value identifier for a BEL annotation
  # file (e.g. lung|UBERON_0002048).
  def self.read_resource(url)
    resource_lines = BEL::read_lines(url)

    # Drop until the delimiter line and extract the delimiter, e.g.
    # DelimiterString=|
    delimiter_line = resource_lines.take(100).find { |l| l.start_with?("DelimiterString") }
    delimiter =
      if delimiter_line
        delimiter_line.strip.split('=')[1]
      else
        DEFAULT_RESOURCE_VALUE_DELIMITER
      end

    # Extract namespace values based on the delimiter.
    Hash[
      resource_lines.
      drop_while { |l| !l.start_with?("[Values]") }.
      drop(1).
      map { |s|
        val_enc = s.strip!.split(delimiter).map(&:to_sym)
        val_enc[0..1]
      }
    ]
  end

  def self.read_all(reference, options = {})
    return [] if reference.to_s.strip.empty?

    if cached? reference
      read_cached reference do |cf|
        return cf.read
      end
    end

    multi_open(reference, options) do |f|
      content = f.read
      write_cached reference, content
      return content
    end
  end

  def self.read_lines(reference, options = {})
    return [] if reference.to_s.strip.empty?

    if cached? reference
      read_cached reference do |cf|
        return cf.readlines
      end
    end

    multi_open(reference, options) do |f|
      content = f.read
      write_cached reference, content
      f.rewind
      return f.readlines
    end
  end

  # PRIVATE

  def self.multi_open(reference, options = {})
    return nil if reference.to_s.strip.empty?

    if cached? reference
      read_cached reference do |cf|
        if block_given?
          yield cf
        else
          return cf
        end
      end
      return
    end

    if File.exists? reference
      File.open(reference) do |f|
        if block_given?
          yield f
        else
          return f
        end
      end
    elsif reference.start_with? 'file:'
      File.open(URI(reference).path) do |f|
        if block_given?
          yield f
        else
          return f
        end
      end
    else
      open(reference, options) do |f|
        if block_given?
          yield f
        else
          return f
        end
      end
    end
  end
  private_class_method :multi_open

  def self.cached?(identifier, options = {})
    options = {
      temp_dir: Dir::tmpdir
    }.merge(options)
    return false if identifier.to_s.strip.empty?

    cached_name = cached_filename_for identifier
    path = Pathname(options[:temp_dir]) + cached_name.to_s
    File.exist? path
  end
  private_class_method :cached?

  def self.read_cached(identifier, options = {})
    options = {
      temp_dir: Dir::tmpdir
    }.merge(options)
    cached_name = cached_filename_for identifier
    path = Pathname(options[:temp_dir]) + cached_name
    File.open(path, "r") do |f|
      if block_given?
        yield f
      else
        return f.read
      end
    end
    path.to_s
  end
  private_class_method :read_cached

  def self.write_cached(identifier, data = '', options = {})
    options = {
      temp_dir: Dir::tmpdir
    }.merge(options)
    cached_name = cached_filename_for identifier
    path = Pathname(options[:temp_dir]) + cached_name
    File.open(path, "w") do |f|
      if block_given?
        yield f
      else
        f.write(data)
      end
    end
    path.to_s
  end
  private_class_method :write_cached

  def self.cached_filename_for(identifier)
    return nil unless identifier
    "#{self.to_s}_#{Digest::SHA256.hexdigest identifier}"
  end
  private_class_method :cached_filename_for
end
# vim: ts=2 sw=2
# encoding: utf-8
