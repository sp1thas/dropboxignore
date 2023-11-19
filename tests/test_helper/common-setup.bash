#!/usr/bin/env bash

GITIGNORE_NAME=".gitignore"
DROPBOXIGNORE_NAME=".dropboxignore"

_common_setup() {
    load '../bats-support/load'
    load '../bats-file/load'
    load '../bats-assert/load'
    unset DROPBOXIGNORE_FILES
    # shellcheck disable=SC1091
    source "src/lib/modules/loader.sh" "$BATS_TEST_DIRNAME/../src/lib" > /dev/null
    # shellcheck disable=SC1091
    touch "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
    touch "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
    # shellcheck disable=SC2034
    dropboxignore="$BATS_TEST_DIRNAME/../src/bin/cli.sh"
    chown -R "$(id -u):$(id -g)" "$BATS_RUN_TMPDIR"
    cd "$BATS_TMPDIR" || return
}
