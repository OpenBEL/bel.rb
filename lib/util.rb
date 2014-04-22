require 'open-uri'

module BEL

  def self.read_all(reference)
    self.multi_open(reference) do |f|
      return f.read
    end
  end

  def self.multi_open(reference)
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
end
# vim: ts=2 sw=2
# encoding: utf-8
