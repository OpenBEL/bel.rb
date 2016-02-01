#/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
assert-env-or-die BR_DIR
cd "$BR_DIR" || exit 1

assert-env-or-die BR_GEM_CMD
if [ $BR_ISOLATE == "yes" ]; then
    assert-env-or-die BR_SCRIPTS
    source "$BR_SCRIPTS"/isolate.sh || exit 1
    if [ ! -d "$BR_GEM_DIR" ]; then
        echo "Installing development dependencies in isolation."
    elif [ "$BR_DIR"/gem.deps.rb -nt "$BR_GEM_DIR" ]; then
        echo -n "Dependencies updated, removing old isolation path... " >&2
        rm -fr "$BR_GEM_DIR" || exit 1
        echo "okay" >&2
    elif [ "$BR_DIR"/gem.deps.rb -ot "$BR_GEM_DIR" ]; then
        echo "Existing isolation path up-to-date."
        exit 0
    fi

    $BR_GEM_CMD install -g $BR_DEV_DEPS $BR_GEM_INSTALL_OPTS --no-lock --no-user-install || exit 1
    # Just say no to lock files (cleanup if we're using an old gem version)
    rm -f "$BR_DEV_DEPS".lock
else
    echo "Installing development dependencies."
    $BR_GEM_CMD install -g $BR_DEV_DEPS $BR_GEM_INSTALL_OPTS --no-lock || exit 1
fi
