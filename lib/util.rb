require 'digest'
require 'open-uri'
require 'pathname'

module BEL

  def self.read_all(reference)
    if self.cached? reference
      self.read_cached reference do |cf|
        return cf.read
      end
    end

    self.multi_open(reference) do |f|
      content = f.read
      self.write_cached reference, content
      return content
    end
  end

  def self.read_lines(reference)
    if self.cached? reference
      self.read_cached reference do |cf|
        return cf.readlines
      end
    end

    self.multi_open(reference) do |f|
      content = f.read
      self.write_cached reference, content
      f.rewind
      return f.readlines
    end
  end

  private

  def self.multi_open(reference)
    if self.cached? reference
      self.read_cached reference do |cf|
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
      open(reference) do |f|
        if block_given?
          yield f
        else
          return f
        end
      end
    end
  end

  def self.cached?(identifier, options = {})
    options = {
      temp_dir: Dir::tmpdir
    }.merge(options)
    cached_name = cached_filename_for identifier
    path = Pathname(options[:temp_dir]) + cached_name
    File.exist? path
  end

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

  def self.cached_filename_for(identifier)
    return nil unless identifier
    "#{self.to_s}_#{Digest::SHA256.hexdigest identifier}"
  end
end
# vim: ts=2 sw=2
# encoding: utf-8
