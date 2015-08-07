# Change Log
All notable changes to bel.rb will be documented in this file. The curated log begins at changes to version 0.3.2.

This project adheres to [Semantic Versioning](http://semver.org/).

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
[68]:       https://github.com/OpenBEL/bel.rb/issues/68
[20150611]: http://resource.belframework.org/belframework/20150611/
