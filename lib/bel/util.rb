require 'digest'
require 'open-uri'
require 'pathname'
require 'tempfile'

module BEL

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
