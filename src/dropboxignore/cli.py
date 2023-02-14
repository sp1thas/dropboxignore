from functools import partial

import fire

from dropboxignore import NAME


class Cli:
    def ignore(self, path: str = ".", v: int = 1):
        """Ignore file or folder from dropbox under the given path.

        :param v: Whatever
        :param path: name of the user
        """
        pass

    def generate(self, path: str = ".", v: int = 1):
        """Generate .dropboxignore files based on existing .gitignore files."""
        pass

    def list(self, path: str = ".", v: int = 1):
        """List ignored files and folders under the given path."""
        pass

    def delete(self, path: str = ".", v: int = 1):
        """Delete specific .dropboxignore file or every .dropboxignore file under the given path."""
        pass

    def update(self, path: str = ".", v: int = 1):
        """Update existing .dropboxignore files if at least one .gitignore file has been changed."""

    def genupi(self, path: str = ".", v: int = 1):
        """Generate, update & ignore using one shortcut command."""
        pass

    def revert(self, path: str = ".", v: int = 1):
        """Revert ignored file or folder under the given path."""
        pass


_cli_partial = partial(fire.Fire, Cli, name=NAME)

if __name__ == "__main__":
    _cli_partial()
