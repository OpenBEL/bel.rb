require 'pry'
require_relative '../format'
require_relative 'xbel'
require 'bel'

include BEL::Extension::Format
include ::BEL::Language

FormatXBEL.new.deserialize(File.open(ARGV[0])).each do |part|
  if part.respond_to? :to_bel
    puts part.to_bel
  else
    puts part.inspect
  end
end
