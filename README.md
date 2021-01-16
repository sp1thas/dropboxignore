<div align="center">
    <h1>dropboxignore</h1>
    <img src="https://raw.githubusercontent.com/sp1thas/dropboxignore/master/icons/128.png" alt="Oh My Zsh">
    <p>It's all about the missing <code>.dropboxignore</code> file.</p>
    <img src="https://github.com/sp1thas/dropboxignore/workflows/Testing/badge.svg">
    <img src="https://img.shields.io/github/license/sp1thas/dropboxignore">
    <img src="https://img.shields.io/badge/code%20style-google-%234285F4">
</div>
<hr>

Exclude files from dropbox using glob patterns and take advantage of existing `.gitignore` files.

This is a simple shell script that can be used to ignore files from dropbox using glob patterns, `.dropboxignore` files and the already existing `.gitignorefiles`. The shell script uses [this](https://help.dropbox.com/files-folders/restore-delete/ignored-files) approach to ignore the matched files.

## Features

 - Ignore folders or files based on glob patterns inside the `.dropboxignore` file.
 - Automatically generate `.dropboxignore` files based on existing `.gitignore` files.
 - Ignore specific folders or files via CLI.
 - Revert ignored folders or files
 - Delete `.dropboxignore` files
 - Update `.dropboxignore` files when changes are detected in corresponding `.gitignore` files.
 - List ignored files and folders

## Getting Started

⚠️ This script is currently available only for Linux and MacOS.

### Prerequisites

[attr](https://man7.org/linux/man-pages/man1/attr.1.html) should be installed in your system

For Ubuntu/Debian based:
```shell
$ apt install attr
```

### Basic Installation

dropboxignore is installed by running one of the following commands in your terminal. You can install this via the command-line with either curl, wget or another similar tool.

| Mathod | Command                                                                                                 |
|--------|---------------------------------------------------------------------------------------------------------|
| curl   | `sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/sp1thas/dropboxignore/master/install.sh)"`  |
| wget   | `sudo sh -c "$(wget -qO- https://raw.githubusercontent.com/sp1thas/dropboxignore/master/install.sh)"`   |
| fetch  | `sudo sh -c "$(fetch -o - https://raw.githubusercontent.com/sp1thas/dropboxignore/master/install.sh)"`  |


### Manual Installation
```shell
$ git clone https://github.com/sp1thas/dropboxignore.git
$ cd dropboxignore
$ make test  # optional step, bats should be in your PATH
$ sudo make install
```

### Uninstall
```shell
$ make uninstall
```

## Usage

In order to use this script you have to select the action and the file or folder that the action will take place.

A common workflow could be the following

 1. Automatically generate `.dropboxignore` files based on existing `.gitignore` files (`dropboxignore generate path`).
 2. Manually update or create `.dropboxignore` files (Optional)
 3. Ignore matched files based on `.dropboxignore` files (`dropboxignore ignore path`)

### Notes

 1. In order to prevent unpleasant data losses, exception patterns are not supported. Both `.gitignore` and `.dropboxignore` files with at least one exceptional pattern will be bypassed (for further details: [#3](https://github.com/sp1thas/dropboxignore/issues/3)).
 2. Automatically generation of `.dropboxignore` files is an optional steps based on the use-case might not be a wise decision.

### More details

```shell
$ dropboxignore help
Usage: "dropboxignore" <command> <path> [-v 0-2] [-p pattern]

  Commands:

    generate            Generate .dropboxignore files based on existing .gitignore files.
                        If a .dropboxignore file already exists, will not be updated.
    update              Update existing .dropboxignore files if at least one .gitignore file have been changed.
    ignore              Ignore file or folder from dropbox.
    revert              Revert ignored file or folder.
    delete              Delete specific .dropboxignore file or every .dropboxignore files under the given directory.
    help                Will print this message and then will exit.
    version             Will print the version and then will exit.
    list                List ignored files and folders

  Options:
    -v                  Choose verbose level (0: Error, 1: Info, 2: Debug)
    -p                  Filtering pattern

```

<script id="asciicast-384964" src="https://asciinema.org/a/384964.js" async></script>

## How to contribute

If you wish to contribute, read [CONTRIBUTING.md](CONTRIBUTING.md) guide for further details.

## TODOs

 - `dropbox update` should support deletions.
 - `dropbox ignore` should automatically update `.dropboxignore` file.
 - Add more testcases


*Logo is based on [papirus-icon-theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)