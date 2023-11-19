#!/usr/bin/env bash
# shellcheck shell=bash
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Test list command without results" {
  run ${dropboxignore:?} ignore "$BATS_RUN_TMPDIR"
  assert_success
  run ${dropboxignore:?} list "$BATS_RUN_TMPDIR"  -v 3 -p '*'
  assert_success
  assert_output --partial "Total number of ignored files: 2"
  assert_output --partial "Total number of ignored folders: 0"
}

@test "Test list command non existing folder" {
  run ${dropboxignore:?} list "$BATS_RUN_TMPDIR/non-existing"
  assert_failure 2
}
