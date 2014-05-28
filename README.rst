bel
===

.. image:: https://badge.fury.io/rb/bel.png
    :target: http://badge.fury.io/rb/bel
.. image:: https://travis-ci.org/OpenBEL/bel.rb.svg?branch=master
    :target: https://travis-ci.org/OpenBEL/bel.rb

The bel ruby gem allows the reading, writing, and processing of BEL (Biological Expression Language) with a natural DSL.

Learn more on BEL_.

License: `Apache License, Version 2.0`_

Dependencies

* Required
   * Ruby 1.9.2 or greater (`how to install ruby`_)
* Optional
   * `rdf gem`_ and `addressable gem`_ for BEL_ to RDF_ conversion
   * `rdf-turtle gem`_ for serializing to `turtle`_ format

Install / Build: See `INSTALL`_.


executable commands
-------------------

bel_upgrade_: Upgrade namespaces in BEL content to another version (e.g. `1.0` to `20131211`)

.. code-block:: bash

  # using BEL file and change log JSON file
  bel_upgrade --bel small_corpus.bel --changelog change_log.json

  # using BEL file and change log from a URL
  bel_upgrade --bel small_corpus.bel --changelog http://resource.belframework.org/belframework/20131211/change_log.json

  # using BEL from STDIN and change log from a URL
  cat small_corpus.bel | bel_upgrade --changelog http://resource.belframework.org/belframework/20131211/change_log.json

bel_rdfschema_: Dumps the RDF Schema triples for BEL.

.. code-block:: bash

  # dumps schema in ntriples format (default)
  bel_rdfschema

  # dumps schema in turtle format
  # note: requires the 'rdf-turtle' gem
  bel_rdfschema --format turtle

bel2rdf_: Converts BEL to RDF.

.. code-block:: bash

  # dumps RDF to standard out in ntriples format (default)
  #   (from file)
  bel2rdf --bel small_corpus.bel

  #   (from standard in)
  cat small_corpus.bel | bel2rdf

  # dumps RDF to standard out in turtle format
  #   (from file)
  bel2rdf --bel small_corpus.bel --format turtle

  #   (from standard in)
  cat small_corpus.bel | bel2rdf --format turtle


api examples
------------

Use OpenBEL namespaces from the latest release.

.. code-block:: ruby

  require 'bel'
  
  # reference namespace value using standard prefixes (HGNC, MGI, RGD, etc.)
  HGNC['AKT1']
  => #<BEL::Language::Parameter:0x00000004df5bc0
   @enc=:GRP,
   @ns_def="BEL::Namespace::HGNC",
   @value=:AKT1>

Load your own namespace

.. code-block:: ruby

  require 'bel'

  # define a NamespaceDefinition with prefix symbol and url
  PUBCHEM = NamespaceDefinition.new(:PUBCHEM, 'http://your-url.org/pubchem.belns')

  # reference caffeine compound, sip, and enjoy
  PUBCHEM['2519']

Load namespaces from a published OpenBEL version

.. code-block:: ruby

  require 'bel'

  ResourceIndex.openbel_published_index('1.0').namespaces.find { |x| x.prefix == :HGU133P2 }
  ResourceIndex.openbel_published_index('20131211').namespaces.find { |x| x.prefix == :AFFY }
  ResourceIndex.openbel_published_index('latest-release').namespaces.find { |x| x.prefix == :AFFY }

Load namespaces from a custom resource index

.. code-block:: ruby

  require 'bel'

  ResourceIndex.new('/home/bel/index.xml').namespaces.map(&:prefix)
  => ["AFFX", "CHEBIID", "CHEBI", "DOID", "DO", "EGID", "GOBPID", "GOBP",
      "GOCCID", "GOCC", "HGNC", "MESHPP", "MESHCS", "MESHD", "MGI", "RGD",
      "SCHEM", "SDIS", "SFAM", "SCOMP", "SPAC", "SP"]

Write BEL in Ruby with a DSL

.. code-block:: ruby

  require 'bel'
  
  # create BEL statements
  p(HGNC['SKIL']).directlyDecreases tscript(p(HGNC['SMAD3']))
  bp(GO['response to hypoxia']).increases tscript(p(EGID['7157']))

Validate BEL terms

.. code-block:: ruby

  require 'bel'

  tscript(g(HGNC['AKT1'])).valid?
  => false
  tscript(g(HGNC['AKT1'])).valid_signatures
  => []
  tscript(g(HGNC['AKT1'])).invalid_signatures.map(&:to_s)
  => ["tscript(F:complex)a", "tscript(F:p)a"]

  tscript(p(HGNC['AKT1'])).valid?
  => true
  tscript(p(HGNC['AKT1'])).valid_signatures.map(&:to_s)
  => ["tscript(F:p)a"]
  tscript(p(HGNC['AKT1'])).invalid_signatures.map(&:to_s)
  => ["tscript(F:complex)a"]

Parse BEL input

