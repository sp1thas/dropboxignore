<div align="center">
    <h1>dropboxignore</h1>
    <img src="https://raw.githubusercontent.com/sp1thas/dropboxignore/master/icons/128.png" alt="dropboxignore-logo">
    <p>It's all about the missing <code>.dropboxignore</code> file.</p>
    <img src="https://github.com/sp1thas/dropboxignore/workflows/Testing/badge.svg">
    <img src="https://github.com/sp1thas/dropboxignore/workflows/Shellcheck/badge.svg">
    <a href='https://dropboxignore.readthedocs.io/en/latest/?badge=latest'>
        <img src='https://readthedocs.org/projects/dropboxignore/badge/?version=latest' alt='Documentation Status' />
    </a>
    <a href="https://snapcraft.io/dropboxignore">
        <img alt="dropboxignore" src="https://snapcraft.io/dropboxignore/badge.svg" />
    </a>
    <img src="https://img.shields.io/badge/code%20style-google-%234285F4">
</div>
<hr>

Exclude files from your [dropbox](https://www.dropbox.com) using glob patterns and take advantage of existing `.gitignore` files.

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

### Basic Installation

dropboxignore is installed by running one of the following commands in your terminal. You can install this via the command-line with either curl, wget or another similar tool. `attr` and `git` package should be installed on your system.

| Mathod | Command                                                                                                       |
|--------|---------------------------------------------------------------------------------------------------------------|
| curl   | `sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/sp1thas/dropboxignore/master/utils/install.sh)"`  |
| wget   | `sudo sh -c "$(wget -qO- https://raw.githubusercontent.com/sp1thas/dropboxignore/master/utils/install.sh)"`   |
| fetch  | `sudo sh -c "$(fetch -o - https://raw.githubusercontent.com/sp1thas/dropboxignore/master/utils/install.sh)"`  |


### Snap Installation

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/dropboxignore)

```shell
$ snap install dropboxignore --beta
```

### Manual Installation
```shell
$ git clone https://github.com/sp1thas/dropboxignore.git
$ cd dropboxignore
$ make test  # optional step, bats should be in your PATH
$ sudo make install
```

### Uninstall
```shell
$ sudo make uninstall
```

## Usage

In order to use this script you have to select the action and the file or folder that the action will take place.

A common workflow could be the following

 1. Automatically generate `.dropboxignore` files based on existing `.gitignore` files (`dropboxignore generate path`).
 2. Manually update or create `.dropboxignore` files (Optional)
 3. Ignore matched files based on `.dropboxignore` files (`dropboxignore ignore path`)

### Notes

 1. In order to prevent unpleasant data losses, exception patterns are not supported. Both `.gitignore` and `.dropboxignore` files with at least one exceptional pattern will be bypassed (for further details: [#3](https://github.com/sp1thas/dropboxignore/issues/3)).
 2. Automatic generation of `.dropboxignore` files is an optional step, therefore, may not be a necessary action for your case.

### Demo

[![asciicast](https://asciinema.org/a/384964.svg)](https://asciinema.org/a/384964)

For futher details check out the [documentation](http://dropboxignore.rtfd.io/)

## How to contribute

If you wish to contribute, read [docs/contributing.md](docs/contributing.md) guide for further details.

---

*Logo is based on [papirus-icon-theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
