Below you will find all the available installation options. `dropboxignore` is currently available only for macOS and
Linux systems.  For macOS, Homebrew is required.


=== "Kickstart script"


    === "cURL"

        ```bash
        sudo sh -c "$(curl -fsSL https://rb.gy/g4plll)" c
        ```

    === "Wget"

        ```bash
        sudo sh -c "$(wget -qO- https://rb.gy/g4plll)" w
        ```

    Worried about mysterious shorted urls like? Take a look at the installation script here: [`https://rb.gy/g4plll`](https://rb.gy/g4plll) --> [`https://raw.githubusercontent.com/sp1thas/.../install.sh`](https://raw.githubusercontent.com/sp1thas/dropboxignore/master/src/utils/install.sh)

=== "Snap"

    ```bash
    snap install dropboxignore
    ```

=== "Flatpak"

    ```bash
    flatpak install me.simakis.dropboxignore
    ```

=== "From source"

    !!! note
        Make source that the following packages are installed in your system: `git`, `attr`

    ```bash
    git clone https://github.com/sp1thas/dropboxignore.git
    cd dropboxignore
    make shell-tests  # optional step, bats should be in your PATH
    sudo make install
    ```
