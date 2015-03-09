#!/usr/bin/env ruby

require 'bel'
require 'open-uri'


def get_egid(tfid)
	# get EGID for tfid
	url = open("http://www.cisreg.ca/cgi-bin/tfe/api.pl?tfid=#{tfid}&code=entrez-gene-id")
	egid = url.read.strip
end

def get_targets(tfid)
	# get targets for tfid
	targets = Array.new()
	headers = [:egid, :symbol, :tf_complex, :effect, :pmid, :source]
	url = open("http://www.cisreg.ca/cgi-bin/tfe/api.pl?tfid=#{tfid}&code=targets")
	url.read.split("\n").each do |line|
		targets.push(Hash[headers.zip(line.split("\t"))])
		end
	return targets
end

def citation_anno(pmid)
	# make citation annotation from PMID
	anno = Annotation.new("Citation", ['"PubMed"', '"title"', "#{pmid}"])
end

# document header
namespaces = ['EGID'] # array of namespaces used, by prefix
today = Date.today.to_s.delete("-")
output_filename = "tfe_#{today}.bel"
document_properties = {
	"Name" => "Transcription Factor Encyclopedia translation to BEL",
	"Description" => "Conversion of Transcription Factor Encyclopedia targets to BEL. Citation = Yusuf et al. The Transcription Factor Encyclopedia. Genome Biology 13:R24 (2012). Pubmed ID 22458515",
	"Licenses" => "Creative Commons Atribution-Share Alike 3.0 Unported License",
	"Version" => today,
	"ContactInfo" => "info@openbel.org"
}

f = File.open(output_filename, 'w')
f.puts('#'*20)
f.puts("# Document Properties Section")
document_properties.each do |type, value|
	f.puts DocumentProperty.new(type, value).to_bel
end

# Namespace definitions
resource_index = ResourceIndex.openbel_published_index("20131211")
f.puts('#'*20)
f.puts("# Definitions Section")
resource_index.namespaces.each do |n|
       	if namespaces.include? n.to_s
		f.puts n.to_bel
	end
end

# get list of tfs by tfid
tfids = open("http://www.cisreg.ca/cgi-bin/tfe/api.pl?code=all-tfids")
tfids = tfids.read.split("\n")

# for each tfid, get targets and create BEL statements if targets are from source=user and have an associated direction
f.puts('#'*20)
f.puts("# Statements Section")
tfids.each do |tfid|
	evidence_text = Annotation.new("Evidence", "Targets from Transcription Factor Encyclopedia article for tfid##{tfid}")
	source_term = tscript(p(EGID[get_egid(tfid)]))
	targets = get_targets(tfid)
	if targets.length >0
		f.puts evidence_text.to_bel
		targets.each do |target|
			if target[:source].strip == 'user' and not target[:effect].empty?
				target_term = r(EGID[target[:egid]])
				if target[:effect].start_with?("UP")
					relationship = :directlyIncreases
				elsif target[:effect].start_with?("DOWN")
					relationship = :directlyDecreases
				else
					puts "WARNING! Can't translate #{target[:effect]} to BEL relationship"
					relationship = :association
				end
				statement = Statement.new(source_term, relationship, target_term)
				# make new statement for each PMID provided
				target[:pmid].split(",").each do |pmid|
					citation = citation_anno(pmid)
				f.puts citation.to_bel
				f.puts statement.to_bel
				end
			end
		end
	end
end
f.close
		
