#!/usr/bin/env bash

# shellcheck shell=bash
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Test check_input" {
  # Test missing error on missing argument.
  run check_input
  assert_failure 2

  # Test success when folder exists.
  check_input "$BATS_TEST_TMPDIR"
  assert_equal "$BASE_FOLDER" "$BATS_TEST_TMPDIR"

  # Test error on missing file
  run check_input "$BATS_TEST_TMPDIR/missingfile.txt"
  assert_failure 2

  # Test error on missing folder.
  run check_input "missing_folder/"
  assert_failure 2

  # Test succes when passing missing `.dropboxignore` file as parameter.
  run check_input "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  assert_success
}

@test "Test find_gitignore_files" {
  rm "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
  # Test path without files
  find_gitignore_files "$BATS_TEST_TMPDIR"
  assert_equal "" "$GITIGNORE_FILES"

  # Test path with file
  touch "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
  find_gitignore_files "$BATS_TEST_TMPDIR"
  assert_equal "$BATS_TEST_TMPDIR/$GITIGNORE_NAME" "$GITIGNORE_FILES"

  # Test path with multiple files
  mkdir "$BATS_TEST_TMPDIR/f"
  touch "$BATS_TEST_TMPDIR/f/$GITIGNORE_NAME"
  find_gitignore_files "$BATS_TEST_TMPDIR"
  run echo "$GITIGNORE_FILES"
  assert_output --partial "$BATS_TEST_TMPDIR/f/$GITIGNORE_NAME"
  run echo "$GITIGNORE_FILES"
  assert_output --partial "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
  # Test file with max depth
  find_gitignore_files "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
  assert_equal "$BATS_TEST_TMPDIR/$GITIGNORE_NAME" "$GITIGNORE_FILES"
}

@test "Test find_dropboxignore_files" {
  find_dropboxignore_files "$BATS_TEST_TMPDIR"
  assert_equal "$DROPBOX_IGNORE_FILES" "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
}

@test "Test check_os Linux" {
    MACHINE=Linux
    run check_os
    assert_success
}

@test "Test check_os OSX" {
    MACHINE=Darwin
    run check_os
    assert_success
}

@test "Test check_os Unknown" {
    MACHINE=Unknown
    run check_os
    assert_output --partial "Unknown is not supported"
    assert_failure 3
}

@test "Test unknown command" {
    run $dropboxignore foo
    assert_output --partial "dropboxignore: 'foo' is not a dropboxignore command"
    assert_failure 1
}

@test "Test unknown option" {
    run $dropboxignore list -a
    assert_failure 2
}