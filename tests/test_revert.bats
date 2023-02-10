#!/usr/bin/env bash
# shellcheck shell=bash
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Test revert_ignored_files specific file" {
    touch "$BATS_TEST_TMPDIR/foo.txt"
    run $dropboxignore ignore "$BATS_TEST_TMPDIR/foo.txt"
    assert_output --partial "Total number of ignored files: 1"
    assert_output --partial "Total number of ignored folders: 0"
    assert_success
    run $dropboxignore revert "$BATS_TEST_TMPDIR"
    assert_output --partial "Total number of reverted files: 1"
    assert_success
}

@test "Test revert_ignored_files folder" {
    touch "$BATS_TEST_TMPDIR/foo.txt"
    echo "*.txt" > "$BATS_TEST_TMPDIR/.dropboxignore"
    run $dropboxignore ignore .
    assert_output --partial "Total number of ignored files: 1"
    assert_output --partial "Total number of ignored folders: 0"
    assert_success
    run $dropboxignore revert .
    assert_output --partial "Total number of reverted files: 3"
    assert_success
}
