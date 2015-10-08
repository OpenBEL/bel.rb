#!/usr/bin/env ruby

require 'bel'
resource_version = ARGV[0]
unless resource_version
    resource_version = "latest-release"
end
# BEL document header
output_filename = "template_#{resource_version}.bel"
document_properties = {
  Name: "BEL_DOCUMENT_NAME",
  Description: "BEL_DOCUMENT_DESCRIPTION",
  Licenses: "Creative Commons Atribution-Share Alike 3.0 Unported License",
  Authors: "AUTHORS",
  Copyright: "Copyright (c) DATE, AUTHORS. All Rights Reserved.",
  Version: "VERSION",
  ContactInfo: "CONTACT_EMAIL"
}

f = File.open(output_filename, 'w')
f.puts('#'*50)
f.puts("# Document Properties Section")
document_properties.each do |type, value|
  f.puts DocumentProperty.new(type, value).to_bel
end

# Namespace definitions
resource_index = ResourceIndex.openbel_published_index(resource_version)
f.puts('#'*50)
f.puts("# Definitions Section")
resource_index.namespaces.each do |n|
    f.puts n.to_bel
  end
f.puts
resource_index.annotations.each do |a|
    f.puts a.to_bel
end
f.puts('#'*50)
f.puts("# Statements Section")
f.close
