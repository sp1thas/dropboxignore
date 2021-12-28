# dropboxignore documentation

<div align="center">
It's all about the missing <code>.dropboxignore</code> file.
<br><br/>
<img alt="doc-main-photo" src="static/main.jpeg" style="width: 75%;">
  <br>
    <em>Photo: Robert Capa. FRANCE. 1949. Nice. French painter, Henri MATISSE.</em>
</div>


## Overview

This CLI shell script aims to leverage glob patterns and existing `.gitignore` files in order to exclude specific 
folders and files from :material-dropbox: dropbox sync. The shell script uses 
[this recent](https://help.dropbox.com/files-folders/restore-delete/ignored-files) approach to ignore the matched 
folders and files.

## Features

This tool provides the following usage features:

 - Ignore folders or files based on glob patterns inside the `.dropboxignore` file.
 - Automatically generate `.dropboxignore` files based on existing `.gitignore` files.
 - Ignore specific folders or files via CLI.
 - Revert ignored folders or files.
 - Delete `.dropboxignore` files.
 - List ignored files and folders.