.. code-block:: ruby

  require 'bel'

  # example BEL document
  BEL_SCRIPT = <<-EOF
  SET DOCUMENT Name = "Spec"
  SET DOCUMENT Authors = User
  SET Disease = "Atherosclerosis"
  path(MESHD:Atherosclerosis)
  path(Atherosclerosis)
  bp(GO:"lipid oxidation")
  p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473))
  path(MESHD:Atherosclerosis) => bp(GO:"lipid oxidation")
  path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GO:"apoptotic process"))
  EOF

  # BEL::Script.parse returns BEL::Script::Parser
  BEL::Script.parse('tscript(p(HGNC:AKT1))')
  => #<BEL::Script::Parser:0x007f179261d270>

  # BEL::Script::Parser is Enumerable so we can analyze as we parse
  #   for example: count all function types into a hash
  BEL::Script.parse('tscript(p(HGNC:AKT1))', {HGNC: HGNC}).find_all { |obj|
    obj.is_a? Term
  }.map { |term|
    term.fx  
  }.reduce(Hash.new {|h,k| h[k] = 0}) { |result, function|  
    result[function.short_form] += 1  
    result
  }
  => {:p=>1, :tscript=>1} 

  # parse; yield each parsed object to the block
  namespace_mapping = {GO: GOBP, HGNC: HGNC, MGI: MGI, MESHD: MESHD}
  BEL::Script.parse(BEL_SCRIPT, namespace_mapping) do |obj|
    puts "#{obj.class} #{obj}"  
  end
  => BEL::Script::DocumentProperty: SET DOCUMENT Name = "Spec"
  => BEL::Script::DocumentProperty: SET DOCUMENT Authors = "User"
  => BEL::Script::Annotation: SET Disease = "Atherosclerosis"
  => BEL::Script::Parameter: MESHD:Atherosclerosis
  => BEL::Script::Term: path(MESHD:Atherosclerosis)
  => BEL::Script::Statement: path(MESHD:Atherosclerosis)
  => BEL::Script::Parameter: Atherosclerosis
  => BEL::Script::Term: path(Atherosclerosis)
  => BEL::Script::Statement: path(Atherosclerosis)
  => BEL::Script::Parameter: GO:"lipid oxidation"
  => BEL::Script::Term: bp(GO:"lipid oxidation")
  => BEL::Script::Statement: bp(GO:"lipid oxidation")
  => BEL::Script::Parameter: MGI:Mapkap1
  => BEL::Script::Term: p(MGI:Mapkap1)
  => BEL::Script::Parameter: MGI:Akt1
  => BEL::Script::Parameter: P
  => BEL::Script::Parameter: S
  => BEL::Script::Parameter: 473
  => BEL::Script::Term: p(MGI:Akt1,pmod(P,S,473))
  => BEL::Script::Statement: p(MGI:Mapkap1) -> p(MGI:Akt1,pmod(P,S,473))
  => BEL::Script::Parameter: MESHD:Atherosclerosis
  => BEL::Script::Term: path(MESHD:Atherosclerosis)
  => BEL::Script::Parameter: GO:"lipid oxidation"
  => BEL::Script::Term: bp(GO:"lipid oxidation")
  => BEL::Script::Statement: path(MESHD:Atherosclerosis) => bp(GO:"lipid oxidation")
  => BEL::Script::Parameter: MESHD:Atherosclerosis
  => BEL::Script::Term: path(MESHD:Atherosclerosis)
  => BEL::Script::Parameter: HGNC:MYC
  => BEL::Script::Term: p(HGNC:MYC)
  => BEL::Script::Parameter: GO:"apoptotic process"
  => BEL::Script::Term: bp(GO:"apoptotic process")
  => BEL::Script::Statement: path(MESHD:Atherosclerosis) =| (p(HGNC:MYC) -> bp(GO:"apoptotic process"))

Iteratively parse BEL from file-like object

.. code-block:: ruby

  require 'bel'
  BEL::Script.parse(File.open('/home/user/small_corpus.bel')).find_all { |obj|
    obj.is_a? Statement
  }.to_a.size

Parse BEL and convert to RDF (requires the 'rdf' and 'addressable' gems)

.. code-block:: ruby

  require 'bel'
  parser = BEL::Script::Parser.new

  rdf_statements = []

  # parse term
  parser.parse('p(HGNC:AKT1)') do |obj|
    if obj.is_a? BEL::Language::Term  
      rdf_statements += obj.to_rdf
    end  
  end

  # parse statement
  parser.parse("p(HGNC:AKT1) => tscript(g(HGNC:TNF))\n") do |obj|
    if obj.is_a? BEL::Language::Statement
      rdf_statements += obj.to_rdf
    end  
  end

.. _Apache License, Version 2.0: http://opensource.org/licenses/Apache-2.0
.. _rdf gem: https://rubygems.org/gems/rdf
.. _addressable gem: https://rubygems.org/gems/addressable
.. _rdf-turtle gem: https://rubygems.org/gems/rdf-turtle
.. _turtle: http://www.w3.org/TR/2014/REC-turtle-20140225
.. _BEL: http://www.openbel.org/content/bel-lang-language
.. _RDF: http://www.w3.org/RDF
.. _INSTALL: https://github.com/OpenBEL/bel.rb/blob/master/INSTALL.rst
.. _resource: http://resource.belframework.org/belframework/1.0/namespace/
.. _bel_upgrade: https://github.com/OpenBEL/bel.rb/blob/master/bin/bel_upgrade
.. _bel_rdfschema: https://github.com/OpenBEL/bel.rb/blob/master/bin/bel_upgrade
.. _bel2rdf: https://github.com/OpenBEL/bel.rb/blob/master/bin/bel2rdf
.. _how to install ruby: https://github.com/OpenBEL/bel.rb/blob/master/INSTALL_RUBY.md
