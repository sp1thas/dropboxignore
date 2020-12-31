# dropboxignore

**It's all about the missing `.dropboxignore` file.**

---

![CI](https://github.com/sp1thas/dropboxignore/workflows/CI/badge.svg) [![GitHub license](https://img.shields.io/github/license/sp1thas/dropboxignore)](https://github.com/sp1thas/dropboxignore/blob/master/LICENSE) [![Code Style](https://img.shields.io/badge/code%20style-google-%234285F4)](https://github.com/google/styleguide)

Exclude files from dropbox using file patterns, existing `.gitignore` files and the missing `.dropboxignore` file.

This is a simple shell script that can be used to exclude files from dropbox using file patterns, `.dropboxignore` files and the already existing `.gitignorefiles`. The shell script uses [this](https://help.dropbox.com/files-folders/restore-delete/ignored-files) approach to ignore the selected files.

## Features

 - Ignore folders or files based on file patterns inside the `.dropboxignore` file.
 - Automatically generate `.dropboxignore` files based on existing `.gitignore` files.
 - Ignore specific folders or files via CLI and `.dropboxignore` will be automatically updated.
 - Revert ignored folders or files
 - Delete `.dropboxignore` files
 - Update `.dropboxignore` files when changes are detected in `.gitignore` files.

## Getting Started

⚠️ This script is currently available only for Linux and MacOS.

### Prerequisites

[attr](https://man7.org/linux/man-pages/man1/attr.1.html) should be installed in your system

For Ubuntu/Debian based:
```shell
$ apt install attr
```

### Installation

```
$ git clone https://github.com/sp1thas/dropboxignore.git
$ cp dropboxignore/dropboxignore.sh /usr/local/bin/dropboxignore
$ chmod +x /usr/local/bin/dropboxignore
```

## Usage

In order to use this script you have to select the action and the file or folder that the action will take place.

A common workflow could be the following

 1. Automatically generate `.dropboxignore` files based on existing `.gitignore` files (`dropboxignore generate path`).
 2. Manually update or create `.dropboxignore` files (Optional)
 3. Ignore matched files based on `.dropboxignore` files (`dropboxignore ignore path`)

### More details

```shell
$ dropboxignore help
Usage: dropboxignore command filename_or_folder

  Commands:

    generate            Generate .dropboxignore files based on existing .gitignore files.
                        If a .dropboxignore file already exists, will not be updated.
    update              Update existing .dropboxignore files if at least a .gitignore file have been changed. Provide an existing
                        .dropboxignore file or update everything by providing the dropbox folder.
    ignore              Ignore file or folder from dropbox. Related .dropboxignore file will be updated automatically.
    revert              Revert ignored file or folder.
    delete              Delete specific .dropboxignore file or every .dropboxignore files under the given directory.
    help                Will print this message and then will exit.
    version             Will print the version and then will exit.
```

### Examples

Generate multiple `.dropboxignore` files based on existing `.gitignore` files inside your dropbox folder:

```shell
$ dropboxignore generate /home/yourusername/Dropbox
```

Generate a `dropboxignore` file based on existing `.gitignore` file in the same directory:

```shell
$ dropboxignore generate /home/youusername/Dropbox/repository/.dropboxignore
```

Ignored all files based on `.dropboxignore` files:

```shell
$ dropboxignore ignore /home/yourusername/Dropbox
```

Revert all ignored files:

```shell
$ dropboxignore revert /home/yourusername/Dropbox 
```


## TODOs

 - ~~Support MacOS~~
 - `dropbox update` should support deletions
 - Enhance stdout
 - Add option for verbosity
