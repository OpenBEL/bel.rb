#!/usr/bin/env bash

# Return 0 if $1 is a set variable, 1 otherwise.
function _g_varset {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <var>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    local var="$1"
    if [[ ! ${!var} && ${!var-unset} ]]; then
        return 1
    fi
    return 0
}

# Return 0 if $1 is not a set variable, 1 otherwise.
function _g_varunset {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <var>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    local var="$1"
    if [[ ! ${!var} && ${!var-unset} ]]; then
        return 0
    fi
    return 1
}

# Returns 0 if $1 is in PATH, 1 otherwise.
function _g_in_path {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <path>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    # PATH -> to array
    local path_array
    OLDIFS=$IFS
    IFS=":" path_array=($PATH)
    IFS=$OLDIFS
    for path in "${path_array[@]}"; do
        if [ "$path" == "$1" ]; then
            return 0
        fi
    done
    return 1
}

# Adds $1 to PATH, unless it's already there.
function _g_add_path {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <path>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if ! _g_in_path "$1"; then
        export PATH="$1":$PATH
    fi
}

# Removes $1 from PATH, if it's there.
function _g_rm_path {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <path>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    local new_path=
    # PATH -> to array
    local path_array
    OLDIFS=$IFS
    IFS=":" path_array=($PATH)
    IFS=$OLDIFS
    for path in "${path_array[@]}"; do
        if [ "$path" == "$1" ]; then
            continue
        fi
        if [ -z "$new_path" ]; then
            new_path="$path"
        else
            new_path="$path:$new_path"
        fi
    done
    export PATH=$new_path
}

