# dropboxignore

A tiny CLI utility to keep unwanted files and folders out of your Dropbox sync, using familiar glob patterns and your existing .gitignore files.

[CI Status](https://ci.codeberg.org/repos/14141) • [Coverage](https://codecov.io/gh/sp1thas/dropboxignore) • [Docs](https://sp1thas.codeberg.page/dropboxignore) • [Snap](https://snapcraft.io/dropboxignore)

## Features

- Use glob patterns in .dropboxignore files to ignore folders and files.
- Auto-generate .dropboxignore from existing .gitignore files (no exception patterns allowed for safety).
- One-shot command to generate, update, and ignore (genupi).
- Revert previously ignored paths.
- List ignored items and delete .dropboxignore files when needed.

> Note: The .dropboxignore file is used by this tool to instruct Dropbox to ignore matches. It is not used by Dropbox itself.

## Installation

See the full Installation guide for more options and details: https://sp1thas.codeberg.page/dropboxignore/installation

### Kickstart script

| Method | Command                                                        |
|--------|----------------------------------------------------------------|
| curl   | <code>sudo sh -c "$(curl -fsSL https://rb.gy/nnp9p9)" c</code> |
| wget   | <code>sudo sh -c "$(wget -qO- https://rb.gy/nnp9p9)" w</code>  |

Worried about the short URL? It points to this script: https://codeberg.org/sp1thas/dropboxignore/raw/branch/master/src/utils/install.sh

### Snap

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-white.svg)](https://snapcraft.io/dropboxignore)

```shell
snap install dropboxignore
```

### Flatpak
```shell
flatpak install flathub me.simakis.dropboxignore`
```

### From source
```shell
git clone https://codeberg.org/sp1thas/dropboxignore.git`
cd dropboxignore`
make test   # optional; requires Docker and docker-compose`
sudo make install
```

### Uninstall
```shell
sudo make uninstall
```

## Quickstart

A typical workflow:

1. Generate .dropboxignore files from .gitignore files.
2. Optionally edit or add your own .dropboxignore files.
3. Ignore matched files based on .dropboxignore files.

Run the whole flow with one command:

- dropboxignore genupi .

Important warning: To prevent data loss, exception patterns are not supported. Any .gitignore or .dropboxignore file that contains at least one exception pattern will be skipped. Details: https://codeberg.org/sp1thas/dropboxignore/issues/3

More examples and tips: https://sp1thas.codeberg.page/dropboxignore/getting-started/


## Command Line Interface

Full CLI reference with examples and screenshots: https://sp1thas.codeberg.page/dropboxignore/cli

A few screenshots from the docs:

![generate example](docs/static/screenshots/generate.png)
![ignore example](docs/static/screenshots/ignore.png)
![list example](docs/static/screenshots/list.png)


## Contributing

We welcome contributions of all kinds. Please read the contribution guide: https://sp1thas.codeberg.page/dropboxignore/contributing


## License

This project is licensed under the MIT License. See the LICENSE file for details.


## Acknowledgements

- Logo is based on papirus-icon-theme: https://github.com/PapirusDevelopmentTeam/papirus-icon-theme
