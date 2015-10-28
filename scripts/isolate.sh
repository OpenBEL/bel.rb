#!/usr/bin/env bash
# Sets environment variables that isolate bel.rb Ruby gems from all others.
#
# This script will have the following affect on the gem environment:
#
# INSTALLATION DIRECTORY
#   Set to $BR_GEM_DIR
#
# EXECUTABLE DIRECTORY
#   Set to $BR_GEM_DIR/bin
#
# SPEC CACHE DIRECTORY
#   Set to $BR_GEM_DIR/specs
#
# GEM PATHS
#   Will only contain $BR_GEM_DIR
#
# Sourcing this script and executing 'gem env' will demonstrate these affects.
#
if [ -z "$BR_DIR" ]; then
    echo "BR_DIR: not set (see bel.rb env.sh)"
    # don't exit; this script is sourced!
    return 1
fi
source "$BR_DIR"/env.sh || return 1

assert-env-or-die BR_GEM_DIR
assert-env-or-die BR_RUBY_CMD

# GEM_HOME is set to control where gems get installed.
export GEM_HOME="$BR_GEM_DIR"

# Set GEM_PATH is set so gems can't be loaded from anywhere else.
export GEM_PATH="$BR_GEM_DIR"

# Set GEM_SPEC_CACHE to control where specs are cached. Just setting GEM_HOME
# and GEM_PATH aren't enough to keep .spec files out of $HOME/.gem (this does
# not appear to be mentioned in Ruby documentation).
export GEM_SPEC_CACHE="$GEM_HOME/specs"

_iso_gem_bin="$($BR_RUBY_CMD -e "puts(Gem.bindir)")"
if not-in-path "$_iso_gem_bin"; then prepend PATH "$_iso_gem_bin"; fi
