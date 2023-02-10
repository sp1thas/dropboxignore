#!/bin/bash
# shellcheck disable=SC2034
IFS='
'
set -f
VERSION=v1.2.1
DROPBOX_IGNORE_FILE_NAME=".dropboxignore"
GIT_IGNORE_FILE_NAME=".gitignore"
MACHINE="$(uname -s)"
PROGRAM_NAME="dropboxignore"
VERBOSITY=1
TOTAL_N_IGNORED_FILES=0
TOTAL_N_IGNORED_FOLDERS=0
TOTAL_N_REVERTED_FILES=0
TOTAL_N_GENERATED_FILES=0
BASE_FOLDER="$PWD"
FILE_ATTR_NAME="com.dropbox.ignored"
[[ $MACHINE == Darwin ]] && GREP_CMD="ggrep" || GREP_CMD="grep"
[[ $MACHINE == Darwin ]] && DIFF_CMD="$(brew --prefix)/bin/diff" || DIFF_CMD="diff"
