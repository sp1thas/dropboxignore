#!/usr/bin/env bash
# shellcheck shell=bash
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Test ignore_files on .dropboxingore" {
    touch "$BATS_TEST_TMPDIR/.dropboxignore"
    run cmd_ignore "$BATS_TEST_TMPDIR/.dropboxignore"
    assert_output --partial "Cannot ignore an .dropboxignore. Choose another file or folder."
    assert_failure 4
}

@test "Test ignore_file on .dropboxingore" {
    touch "$BATS_TEST_TMPDIR/.dropboxignore"
    run ignore_file "$BATS_TEST_TMPDIR/.dropboxignore"
    assert_success
}

@test "Test ignore_files existing file" {
    touch "$BATS_TEST_TMPDIR/foo.txt"
    run cmd_ignore "$BATS_TEST_TMPDIR/foo.txt"
    assert_output --partial "Total number of ignored files: 1"
    assert_output --partial "Total number of ignored folders: 0"
    assert_success
}
