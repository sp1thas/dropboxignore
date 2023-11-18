#!/usr/bin/env bash
# shellcheck shell=bash
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Test update_dropboxignore_files" {
    touch "$BATS_TEST_TMPDIR/.dropboxignore"
    echo "*.txt" > "$BATS_TEST_TMPDIR/.gitignore"
    run ${dropboxignore:?} update "$BATS_TEST_TMPDIR"
    assert_output --partial "Updated .dropboxignore"
}

@test "Test update_dropboxignore_file" {
    touch "$BATS_TEST_TMPDIR/.dropboxignore"
    echo "*.txt" > "$BATS_TEST_TMPDIR/.gitignore"
    run update_dropboxignore_file "$BATS_TEST_TMPDIR/.gitignore" "$BATS_TEST_TMPDIR/.dropboxignore"
    assert_output --partial "$BATS_TEST_TMPDIR/.dropboxignore"
    assert_output --partial "Updated"
}
