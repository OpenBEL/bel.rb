# Change Log
All notable changes to bel.rb will be documented in this file. The curated log begins at changes to version 0.3.2.

This project adheres to [Semantic Versioning](http://semver.org/).

## [0.6.0][0.6.0] - 2016-03-15
### Fixed
- Serialization of BEL Script / XBEL can produce incorrect annotation and namespaces references ([Issue #111][111]).

### Changed
- Separate random sampling from random data in BEL generator ([Issue #105][105]).
- Improved BEL quoting API. **Deprecated previous API methods.** ([Issue #104][104]).
- BEL and XBEL translators will now buffer on write to account for all annotation/namespace references. Pass the `-t streaming=true` option to `bel translate` to stream data when the references are consistent.

### Added
- Added translator read/write option passing from the `bel translate` subcommand.

### Development
- Added *doctest* Rake task to run YARD `@example` tests in method level documentation.

## [0.5.0][0.5.0] - 2016-02-10
### Fixed
- Fix missing RDF prefixes when converting BEL Script to RDF ([Issue #71][71]).
- Error translating to JSON Evidence format using Oj adapter ([Issue #93][93]).
- Consistent representation of Annotation and Namespace references in Evidence model and translators ([Issue #94][94]).
- RDF conversion of Parameter does not include encoding type statement ([Issue #96][96]).
### Added
- Introduced translators for additional RDF formats; split and removed the RDF translator in favor of one translator per RDF format ([Issue #95][95]).
- Warn when BEL namespace data could not be retrieved ([Issue #97][97]).
- Added generator for random BEL Nanopubs using the *bel generate* subcommand ([Issue #102][102]).
- Access BEL annotation resource values from external *.belanno* files ([Issue #100][100]).
- Support different types of serialization within the BEL Script translator ([Issue #98][98]).

## [0.4.2][0.4.2] - 2015-12-21
### Fixed
- [Regression] Failure to run BEL upgrade command; yields name error ([Issue #90][90]).
- [Regression] Incorrect namespace concept URI when converting Term to RDF ([Issue #91][91]).

## [0.4.1][0.4.1] - 2015-12-17
### Added
- Updated `find` API of `BEL::Resource::Namespaces` and `BEL::Resource::Namespace` to find by string representing a URI.

### Fixed
- [Development] Install `pry-byebug` only for `ruby` platforms. This allows development on JRuby.
- [Development] No-op `rake compile` when running on JRuby. Report informative message when compiling on JRuby.

### Changed
- Complete BEL namespaces and namespace values using the Namespaces API backed by RDF data.
- Enable :exclude_identifier_schemes option for BEL completion to disallow namespace value results that report an identifier as their preferred name. This is allowed if the namespace prefix is first provided (e.g. "EG:AKT" will find "EG:207").

## [0.4.0][0.4.0] - 2015-12-14
### Fixed
- Improved conversion of evidence to JSON Evidence format.
- Fixed inclusion of BEL dsl (domain-specific language) extensions into all objects. The dsl methods can now be added to the BEL::Language module with BEL::Language.include_bel_dsl.

### Changed
- [Development] Removed bundler in favor or rubygems for dependency management ([Issue #82][82]).
- Implement new plugin mechanism ([Issue #86][86]).
- Implement translator plugins using new plugin mechanism. These were previously called Format Extensions ([Issue #86][86]).

### Added
- Added JSON read/write abstraction to support JSON streaming capabilities if the adapter supports it (see BEL::JSON).
- Implement a translate API which allows reading evidence and translating to other formats (see BEL#evidence, BEL#translate).
- BEL translator "write" can now yield to block or return an enumerator over translated evidence. This allows the user to control how the output is written to IO.
- Added a new "plugins" subcommand to the bel executable that lists the plugins available to bel.rb. Run with "bel plugins --list".
- Added RDF Repository plugin type. This allows RDF datasources to be integrated into bel.rb. The RDF Repository abstraction is provided by [RDF.rb][RDF.rb]. The initial use is with the Namespace and Annotation APIs. Plugins are provided for Apache Jena (TDB) and MongoDB RDF datasources.
- Added Namespace and Annotation APIs to provide access to biological identifiers within an RDF Repository.
- Added Resource Search API plugin type. This provides an API to full-text search over Namespaces and Annotations include symbols, identifiers, titles, and synonyms. A plugin named "bel.rb-search-sqlite" was created built on SQLite's full-text search.
- Added option to RDF translator plugin to write out evidence as a VoID dataset ([Issue #66][66]).

## [0.3.3][0.3.3] - 2015-08-07
### Fixed
- ResourceIndex integration test causes intermittent timeouts ([Issue #61][61]).
- Support running on JRuby, including libbel native library ([Issue #68][68]).

## [0.3.2][0.3.2] - 2015-07-31
### Fixed
- Allow whitespace (space/tab) within blank lines ([Issue #13][13]).
- Parse CRLF line terminators (i.e. Windows) when parsing BEL Script ([Issue #21][21]).
- Allow whitespace before BEL Script records ([Issue #25][25]).
- Support RDF conversion of unicode string literals ([Issue #40][40]).
- Support translation from and to RDF ([Issue #51][51]).
- (Regression) Unable to parse BEL files on Windows ([Issue #59][59]).
- RDF "hasConcept" property triple is missing namespace ([Issue #64][64]).

### Changed
- Updates defined namespaces to reflect the [20150611][20150611] resources.
- Full support for all BEL functions and relationships during RDF conversion.

### Added
- Development gem dependencies (i.e. byebug, pry, pry-byebug) for debugging.

[0.6.0]:    https://github.com/OpenBEL/bel.rb/compare/0.5.0...0.6.0
[0.5.0]:    https://github.com/OpenBEL/bel.rb/compare/0.4.2...0.5.0
[0.4.2]:    https://github.com/OpenBEL/bel.rb/compare/0.4.1...0.4.2
[0.4.1]:    https://github.com/OpenBEL/bel.rb/compare/0.4.0...0.4.1
[0.4.0]:    https://github.com/OpenBEL/bel.rb/compare/0.3.3...0.4.0
[0.3.2]:    https://github.com/OpenBEL/bel.rb/compare/0.3.1...0.3.2
[0.3.3]:    https://github.com/OpenBEL/bel.rb/compare/0.3.2...0.3.3
[13]:       https://github.com/OpenBEL/bel.rb/issues/13
[21]:       https://github.com/OpenBEL/bel.rb/issues/21
[25]:       https://github.com/OpenBEL/bel.rb/issues/25
[40]:       https://github.com/OpenBEL/bel.rb/issues/40
[51]:       https://github.com/OpenBEL/bel.rb/issues/51
[59]:       https://github.com/OpenBEL/bel.rb/issues/59
[61]:       https://github.com/OpenBEL/bel.rb/issues/61
[64]:       https://github.com/OpenBEL/bel.rb/issues/64
[66]:       https://github.com/OpenBEL/bel.rb/issues/66
[68]:       https://github.com/OpenBEL/bel.rb/issues/68
[71]:       https://github.com/OpenBEL/bel.rb/issues/71
[82]:       https://github.com/OpenBEL/bel.rb/issues/82
[86]:       https://github.com/OpenBEL/bel.rb/pull/86
[90]:       https://github.com/OpenBEL/bel.rb/issues/90
[91]:       https://github.com/OpenBEL/bel.rb/issues/91
[93]:       https://github.com/OpenBEL/bel.rb/issues/93
[94]:       https://github.com/OpenBEL/bel.rb/issues/94
[95]:       https://github.com/OpenBEL/bel.rb/issues/95
[96]:       https://github.com/OpenBEL/bel.rb/issues/96
[97]:       https://github.com/OpenBEL/bel.rb/issues/97
[98]:       https://github.com/OpenBEL/bel.rb/issues/98
[100]:      https://github.com/OpenBEL/bel.rb/issues/100
[102]:      https://github.com/OpenBEL/bel.rb/issues/102
[104]:      https://github.com/OpenBEL/bel.rb/issues/104
[105]:      https://github.com/OpenBEL/bel.rb/issues/105
[111]:      https://github.com/OpenBEL/bel.rb/issues/111
[20150611]: http://resource.belframework.org/belframework/20150611/
[RDF.rb]:   https://github.com/ruby-rdf/rdf
