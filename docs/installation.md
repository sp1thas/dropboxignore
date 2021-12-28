Below you will find all the available installation options. `dropboxignore` is currently available only for macOS and 
Linux systems.  For macOS, Homebrew is required.

## Using the kickstart script

=== "cURL"

    ```shell
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/sp1thas/dropboxignore/master/utils/install.sh)"
    ```

=== "Wget"

    ```shell
    sudo sh -c "$(wget -qO- https://raw.githubusercontent.com/sp1thas/dropboxignore/master/utils/install.sh)"
    ```

=== "fetch"

    ```
    sudo sh -c "$(fetch -o - https://raw.githubusercontent.com/sp1thas/dropboxignore/master/utils/install.sh)"
    ```

## Snap


[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-white.svg)](https://snapcraft.io/dropboxignore)

```shell
$ snap install dropboxignore
```

## From Source

!!! note
    Make source that the following packages are installed in your system: `git`, `attr`

```shell
$ git clone https://github.com/sp1thas/dropboxignore.git
$ cd dropboxignore
$ make test  # optional step, bats should be in your PATH
$ sudo make install
```
