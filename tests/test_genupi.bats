#!/usr/bin/env bash
# shellcheck shell=bash
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Test genupi command" {
  rm -rf "${BATS_TEST_TMPDIR:?}/$DROPBOXIGNORE_NAME"
  run ${dropboxignore:?} genupi "$BATS_TEST_TMPDIR"
  assert_success
  assert_file_exist "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  assert_file_exist "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
  assert_output --partial "Total number of generated files: 1"
}