# Default a variable named $1 to $2 unless already set.
# This is more readable than expansion syntax.
# E.g.,
#    default foo bar
#
# This is a less verbose, more readable form of:
#    export FOO="${FOO:=$BAR}"
#
function default {
    if [ $# -ne 2 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable> <default value>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if _g_varunset "$1"; then
        export $1="$2"
    fi
}

# Default a variable named $1 to $2 unless already set,
# and be verbose about it. This is a verbose variant of
# the default function.
# E.g.,
#    vdefault foo bar
#
# This is a less verbose, more readable form of:
#    if [ -z "$FOO" ]; then
#        echo "..."
#        export FOO="${BAR}"
#    fi
#
function vdefault {
    if [ $# -ne 2 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable> <default value>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if _g_varunset "$1"; then
        echo "Variable \"$1\" is being defaulted to \"$2\"."
        export $1="$2"
    fi
}

# Override the variable named $1 by setting it to $2.
# This is mostly for consistency with the default function.
# E.g.,
#    override foo bar
function override {
    if [ $# -ne 2 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable> <override value>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    export $1="$2"
}

# Override the variable named $1 by setting it to $2,
# and be verbose about it. This is a verbose variant of
# the override function.
# E.g.,
#    voverride foo bar
function voverride {
    if [ $# -ne 2 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable> <override value>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    echo "Overriding variable \"$1\" and setting it to \"$2\"."
    export $1="$2"
}

# Prepends $2 to the variable named $1. If $1 is not already set, it will be
# set to $2.
# E.g.,
#    prepend PATH $(pwd)/bin
function prepend {
    if [ $# -ne 2 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable> <value>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if _g_varunset "$1"; then
        export $1="$2"
    else
        local current=$1
        export $1="$2:${!current}"
    fi
}

# Prepends $2 to the variable named $1, and be verbose about it. If $1 is not
# already set, it will be set to $2.
# E.g.,
#    vprepend PATH $(pwd)/bin
function vprepend {
    if [ $# -ne 2 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable> <value>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if _g_varunset "$1"; then
        echo "Variable \"$1\" is being set to \"$2\"."
        export $1="$2"
    else
        echo "Variable \"$1\" is being prepended with \"$2\"."
        local current=$1
        export $1="$2:${!current}"
    fi
}

# Appends $2 to the variable named $1. If $1 is not already set, it will be
# set to $2.
# E.g.,
#    append PATH $(pwd)/bin
function append {
    if [ $# -ne 2 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable> <value>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if _g_varunset "$1"; then
        export $1="$2"
    else
        local current=$1
        export $1="${!current}:$2"
    fi
}

# Prepends $2 to the variable named $1. If $1 is not already set, it will be
# set to $2.
# E.g.,
#    prepend PATH $(pwd)/bin
function vappend {
    if [ $# -ne 2 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable> <value>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if _g_varunset "$1"; then
        echo "Variable \"$1\" is being set to \"$2\"."
        export $1="$2"
    else
        echo "Variable \"$1\" is being appended to with \"$2\"."
        local current=$1
        export $1="$2:${!current}"
    fi
}

# Returns 1 if the environment variable $1 is in PATH, 0 otherwise.
# E.g.,
#    in-path $HOME/bin
function in-path {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <var>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if [[ ":$PATH:" == *":$1:"* ]]; then
        return 0
    fi
    return 1
}

# Returns 1 if the environment variable $1 is in PATH, 0 otherwise.
# This is a verbose variant of the in-path function.
# E.g.,
#    vin-path $HOME/bin
function vin-path {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <var>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if [[ ":$PATH:" == *":$1:"* ]]; then
        echo "PATH contains \"$1\"."
        return 0
    fi
    echo "PATH does not contain \"$1\"."
    return 1
}

# Returns 1 if the environment variable $1 is not in PATH, 0 otherwise.
# E.g.,
#    not-in-path $HOME/bin
function not-in-path {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <var>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if [[ ":$PATH:" == *":$1:"* ]]; then
        return 1
    fi
    return 0
}

# Returns 1 if the environment variable $1 is not in PATH, 0 otherwise.
# This is a verbose variant of the not-in-path function.
# E.g.,
#    vnot-in-path $HOME/bin
function vnot-in-path {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <var>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if [[ ":$PATH:" == *":$1:"* ]]; then
        echo "PATH contains \"$1\"."
        return 1
    fi
    echo "PATH does not contain \"$1\"."
    return 0
}

# Returns 1 if the environment variable $1 is not set, 0 otherwise.
# E.g.,
#    assert-env PATH
function assert-env {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if _g_varunset "$1"; then
        echo "$1 is not set" 1>&2
        return 1
    fi
    return 0
}

# Exits 1 if the environment variable $1 is not set.
# E.g.,
#    assert-env-or-die PATH
function assert-env-or-die {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if _g_varunset "$1"; then
        echo "$1 is not set" 1>&2
        exit 1
    fi
}

# Prompt the user to set a variable if it does not have a default value.
# E.g.,
#    prompt-env VERSION "VERSION is not set, please set it now: "
function prompt-env {
    if [ $# -ne 2 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable> <prompt>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if _g_varunset "$1"; then
        read -p "$2" REPLY
        if [ -z "$REPLY" ]; then
            echo "no response" >&2
            return 1
        fi
        export $1="$REPLY"
    fi
    return 0
}

# Prompt the user to set a variable if it does not have a default value, and
# be verbose about it.
# E.g.,
#    vprompt-env VERSION "VERSION not set, please set it now: " "VERSION is: "
function vprompt-env {
    if [ $# -ne 3 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <variable> <prompt> <verbose>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if _g_varunset "$1"; then
        read -p "$2" REPLY
        if [ -z "$REPLY" ]; then
            echo "no response" >&2
            return 1
        fi
        export $1="$REPLY"
    else
        local current=$1
        echo "${3}\"${!current}\"."
    fi
    return 0
}

# Sources the file named $1, if readable. The return code of the source
# operation is returned to allow for failure conditions when sourcing a
# file.
# E.g.,
#    assert-source template.sh || exit 1
#
# Sourcing a file that does not exist is normally a failure. This function
# does not. The following example will *not* execute the exit statement.
# E.g.,
#    assert-source does-not-exist.sh || exit 1
#
function assert-source {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <file>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    if [ -r "$1" ]; then
        source "$1"
        RC=$?
        if [ $RC -ne 0 ]; then
            local me=FUNCNAME
            echo "${!me}: source failure in $1; returned $RC" >&2
            return $RC
        fi
    fi
    return 0
}

# Returns 1 if the command $1 is not found, 0 otherwise.
# E.g.,
#    require-cmd realpath
function require-cmd {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <command>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    _=$(which "$1" >/dev/null 2>&1)
    if [ $? -eq 1 ]; then
        echo "$1: command not found (and it is required)" 2>&2
        return 1
    fi
    return 0
}

# Exits 1 if the required command is not found.
# E.g.,
#    require-cmd-or-die realpath
function require-cmd-or-die {
    if [ $# -ne 1 ]; then
        local me=FUNCNAME
        echo "usage: ${!me} <command>" >&2
        echo "(got: $@)" >&2
        exit 1
    fi
    _=$(which "$1" >/dev/null 2>&1)
    if [ $? -eq 1 ]; then
        echo "$1: command not found (and it is required)" 2>&2
        exit 1
    fi
}

# Pull in any GOSH_CONTRIB scripts found.
function use-gosh-contrib {
    assert-env GOSH_CONTRIB || return 1
    for contrib in "$GOSH_CONTRIB"/*.sh; do
        assert-source "$contrib" || return 1
    done
    return 0
}

# Exits 1 unless all GOSH_CONTRIB scripts are pulled in.
function use-gosh-contrib-or-die {
    assert-env-or-die GOSH_CONTRIB
    for contrib in "$GOSH_CONTRIB"/*.sh; do
        assert-source "$contrib" || exit 1
    done
}
