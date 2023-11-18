#!/usr/bin/env bash
# shellcheck shell=bash
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Test help command" {
  run ${dropboxignore:?} help
  assert_success
  run ${dropboxignore:?}
  assert_success
}

@test "Test help command without passing the sub-command" {
  run ${dropboxignore:?}
  assert_success
}
