bel ruby
========

[![Gem Version](https://badge.fury.io/rb/bel.svg)](http://badge.fury.io/rb/bel)

[![Changelog](https://img.shields.io/badge/bel.rb-changelog-brightgreen.svg)](https://github.com/OpenBEL/bel.rb/blob/master/CHANGELOG.md)

[![Issues](https://img.shields.io/github/issues/OpenBEL/bel.rb.svg)](https://github.com/OpenBEL/bel.rb/issues)

[![Dependencies](https://img.shields.io/gemnasium/OpenBEL/bel.rb.svg)]()

[![Join the chat at https://gitter.im/OpenBEL/bel.rb](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/OpenBEL/bel.rb?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The bel ruby gem allows the reading, writing, and processing of BEL (Biological Expression Language) with a natural DSL.

Learn more on [BEL](http://www.openbel.org/content/bel-lang-language).

License: [Apache License, Version 2.0](http://opensource.org/licenses/Apache-2.0)

Dependencies

- Required

    - Ruby 2.0.0 or greater ([how to install ruby](INSTALL_RUBY.md))

- Optional

    - *rdf gem*, *addressable gem*, and *uuid gem* for RDF conversion
    - *rdf-turtle gem* for serializing to RDF turtle format

Install / Build: See [INSTALL](INSTALL.md).

A changelog is maintained at [CHANGELOG][CHANGELOG].

development
-----------

Developing on bel.rb requires a few steps.

1. [Install Ruby](INSTALL_RUBY.md).
2. Clone this repository:

    ```
    git@github.com:OpenBEL/bel.rb.git
    ```

3. Install bundler to pull in project dependencies.

    ```
    gem install bundler
    ```

4. Change to repository directory. Install bel.rb's dependencies (including development dependencies):

    ```
    cd bel.rb; bundle install
    ```

5. Build C extension (i.e. [libbel parser](https://github.com/OpenBEL/libbel)) using Rake:

    ```
    rake compile
    ```

  This will build the C shared library you will need to use the C-based parser.

  Note: Windows users will need to install the [RubyInstaller DevKit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) to build the C extension.

branches
--------

- master branch
  - Contains stable code. Releases are created from this branch using a tag (e.g. 0.3.3).
  - [![Travis CI Build](https://travis-ci.org/OpenBEL/bel.rb.svg?branch=master)](https://travis-ci.org/OpenBEL/bel.rb)

- next branch
  - Contains unstable code. Commits should be merged into master after it stabilizes.
  - [![Build Status for next branch](https://travis-ci.org/OpenBEL/bel.rb.svg?branch=next)](https://travis-ci.org/OpenBEL/bel.rb)

contributors
------------

- [@abargnesi](https://github.com/abargnesi) (Maintainer)
- [@nbargnesi](https://github.com/nbargnesi) (Maintainer)
- [@ncatlett](https://github.com/ncatlett)   (Contributor)
- [@wshayes](https://github.com/wshayes)     (Contributor)

executable commands
-------------------

**bel**: A single executable command with subcommands.

```bash

    Usage: bel [OPTIONS]... COMMAND
    A set of commands to process BEL knowledge.

    Subcommands:

      bel2rdf
      compare
      parse
      rdfschema
      summarize
      translate
      upgrade


    bel 0.3.3
    Copyright (C) 2015 OpenBEL
    Apache License, Version 2.0, January 2004
    http://www.apache.org/licenses/

    Options:
      -v, --verbose    Verbose output.
      -e, --version    Print version and exit
      -h, --help       Show this message
```


**bel2rdf.rb**: Converts BEL to RDF.

```bash

    # dumps RDF to standard out in ntriples format (default)
    #   (from file)
    bel2rdf.rb --bel small_corpus.bel

    #   (from standard in)
    cat small_corpus.bel | bel2rdf.rb

    # dumps RDF to standard out in turtle format
    #   (from file)
    bel2rdf.rb --bel small_corpus.bel --format turtle

    #   (from standard in)
    cat small_corpus.bel | bel2rdf.rb --format turtle
```


**bel_compare.rb**: Compares knowledge in two BEL script files.

```bash

    bel_compare.rb small_corpus.bel large_corpus.bel
```


**bel_parse.rb**: Show parsed objects from BEL content for debugging purposes

```bash

    # ...from file
    bel_parse.rb --bel small_corpus.bel

    # ...from standard in
    cat small_corpus.bel | bel_parse.rb
```


**bel_rdfschema.rb**: Dumps the RDF Schema triples for BEL.

```bash

    # dumps schema in ntriples format (default)
    bel_rdfschema.rb

    # dumps schema in turtle format
    # note: requires the 'rdf-turtle' gem
    bel_rdfschema.rb --format turtle
```


**bel_summarize.rb**: Show summary statistics for knowledge in BEL script.

```bash
    # using BEL file
    bel_summarize.rb --bel small_corpus.bel

    # using BEL from STDIN
    cat small_corpus.bel | bel_summarize.rb
```


**bel_upgrade.rb**: Upgrade namespaces in BEL content to another version (i.e. *1.0* to *20131211*)

```bash

    # using BEL file and change log JSON file
    bel_upgrade.rb --bel small_corpus.bel --changelog change_log.json

    # using BEL file and change log from a URL
    bel_upgrade.rb --bel small_corpus.bel --changelog http://resource.belframework.org/belframework/20131211/change_log.json

    # using BEL from STDIN and change log from a URL
    cat small_corpus.bel | bel_upgrade.rb --changelog http://resource.belframework.org/belframework/20131211/change_log.json
```


api examples
------------

**Use OpenBEL namespaces from the latest release.**

```ruby

    require 'bel'
  
    # reference namespace value using standard prefixes (HGNC, MGI, RGD, etc.)
    HGNC['AKT1']
    => #<BEL::Model::Parameter:0x00000004df5bc0
      @enc=:GRP,
      @ns_def="BEL::Namespace::HGNC",
      @value=:AKT1>
```

**Load your own namespace**

```ruby

    require 'bel'

    # define a NamespaceDefinition with prefix symbol and url
    PUBCHEM = NamespaceDefinition.new(:PUBCHEM, 'http://your-url.org/pubchem.belns')

    # reference caffeine compound, sip, and enjoy
    PUBCHEM['2519']
```

**Load namespaces from a published OpenBEL version**

```ruby

    require 'bel'

    ResourceIndex.openbel_published_index('1.0').namespaces.find { |x| x.prefix == :HGU133P2 }
    ResourceIndex.openbel_published_index('20131211').namespaces.find { |x| x.prefix == :AFFX }
    ResourceIndex.openbel_published_index('latest-release').namespaces.find { |x| x.prefix == :AFFX }
```

**Load namespaces from a custom resource index**

```ruby

    require 'bel'

    ResourceIndex.new('/home/bel/index.xml').namespaces.map(&:prefix)
    => ["AFFX", "CHEBIID", "CHEBI", "DOID", "DO", "EGID", "GOBPID", "GOBP",
        "GOCCID", "GOCC", "HGNC", "MESHPP", "MESHCS", "MESHD", "MGI", "RGD",
        "SCHEM", "SDIS", "SFAM", "SCOMP", "SPAC", "SP"]
```

**Validate BEL parameters**

```ruby

    require 'bel'

    # AKT1 contained within HGNC NamespaceDefinition
    HGNC[:AKT1].valid?
    => true

    # not_in_namespace is not contained with HGNC NamespaceDefinition
    HGNC[:not_in_namespace].valid?
    => false

    # namespace is nil so :some_value MAY exist
    Parameter.new(nil, :some_value).valid?
    => true
```

**Validate BEL terms**

```ruby

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
```

**Write BEL in Ruby with a DSL**

```ruby

    require 'bel'
    
    # create BEL statements
    p(HGNC['SKIL']).directlyDecreases tscript(p(HGNC['SMAD3']))
    bp(GO['response to hypoxia']).increases tscript(p(EGID['7157']))
```

**Parse BEL input**

```ruby

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
```

**Iteratively parse BEL from file-like object**

```ruby

    require 'bel'
    BEL::Script.parse(File.open('/home/user/small_corpus.bel')).find_all { |obj|
      obj.is_a? Statement
    }.to_a.size
```

**Parse BEL and convert to RDF (requires the *rdf*, *addressable*, and *uuid* gems)**

```ruby

    require 'bel'
    parser = BEL::Script::Parser.new

    rdf_statements = []

    # parse term
    parser.parse('p(HGNC:AKT1)') do |obj|
      if obj.is_a? BEL::Model::Term  
        rdf_statements += obj.to_rdf
      end  
    end

    # parse statement
    parser.parse("p(HGNC:AKT1) => tscript(g(HGNC:TNF))\n") do |obj|
      if obj.is_a? BEL::Model::Statement
        rdf_statements += obj.to_rdf
      end  
    end
```

[CHANGELOG]: https://github.com/OpenBEL/bel.rb/blob/master/CHANGELOG.md
