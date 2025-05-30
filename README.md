<div align="center">
    <h1>dropboxignore</h1>
    <img src="https://codeberg.org/sp1thas/dropboxignore/raw/branch/master/docs/static/icons/128.png" alt="dropboxignore-logo">
    <p>It's all about the missing <code>.dropboxignore</code> file.</p>
    <a href="https://ci.codeberg.org/repos/14141" target="_blank">
        <img src="https://ci.codeberg.org/api/badges/14141/status.svg" alt="status-badge" />
    </a>
    <a href="https://codecov.io/gh/sp1thas/dropboxignore">
    <img src="https://codecov.io/gh/sp1thas/dropboxignore/branch/master/graph/badge.svg?token=LBVA80F2DV"/>
    </a>
    <a href="https://snapcraft.io/dropboxignore">
        <img alt="dropboxignore" src="https://snapcraft.io/dropboxignore/badge.svg" />
    </a>
    <img src="https://img.shields.io/badge/code%20style-google-%234285F4" alt="Google code style">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fwiki%2Fsp1thas%2Fdropboxignore%2Flatest%2Dstats.json" alt="Installation counter">

<hr>

[Installation](#installation) •
[Getting started](#getting-started) •
[CLI](#cli) •
[How to Contribute](#how-to-contribute)

</div>


This CLI shell script aims to take advantage of glob patterns and existing `.gitignore` files in order to exclude specific
folders and files from dropbox sync. The shell script uses
[this recent](https://help.dropbox.com/files-folders/restore-delete/ignored-files) approach to ignore folders and files.

## Installation

### Using the kickstart script

dropboxignore is installed by running one of the following commands in your terminal. You can install this via the command-line with either curl, wget or another similar tool. `attr` and `git` should be installed on your system, as well as Homebrew if you are on macOS.

| Method | Command                                                        |
|--------|----------------------------------------------------------------|
| curl   | <code>sudo sh -c "$(curl -fsSL https://rb.gy/nnp9p9)" c</code> |
| wget   | <code>sudo sh -c "$(wget -qO- https://rb.gy/nnp9p9)" w</code>  |

Worried about mysterious shorted urls like? Take a look at the installation script here: [`https://rb.gy/nnp9p9 --> https://codeberg.org/sp1thas/dropboxignore/raw/branch/master/src/utils/install.sh`](https://codeberg.org/sp1thas/dropboxignore/raw/branch/master/src/utils/install.sh))
### Snap

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-white.svg)](https://snapcraft.io/dropboxignore)

```shell
$ snap install dropboxignore
```

### Flatpak

```shell
$ flatpak install flathub me.simakis.dropboxignore
```

### From source
```shell
$ git clone https://codeberg.org/sp1thas/dropboxignore.git
$ cd dropboxignore
$ make test  # optional step, Docker and docker-compose should be installed
$ sudo make install
```

### Uninstall
```shell
$ sudo make uninstall
```

## Getting started

`dropboxignore` is a CLI tool which supports a collection of commands in order to make your life easier when it comes
to exclude files or/and folders from :material-dropbox: dropbox sync. Below you will find some common usecases.

### A typical workflow

A common workflow could be the following:

 1. Automatically generate `.dropboxignore` files based on existing `.gitignore` files.
 2. Manually update or create `.dropboxignore` files (Optional).
 3. Ignore matched files based on .dropboxignore files.

and you can run this flow by running the following command:

```shell
$ dropboxignore genupi .
```

**Warning:** In order to prevent unpleasant data losses, exception patterns are not supported. Both `.gitignore` and
`.dropboxignore` files with at least one exceptional pattern will be bypassed (for further details:
[#3](https://codeberg.org/sp1thas/dropboxignore/issues/3)).

**Note:** Automatic generation of `.dropboxignore` files is an optional step, therefore, may not be a necessary action
for your case.

### Long story short

[Here](https://sp1thas.codeberg.page/dropboxignore/getting-started/#long-story-short) you can find some of the most common cases
that dropboxignore could be useful.

## CLI

[Here](https://sp1thas.codeberg.page/dropboxignore/cli) you will find extensive documentation about the dropboxignore command line
interface.

## How to contribute

If you want to contribute, read the [contribution guideline](https://sp1thas.codeberg.page/dropboxignore/contributing) for
further details.

---

*Logo is based on [papirus-icon-theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
