#!/bin/bash

#######################################
# Print help message.
# Outputs:
#   help message
#######################################
cmd_help() {
  cat <<EOUSAGE
Usage: "$PROGRAM_NAME" <command> <path> [-v 0-2] [-p pattern]

  Commands:

    genupi              Generate, update & ignore using one shortcut command.
    generate            Generate .dropboxignore files based on existing .gitignore files.
    update              Update existing .dropboxignore files if at least one .gitignore file has been changed.
    ignore              Ignore file or folder from dropbox under the given path.
    list                List ignored files and folders under the given path.
    revert              Revert ignored file or folder under the given path.
    delete              Delete specific .dropboxignore file or every .dropboxignore file under the given path.
    help                Will print this message and then will exit.
    version             Will print the version and then will exit.

  Options:
    -v                  Choose verbose level (0: Error, 1: Info, 2: Debug)
    -p                  Filtering pattern (Can be used with list command in order to filter results)



EOUSAGE
}
