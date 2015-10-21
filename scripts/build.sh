#/usr/bin/env bash
# Normal script execution starts here.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
cd "$DIR" || exit 1

gem build bel.gemspec $GEM_BUILD_OPTS $@

