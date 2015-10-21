#/usr/bin/env bash
# Normal script execution starts here.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
cd "$DIR" || exit 1

assert-env-or-die SCRIPTS
gem install "$DIR"/bel-"$($SCRIPTS/version.rb)".gem $GEM_INSTALL_OPTS $@

