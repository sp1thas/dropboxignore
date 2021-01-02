# dropboxignore

**It's all about the missing `.dropboxignore` file.**

---

![CI](https://github.com/sp1thas/dropboxignore/workflows/CI/badge.svg) [![GitHub license](https://img.shields.io/github/license/sp1thas/dropboxignore)](https://github.com/sp1thas/dropboxignore/blob/master/LICENSE) [![Code Style](https://img.shields.io/badge/code%20style-google-%234285F4)](https://github.com/google/styleguide)

Exclude files from dropbox using glob patterns and take advantage of existing `.gitignore` files.

This is a simple shell script that can be used to ignore files from dropbox using glob patterns, `.dropboxignore` files and the already existing `.gitignorefiles`. The shell script uses [this](https://help.dropbox.com/files-folders/restore-delete/ignored-files) approach to ignore the matched files.

## Features

 - Ignore folders or files based on glob patterns inside the `.dropboxignore` file.
 - Automatically generate `.dropboxignore` files based on existing `.gitignore` files.
 - Ignore specific folders or files via CLI and `.dropboxignore` will automatically be updated.
 - Revert ignored folders or files
 - Delete `.dropboxignore` files
 - Update `.dropboxignore` files when changes are detected in corresponding `.gitignore` files.

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
Usage: "dropboxignore" <command> <file_or_folder> [-v 0-2]

  Commands:

    generate            Generate .dropboxignore files based on existing .gitignore files.
                        If a .dropboxignore file already exists, will not be updated.
    update              Update existing .dropboxignore files if at least one .gitignore file have been changed.
    ignore              Ignore file or folder from dropbox.
    revert              Revert ignored file or folder.
    delete              Delete specific .dropboxignore file or every .dropboxignore files under the given directory.
    help                Will print this message and then will exit.
    version             Will print the version and then will exit.

  Options:
    -v                  Choose verbose level (0: Error, 1: Info, 2: Debug)

```

### Examples

Let's setup our demo folder:
```shell
$ mkdir ~/demo && git init demo && \
  echo 'b.txt' > ~/demo/.gitignore && \
  mkdir ~/demo/subfolder && echo 'a.txt' > ~/demo/subfolder/.gitignore &&
  touch ~/demo/b.txt ~/demo/subfolder/b.txt ~/demo/subfolder/a.txt
Initialized empty Git repository in ~/demo/.git/
$ tree ~/demo -a -I .git
/home/psimakis/demo
├── b.txt
├── .gitignore
└── subfolder
    ├── a.txt
    ├── b.txt
    └── .gitignore

1 directory, 5 files
```

Generate multiple `.dropboxignore` files based on existing `.gitignore` files inside your folder:

```shell
$  dropboxignore generate ~/demo
Sat 02 Jan 2021 10:12:11 PM EET [  INFO ] Created file: ~/demo/subfolder/.dropboxignore
Sat 02 Jan 2021 10:12:11 PM EET [  INFO ] Created file: ~/demo/.dropboxignore
Sat 02 Jan 2021 10:12:11 PM EET [  INFO ] Total number of generated files: 2
```

Ignored all files based on `.dropboxignore` files:

```shell
$ dropboxignore ignore ~/demo
Sat 02 Jan 2021 10:16:22 PM EET [  INFO ] Total number of ignored files: 3
```

Revert all ignored files:

```shell
$  dropboxignore revert .
Sat 02 Jan 2021 10:16:44 PM EET [  INFO ] Number of reverted files: 3
Sat 02 Jan 2021 10:16:45 PM EET [  INFO ] number of reverted folders: 0
```


## TODOs

 - ~~Support MacOS~~
 - `dropbox update` should support deletions
 - ~~Enhance stdout~~
 - ~~Add option for verbosity~~
