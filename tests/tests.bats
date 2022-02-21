#!/usr/bin/env bats
# shellcheck shell=bash

load '../libs/bats-support/load'
load '../libs/bats-file/load'
load '../libs/bats-assert/load'

TEST_FOLDER="testing_folder"
GITIGNORE_NAME=".gitignore"
DROPBOXIGNORE_NAME=".dropboxignore"

setup () {
  unset DROPBOXIGNORE_FILES
  rm -rf "$TEST_FOLDER"
  mkdir "$TEST_FOLDER"
  # shellcheck disable=SC1091
  source bin/dropboxignore.sh > /dev/null
  touch "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  touch "$TEST_FOLDER/$GITIGNORE_NAME"
  dropboxignore='./bin/dropboxignore.sh'
}

teardown () { rm -rf "$TEST_FOLDER"; }

@test "Test help command" {
  run $dropboxignore help > /dev/null
  assert_success
  run $dropboxignore
  assert_success
}

@test "Test version command" {
  run $dropboxignore version
  assert_success
  assert_output --partial "$(grep -oP '^VERSION=(.*)$' bin/dropboxignore.sh | sed -r 's/^VERSION=//')"
}

@test "Test generate command when .dropboxignore file not exists" {
  rm "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  run $dropboxignore generate "$TEST_FOLDER"
  assert_success
  assert_file_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  assert_output --partial "Created file: .dropboxignore"
  assert_output --partial "Total number of generated files: 1"
}

@test "Test generate command when .dropboxignore file exists" {
  run $dropboxignore generate "$TEST_FOLDER"
  assert_success
  assert_file_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  assert_output --partial "Total number of generated files: 0"
}

@test "Test generate command when .gitignore file not exists" {
  rm "$TEST_FOLDER/$GITIGNORE_NAME" "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  run $dropboxignore generate "$TEST_FOLDER"
  assert_success
  assert_file_not_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  assert_file_not_exist "$TEST_FOLDER/$GITIGNORE_NAME"
  assert_output --partial "Total number of generated files: 0"
}

@test "Test generate: don't create .dropboxignore file when exception patterns exists" {
  rm "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  echo "a
  !something" > "$TEST_FOLDER/$GITIGNORE_NAME"
  run $dropboxignore generate "$TEST_FOLDER"
  assert_success
  assert_file_not_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  assert_output --partial ".gitignore contains exception patterns, will be ignored"
}

@test "Test delete command" {
  mkdir "$TEST_FOLDER/other"
  touch "$TEST_FOLDER/other/$DROPBOXIGNORE_NAME"
  run $dropboxignore delete "$TEST_FOLDER"
  assert_success
  assert_file_not_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  assert_file_not_exist "$TEST_FOLDER/other/$DROPBOXIGNORE_NAME"
  assert_output --partial "Deleted files: 2"
}

@test "Test list command without results" {
  run $dropboxignore ignore "$TEST_FOLDER" -p '*'
  assert_success
  run $dropboxignore list "$TEST_FOLDER"  -v 3
  assert_success
  assert_output --partial "Total number of ignored files: 0"
  assert_output --partial "Total number of ignored folders: 0"
}

