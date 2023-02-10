#!/usr/bin/env bash
# shellcheck shell=bash
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Test version command" {
  run $dropboxignore version
  assert_success
}
