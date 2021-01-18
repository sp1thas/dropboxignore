#!/usr/bin/env bats
# shellcheck shell=bash

load '../libs/bats-support/load'
load '../libs/bats-file/load'
load '../libs/bats-assert/load'

TEST_FOLDER="testing_folder"
GITIGNORE_NAME=".gitignore"
DROPBOXIGNORE_NAME=".dropboxignore"

setup () {
  rm -rf "$TEST_FOLDER"
  mkdir "$TEST_FOLDER"
  # shellcheck disable=SC1091
  source dropboxignore.sh > /dev/null
  touch "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  touch "$TEST_FOLDER/$GITIGNORE_NAME"
}

teardown () { rm -rf "$TEST_FOLDER"; }

@test "Test help command" {
  run dropboxignore help > /dev/null
  assert_success
  run dropboxignore
  assert_success
}

@test "Test version command" {
  run dropboxignore version
  assert_success
}

@test "Test dropboxignore file generation" {
  run dropboxignore generate "$TEST_FOLDER"
  assert_success
  assert_file_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
}

@test "Test don't create dropboxignore when exception patterns exists" {
  rm "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  echo "a
  !something" > "$TEST_FOLDER/$GITIGNORE_NAME"
  run dropboxignore generate "$TEST_FOLDER"
  assert_success
  assert_file_not_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
}

@test "Test delete command" {
  mkdir "$TEST_FOLDER/other"
  touch "$TEST_FOLDER/other/$DROPBOXIGNORE_NAME"
  run dropboxignore delete "$TEST_FOLDER"
  assert_file_not_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  assert_file_not_exist "$TEST_FOLDER/other/$DROPBOXIGNORE_NAME"
}

@test "Test list command without results" {
  run dropboxignore ignore "$TEST_FOLDER"
  assert_success
  run dropboxignore list "$TEST_FOLDER"
}

@test "Test check_input" {
  # Test missing error on missing argument.
  run check_input
  assert_failure 2

  # Test success when folder exists.
  check_input "$TEST_FOLDER"
  assert_equal "$BASE_FOLDER" "$TEST_FOLDER"

  # Test error on missing file
  run check_input "$TEST_FOLDER/missingfile.txt"
  assert_failure 2

  # Test error on missing folder.
  run check_input "missing_folder/"
  assert_failure 2

  # Test succes when passing missing `.dropboxignore` file as parameter.
  run check_input "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  assert_success
}

@test "Test find_gitignore_files" {
  rm "$TEST_FOLDER/$GITIGNORE_NAME"
  # Test path without files
  find_gitignore_files "$TEST_FOLDER"
  assert_equal "" "$GITIGNORE_FILES"

  # Test path with file
  touch "$TEST_FOLDER/$GITIGNORE_NAME"
  find_gitignore_files "$TEST_FOLDER"
  assert_equal "$TEST_FOLDER/$GITIGNORE_NAME" "$GITIGNORE_FILES"

  # Test path with multiple files
  mkdir "$TEST_FOLDER/f"
  touch "$TEST_FOLDER/f/$GITIGNORE_NAME"
  find_gitignore_files "$TEST_FOLDER"
  assert_equal "$TEST_FOLDER/f/$GITIGNORE_NAME
$TEST_FOLDER/$GITIGNORE_NAME" "$GITIGNORE_FILES"
  # Test file with max depth
  find_gitignore_files "$TEST_FOLDER/$GITIGNORE_NAME"
  assert_equal "$TEST_FOLDER/$GITIGNORE_NAME" "$GITIGNORE_FILES"
}

@test "Test delete_dropboxignore_files" {
  # Test success on existing path
  run delete_dropboxignore_files "$TEST_FOLDER"
  assert_success
  assert_file_not_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"

  # Test success on specific dropboxignore file parameter
  touch "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  run delete_dropboxignore_files "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  assert_success
  assert_file_not_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"

  # Test failure when passing non dropboxignore file
  touch "$TEST_FOLDER/a.txt"
  run delete_dropboxignore_files "$TEST_FOLDER/a.txt"
  assert_failure 1

  # Test non existing file of path
  run delete_dropboxignore_files "$TEST_FOLDER/nonexistingfolder/"
  assert_failure 3
}

@test "Test find_dropboxignore_files" {
  find_dropboxignore_files "$TEST_FOLDER"
  assert_equal "$DROPBOX_IGNORE_FILES" "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
}

@test "Test generate_dropboxignore_file" {
  echo "sample" > "$TEST_FOLDER/$GITIGNORE_NAME"
  rm "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  run generate_dropboxignore_file "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  echo "$TEST_FOLDER/$GITIGNORE_NAME"
  assert_file_contains "$TEST_FOLDER/$DROPBOXIGNORE_NAME" "[sample]"
}