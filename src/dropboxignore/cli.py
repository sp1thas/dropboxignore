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
        from dropboxignore.commands.generate import GenerateCommand
        from dropboxignore.filterers.gitignore import GitIgnoreFilterer

        cmd = GenerateCommand(path=path, filterer=GitIgnoreFilterer)
        cmd.run()

    def list(self, path: str = ".", v: int = 1):
        """List ignored files and folders under the given path."""
        pass

    def delete(self, path: str = ".", v: int = 1):
        """Delete specific .dropboxignore file or every .dropboxignore file under the given path."""
        from dropboxignore.commands.delete import DeleteCommand
        from dropboxignore.filterers.dropboxignore import DropboxIgnoreFilterer

        cmd = DeleteCommand(path=path, filterer=DropboxIgnoreFilterer)
        cmd.run()

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
