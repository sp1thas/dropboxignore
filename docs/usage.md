# Usage

dropboxignore is a CLI tool which support a collection of commands in order to make your life easier when it comes to ignore files or/and folders from dropbox. Below you will find the list of supported commands. For every command, a description and an example will be provided.

A common workflow could be the following

 1. Automatically generate `.dropboxignore` files based on existing `.gitignore` files.
 2. Manually update or create `.dropboxignore` files (Optional).
 3. Ignore matched files based on .dropboxignore files.

!!! warning "Important warning"
    In order to prevent unpleasant data losses, exception patterns are not supported. Both `.gitignore` and `.dropboxignore` files with at least one exceptional pattern will be bypassed (for further details: [#3](https://github.com/sp1thas/dropboxignore/issues/3)).

!!! note "Keep in mind"
    Automatic generation of `.dropboxignore` files is an optional step, therefore, may not be a necessary action for your case.


## TL;DR

Below you will find some of the most common cases that dropboxignore could be useful.

=== "Node.js"

    ![node_modules_meme](./static/node.jpg)
    ```shell
    $ dropboxignore ignore ./node_modules
    ```

=== "Python"

    ![python_venv](./static/python.jpg)
    ```shell
    $ dropboxignore ignore ./venv
    ```

## Synopsis

```shell
$ dropboxignore <command> <path> [parameters]
```

## `generate`

Generated `dropboxignore` files based on the given path. If a `.dropboxignore` already exists, will not be modified. If a `.gitignore` file contains at least one exception pattern, the corresponding`.dropboxignore` file will not be created.

**Example:**

```shell
$ tree . -a
.
└── .gitignore

0 directories, 1 file
$ dropboxignore generate .
 Created file: .dropboxignore 

Total number of generated files: 1 
$ tree . -a
.
├── .dropboxignore
└── .gitignore
```

## `ignore`

Ignores all matched folder or files under the given path using existing `.dropboxignore` files.

**Example:**

```shell
$ echo '*.txt' > .dropboxignore 
$ touch v.txt
$ tree . -a
.
├── .dropboxignore
└── v.txt

$ dropboxignore ignore .

Total number of ignored files: 1 

```

## `list`

Lists every ignored folder and file under the given path

**Example:**

```shell
$ dropboxignore list .  
v.txt

Total number of ignored files: 1
Total number of ignored folders: 0 
```

## `revert`

Reverts every ignored file or folder under the given path. After running this command, all local files will be sync with dropbox.

**Example:**

```shell
$ dropboxignore revert .

Total number of reverted files: 1 

Total number of reverted folders: 0
```

## `delete`

Deletes all `.dropboxignore` files under the given path.

**Example:**

```shell
$ dropboxignore delete .
 Deleted files: 1
```

## `update`

## Parameters

`-v` (_verbosity level_ [0-2]) **Default**: `1`

Select a number between 0 and 2 to increase or decrease verbosity. `2` will display debug logs. `0` will display error logs only.

`-p` (_matching pattern_) **Default**: `'*'`

Provide a pattern in order to filter matched files. This option is currently available only for `list` command.