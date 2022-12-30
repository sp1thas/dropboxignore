#!/usr/bin/env bash
# shellcheck shell=bash
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Test generate command when .dropboxignore file not exists" {
  rm -rf "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  run $dropboxignore generate "$BATS_TEST_TMPDIR"
  assert_success
  assert_file_exist "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  assert_output --partial "Created file: .dropboxignore"
  assert_output --partial "Total number of generated files: 1"
}

@test "Test generate command when .dropboxignore file exists" {
  run $dropboxignore generate "$BATS_TEST_TMPDIR"
  assert_success
  assert_file_exist "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  assert_output --partial "Total number of generated files: 0"
}

@test "Test generate command when .gitignore file not exists" {
  rm "$BATS_TEST_TMPDIR/$GITIGNORE_NAME" "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  run $dropboxignore generate "$BATS_TEST_TMPDIR"
  assert_success
  assert_file_not_exist "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  assert_file_not_exist "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
  assert_output --partial "Total number of generated files: 0"
}

@test "Test generate: don't create .dropboxignore file when exception patterns exists" {
  rm "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  echo "a
  !something" > "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
  run $dropboxignore generate "$BATS_TEST_TMPDIR"
  assert_success
  assert_file_not_exist "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  assert_output --partial ".gitignore contains exception patterns, will be ignored"
}

@test "Test generate_dropboxignore_file" {
  echo "sample" > "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
  rm "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  run generate_dropboxignore_file "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  echo "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
  assert_file_contains "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME" "[sample]"
}

@test "Test generate_dropboxignore_file already exists" {
  echo "sample" > "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
  rm "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  run generate_dropboxignore_file "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  echo "$BATS_TEST_TMPDIR/$GITIGNORE_NAME"
  assert_file_contains "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME" "[sample]"
  VERBOSITY=3
  run generate_dropboxignore_file "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
  assert_output --partial "Already existing file:"
  assert_output --partial "$BATS_TEST_TMPDIR/$DROPBOXIGNORE_NAME"
}