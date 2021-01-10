#!/usr/bin/env

load 'test/libs/bats-support/load'
load 'test/libs/bats-file/load'
load 'test/libs/bats-assert/load'

TEST_FOLDER="testing_folder"

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
  [ "$status" -eq 0 ]
}
