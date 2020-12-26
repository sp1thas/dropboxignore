# dropboxignore

**It's all about the missing `.dropboxignore` file.**

Exclude files from dropbox using file patterns, existing `.gitignore` files and the missing `.dropboxignore` file.

This is a simple shell script that can be used to exclude files from dropbox using file patterns, .dropboxignore files and the already existing .gitignorefiles. This script uses [this](https://help.dropbox.com/files-folders/restore-delete/ignored-files) approach to ignore the selected files.

## Features

 - Ignore folders or files based on file patterns inside the `.dropboxignore` file.
 - Automatically generate `.dropboxignore` files based on existing `.gitignore` files.]
 - Ignore specific folders or files via CLI and `.dropboxignore` will be automatically updated.
 - Revert ignored folders or files
 - Delete `.dropboxignore` files
 - Update `.dropboxignore` files when changes are detected in `.gitignore` files.

## Getting Started

### Prerequisites

⚠️ This shell is currently working only on Linux. ⚠️

[attr](https://man7.org/linux/man-pages/man1/attr.1.html) should be installed in your system

For Ubuntu/Debian based:
```shell
$ sudo apt install attr
```

### Basic Installation

```
$ git clone https://github.com/sp1thas/dropboxignore.git
$ sudo cp dropboxignore/dropboxignore.sh /usr/local/bin/dropboxignore
$ sudo chmod +x /usr/local/bin/dropboxignore
```

## Using dropboxignore

In order to use this shell you have to select the action and the file or folder that the action will take place.

A common workflow could be the following

 1. Automatically generate `.dropboxignore` files based on existing `.gitignore` files (`dropboxignore generate path`.
 2. Manually update or create `.dropboxignore` files (Optional)
 3. Ignore matched files based on `.dropboxignore` files (`dropboxignore ignore path`)

`dropboxignore help` for more details:

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

Generate `.dropboxignore` files based on existing `.gitignore` files for your dropbox folder:

```shell
$ dropboxignore generate /home/yourusername/Dropbox
```

and ignored the matched files from dropbox

```shell
$ dropboxignore ignore /home/yourusername/Dropbox
```

Revert all ignored files:

```shell
$ dropboxignore revert /home/yourusername/Dropbox 
```


## TODOs

 - Support MacOS
 - Update should support deletions
 - Enhance stdout
 - Add option for verbosity