@test "Test list command non existing folder" {
  run $dropboxignore list "$TEST_FOLDER/non-existing"
  assert_failure 2
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
  run echo "$GITIGNORE_FILES"
  assert_output --partial "$TEST_FOLDER/f/$GITIGNORE_NAME"
  run echo "$GITIGNORE_FILES"
  assert_output --partial "$TEST_FOLDER/$GITIGNORE_NAME"
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
  assert_output --partial "Given file is not a .dropboxignore file."
  assert_failure 1

  # Test non existing file of path
  run delete_dropboxignore_files "$TEST_FOLDER/nonexistingfolder/"
  assert_output --partial "file not found"
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

@test "Test generate_dropboxignore_file already exists" {
  echo "sample" > "$TEST_FOLDER/$GITIGNORE_NAME"
  rm "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  run generate_dropboxignore_file "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  echo "$TEST_FOLDER/$GITIGNORE_NAME"
  assert_file_contains "$TEST_FOLDER/$DROPBOXIGNORE_NAME" "[sample]"
  VERBOSITY=3
  run generate_dropboxignore_file "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  assert_output --partial "Already existing file: testing_folder/.dropboxignore"
}

@test "Test genupi command" {
  run $dropboxignore genupi "$TEST_FOLDER"
  assert_success
  assert_file_exist "$TEST_FOLDER/$DROPBOXIGNORE_NAME"
  assert_file_exist "$TEST_FOLDER/$GITIGNORE_NAME"
  assert_output --partial "Total number of generated files: 0"
}

@test "Test log_info high verbosity" {
    VERBOSITY=1
    run log_info "test"
    assert_output --partial "test"
}

@test "Test log_info low verbosity" {
    VERBOSITY=0
    run log_info "test"
    refute_output --partial "test"
}

@test "Test log_debug high verbosity" {
    VERBOSITY=2
    run log_debug "test"
    assert_output --partial "test"
}

@test "Test log_debug low verbosity" {
    VERBOSITY=0
    run log_debug "test"
    refute_output --partial "test"
}

@test "Test log_error high verbosity" {
    VERBOSITY=2
    run log_error "test"
    assert_output --partial "test"
    assert_failure 1
}

@test "Test log_error low verbosity exit code" {
    VERBOSITY=-1
    run log_error "test" 2
    refute_output --partial "test"
    assert_failure 2
}

@test "Test log_warning high verbosity" {
    VERBOSITY=1
    run log_warning "test"
    assert_output --partial "test"
}

@test "Test log_warning low verbosity" {
    VERBOSITY=0
    run log_warning "test"
    refute_output --partial "test"
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
    assert_output --partial "dropboxignore.sh: 'foo' is not a dropboxignore.sh command."
    assert_output --partial "See 'dropboxignore.sh help"
    assert_failure 1
}

@test "Test unknown option" {
    run $dropboxignore list -a
    assert_failure 2
}

@test "Test update_dropboxignore_files" {
    touch "$TEST_FOLDER/.dropboxignore"
    echo "*.txt" > "$TEST_FOLDER/.gitignore"
    run $dropboxignore update "$TEST_FOLDER"
    assert_output --partial "Updated .dropboxignore"
}

@test "Test update_dropboxignore_file" {
    touch "$TEST_FOLDER/.dropboxignore"
    echo "*.txt" > "$TEST_FOLDER/.gitignore"
    run update_dropboxignore_file "$TEST_FOLDER/.gitignore" "$TEST_FOLDER/.dropboxignore"
    assert_output --partial "Updated testing_folder/.dropboxignore"
}

@test "Test ignore_files on .dropboxingore" {
    touch "$TEST_FOLDER/.dropboxignore"
    run ignore_files "$TEST_FOLDER/.dropboxignore"
    assert_output --partial "Cannot ignore an .dropboxignore. Choose another file or folder."
    assert_failure 4
}

@test "Test ignore_file on .dropboxingore" {
    touch "$TEST_FOLDER/.dropboxignore"
    run ignore_file "$TEST_FOLDER/.dropboxignore"
    assert_success
}

@test "Test ignore_files existing file" {
    touch "$TEST_FOLDER/foo.txt"
    run ignore_files "$TEST_FOLDER/foo.txt"
    assert_output --partial "Total number of ignored files: 1"
    assert_output --partial "Total number of ignored folders: 0"
    assert_success
}

@test "Test revert_ignored_files specific file" {
    touch "$TEST_FOLDER/foo.txt"
    run $dropboxignore ignore "$TEST_FOLDER/foo.txt"
    assert_output --partial "Total number of ignored files: 1"
    assert_output --partial "Total number of ignored folders: 0"
    assert_success
    run $dropboxignore revert .
    assert_output --partial "Total number of reverted files: 1"
    assert_success
}

@test "Test revert_ignored_files folder" {
    touch "$TEST_FOLDER/foo.txt"
    echo "*.txt" > "$TEST_FOLDER/.dropboxignore"
    run $dropboxignore ignore .
    assert_output --partial "Total number of ignored files: 1"
    assert_output --partial "Total number of ignored folders: 0"
    assert_success
    run $dropboxignore revert .
    assert_output --partial "Total number of reverted files: 1"
    assert_success
}