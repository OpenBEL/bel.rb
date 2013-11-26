bel
===

.. image:: https://badge.fury.io/rb/bel.png
    :target: http://badge.fury.io/rb/bel

The bel gem allows the reading, writing, and processing of BEL (Biological Expression Language) with a natural DSL.

Learn more on BEL_.

examples
--------

Load any standard namespace

.. code-block:: ruby

  require 'bel'
  # include namespace module in current scope
  include BEL::Namespace 
  
  # reference namespace value using standard prefixes (HGNC, MGI, RGD, etc.)
  HGNC['AKT1']
  => #<BEL::Language::Parameter:0x00000004df5bc0
   @enc=:GRP,
   @ns_def="BEL::Namespace::HGNC",
   @value=:AKT1>

Load your own namespace

.. code-block:: ruby

  require 'bel'
  # include namespace module in current scope
  include BEL::Namespace

  # define a NamespaceDefinition with prefix symbol and url
  PUBCHEM = NamespaceDefinition.new(:PUBCHEM, 'http://your-url.org/pubchem.belns')

  # reference caffeine compound, sip, and enjoy
  PUBCHEM['2519']

Write BEL in Ruby with a DSL

.. code-block:: ruby

  require 'bel'
  
  # include modules in current scope
  include BEL::Language
  include BEL::Namespace
  
  # create BEL statements
  p(HGNC['SKIL']).directlyDecreases tscript(p(HGNC['SMAD3']))
  bp(GO['response to hypoxia']).increases tscript(p(EGID['7157']))

Validate BEL terms

.. code-block:: ruby

  require 'bel'

  # include modules in current scope
  include BEL::Language
  include BEL::Namespace

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

.. _BEL: http://www.openbel.org/content/bel-lang-language
.. _resource: http://resource.belframework.org/belframework/1.0/namespace/
