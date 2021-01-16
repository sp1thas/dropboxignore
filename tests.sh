#!/usr/bin/env

load 'libs/bats-support/load'
load 'libs/bats-file/load'
load 'libs/bats-assert/load'

TEST_FOLDER="testing_folder"
GITIGNORE_NAME=".gitignore"
DROPBOXIGNORE_NAME=".dropboxignore"

setup () {
  rm -rf $TEST_FOLDER
  mkdir $TEST_FOLDER
}

teardown () {
  rm -rf $TEST_FOLDER
}

@test "Test help command" {
  run dropboxignore help > /dev/null
  assert_success
}

@test "Test version command" {
  run dropboxignore version
  assert_success
}

@test "Test dropboxignore file generation" {
  touch "$TEST_FOLDER/.gitignore"
  run dropboxignore generate $TEST_FOLDER
  assert_success
  assert_file_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
}

@test "Test don't create dropboxignore when exception patterns exists" {
  echo "a
  !something" > "$TEST_FOLDER/$GITIGNORE_NAME"
  run dropboxignore generate $TEST_FOLDER
  assert_success
  assert_file_not_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
}

@test "Test delete command" {
  touch "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  mkdir "$TEST_FOLDER/other"
  touch "$TEST_FOLDER/other/$DROPBOXIGNORE_NAME"
  run dropboxignore delete "$TEST_FOLDER"
  assert_file_not_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  assert_file_not_exist "$TEST_FOLDER/other/$DROPBOXIGNORE_NAME"
}

@test "Test list command without results" {
  touch "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  run dropboxignore ignore "$TEST_FOLDER"
  assert_success
  run dropboxignore list "$TEST_FOLDER"
}