# Welcome to dropboxignore documentation

<div align="center">
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
<br>
<img alt="doc-main-photo" src="static/main.jpeg">
  <br>
    <em>Photo: Robert Capa. FRANCE. 1949. Nice. French painter, Henri MATISSE.</em>
</div>

Exclude files from your [dropbox](https://www.dropbox.com) using glob patterns and take advantage of existing `.gitignore` files.

This is a simple shell script that can be used to ignore files from dropbox using glob patterns, `.dropboxignore` files and the already existing `.gitignorefiles`. The shell script uses [this](https://help.dropbox.com/files-folders/restore-delete/ignored-files) approach to ignore the matched files.

## Features

 - Ignore folders or files based on glob patterns inside the `.dropboxignore` file.
 - Automatically generate `.dropboxignore` files based on existing `.gitignore` files.
 - Ignore specific folders or files via CLI.
 - Revert ignored folders or files.
 - Delete `.dropboxignore` files.
 - Update `.dropboxignore` files when changes are detected in corresponding `.gitignore` files.
 - List ignored files and folders.
