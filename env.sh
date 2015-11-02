#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Pull in standard functions, e.g., default.
source "$DIR/.gosh.sh" || return 1
default CUSTOM_ENV_SH "$DIR/env.sh.custom"
assert-source "$CUSTOM_ENV_SH" || return 1

### PATHS ###
default BR_DIR      "$DIR"
default BR_SCRIPTS  "$BR_DIR"/scripts
# Override BR_GEM_DIR to control where bel.rb dependencies are isolated.
default BR_GEM_DIR  "$BR_DIR"/.gems

### COMMANDS ###
# Override BR_GEM_CMD to target a specific version (e.g., gem2.0).
default BR_GEM_CMD  "gem"
# Override BR_RUBY_CMD to target a specific version (e.g., ruby2.0).
default BR_RUBY_CMD "ruby"

### BEL.RB GEM OPTIONS ###
# default BR_GEM_BUILD_OPTS   "--verbose"
# default BR_GEM_INSTALL_OPTS "--no-document"

### GENERAL OPTIONS ###
# Set BR_ISOLATE to "yes" to isolate bel.rb from the user's gems.
# The default uses the current RubyGems configuration.
default BR_ISOLATE  "no"
# Contains bel.rb development dependencies. Defaults to one of the three
# supported dependency files used by modern Ruby installations (gem.deps.rb).
default BR_DEV_DEPS "$BR_DIR"/gem.deps.rb

### THE GO SHELL ###
default GOSH_SCRIPTS    "$BR_DIR"/scripts
default GOSH_PROMPT     "bel.rb (?|#|#?)> "
