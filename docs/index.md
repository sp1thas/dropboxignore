# Welcome to dropboxignore documentation

![Testing status](https://github.com/sp1thas/dropboxignore/workflows/Testing/badge.svg) ![Shellcheck status](https://github.com/sp1thas/dropboxignore/workflows/Shellcheck/badge.svg) [![Documentation Status](https://readthedocs.org/projects/dropboxignore/badge/?version=latest)](https://dropboxignore.readthedocs.io/en/latest/?badge=latest) [![Snapcraft](https://snapcraft.io/dropboxignore/badge.svg)](https://snapcraft.io/dropboxignore) ![Code style](https://img.shields.io/badge/code%20style-google-%234285F4)

![main-photo](static/main.jpeg)*Photo: Robert Capa. FRANCE. 1949. Nice. French painter, Henri MATISSE.*

Exclude files from dropbox using glob patterns and take advantage of existing `.gitignore` files.

This is a simple shell script that can be used to ignore files from dropbox using glob patterns, `.dropboxignore` files and the already existing `.gitignorefiles`. The shell script uses [this](https://help.dropbox.com/files-folders/restore-delete/ignored-files) approach to ignore the matched files.

## Features

 - Ignore folders or files based on glob patterns inside the `.dropboxignore` file.
 - Automatically generate `.dropboxignore` files based on existing `.gitignore` files.
 - Ignore specific folders or files via CLI.
 - Revert ignored folders or files.
 - Delete `.dropboxignore` files.
 - Update `.dropboxignore` files when changes are detected in corresponding `.gitignore` files.
 - List ignored files and folders.
