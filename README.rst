bel
===

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


.. _BEL: http://www.openbel.org/content/bel-lang-language
.. _resource: http://resource.belframework.org/belframework/1.0/namespace/
