#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Pull in standard functions, e.g., default.
source "$DIR/.gosh.sh" || return 1
default CUSTOM_ENV_SH "$DIR/env.sh.custom"
assert-source "$CUSTOM_ENV_SH" || return 1

### PATHS ###
default DIR             "$DIR"
default BUILD           "$DIR"/build
default SCRIPTS         "$DIR"/scripts

### OPTIONS ###
#default GEM_BUILD_OPTS      "--verbose"
#default GEM_INSTALL_OPTS    "--no-document"

### THE GO SHELL ###
default GOSH_SCRIPTS    "$DIR"/scripts
default GOSH_PROMPT     "bel.rb (?|#|#?)> "

