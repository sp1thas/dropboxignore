#!/usr/bin/env bash

GITIGNORE_NAME=".gitignore"
DROPBOXIGNORE_NAME=".dropboxignore"

_common_setup() {
    load '../libs/bats-support/load'
    load '../libs/bats-file/load'
    load '../libs/bats-assert/load'
    unset DROPBOXIGNORE_FILES
    # shellcheck disable=SC1091
    source "src/lib/modules/loader.sh" "$BATS_TEST_DIRNAME/../src/lib" > /dev/null
    # shellcheck disable=SC1091
    touch "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
    touch "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
    # shellcheck disable=SC2034
    dropboxignore="$BATS_TEST_DIRNAME/../src/bin/cli.sh"
    chown -R "$USER:$GROUP" "$BATS_RUN_TMPDIR"
    cd "$BATS_TMPDIR" || return
}