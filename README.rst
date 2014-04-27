bel
===

.. image:: https://badge.fury.io/rb/bel.png
    :target: http://badge.fury.io/rb/bel
.. image:: https://travis-ci.org/OpenBEL/bel.rb.svg?branch=master
    :target: https://travis-ci.org/OpenBEL/bel.rb

The bel ruby gem allows the reading, writing, and processing of BEL (Biological Expression Language) with a natural DSL.

Check out INSTALL_RUBY_...for how to install Ruby!

Learn more on BEL_.

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

Load any standard namespace

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

Load namespaces from a resource index

.. code-block:: ruby

  require 'bel'

  index = ResourceIndex.new('http://resource.belframework.org/belframework/20131211/index.xml')
  index.namespaces.find { |x| x.prefix == :AFFX }

Write BEL in Ruby with a DSL

.. code-block:: ruby

  require 'bel'
  
  # create BEL statements
  p(HGNC['SKIL']).directlyDecreases tscript(p(HGNC['SMAD3']))
  bp(GO['response to hypoxia']).increases tscript(p(EGID['7157']))

Validate BEL terms

.. code-block:: ruby

  require 'bel'

  # boolean validation of constructed term
  tscript(g(HGNC['AKT1'])).validate_signature
  => false
  complex(NCH['AP-1 Complex']).validate_signature
  => true

  # yield invalid terms to block
  tscript(g(HGNC['AKT1'])).validate_signature do |term, allowed_signatures|
    puts "#{term}, #{allowed_signatures}"
  end
  tscript(g(HGNC:AKT1)), [tscript(F:complex)a, tscript(F:p)a]
  => false

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

  # include BEL Script module
  include BEL::Script

  # create parser
  parser = BEL::Script::Parser.new

  # parse; yield each parsed object to the block
  parser.parse(BEL_SCRIPT) do |obj|
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
  => :update

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

.. _BEL: http://www.openbel.org/content/bel-lang-language
.. _resource: http://resource.belframework.org/belframework/1.0/namespace/
.. _bel_upgrade: https://github.com/OpenBEL/bel.rb/blob/master/bin/bel_upgrade
.. _bel_rdfschema: https://github.com/OpenBEL/bel.rb/blob/master/bin/bel_upgrade
.. _bel2rdf: https://github.com/OpenBEL/bel.rb/blob/master/bin/bel2rdf
.. _INSTALL_RUBY: https://github.com/OpenBEL/bel.rb/blob/master/INSTALL_RUBY.md
