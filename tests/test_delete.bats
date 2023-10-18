#!/usr/bin/env bash
# shellcheck shell=bash
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Test delete command" {
  ls
  mkdir "$BATS_TEST_TMPDIR/other"
  touch "$BATS_TEST_TMPDIR/other/$DROPBOXIGNORE_NAME"
  run $dropboxignore delete "$BATS_TEST_TMPDIR"
  assert_success
  assert_file_not_exist "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  assert_file_not_exist "$BATS_TEST_TMPDIR/other/$DROPBOXIGNORE_NAME"
  assert_output --partial "Deleted files: 2"
}

@test "Test cmd_delete" {
  # Test success on existing path
  run cmd_delete "$BATS_TEST_TMPDIR"
  assert_success
  assert_file_not_exist "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"

  # Test success on specific dropboxignore file parameter
  touch "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  run cmd_delete "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  assert_success
  assert_file_not_exist "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"

  # Test failure when passing non dropboxignore file
  touch "$BATS_TEST_TMPDIR/a.txt"
  run cmd_delete "$BATS_TEST_TMPDIR/a.txt"
  assert_output --partial "Given file is not a .dropboxignore file."
  assert_failure 1

  # Test non existing file of path
  run cmd_delete "$BATS_TEST_TMPDIR/nonexistingfolder/"
  assert_output --partial "file not found"
  assert_failure 3
}
