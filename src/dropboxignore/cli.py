from functools import partial

import fire

from dropboxignore import NAME


class Cli:
    def __init__(self, path: str = ".", verbose: bool = False):
        self.path = path
        self.verbose = verbose

    def ignore(self):
        """Ignore file or folder from dropbox under the given path."""
        from dropboxignore.commands.ignore import IgnoreCommand
        from dropboxignore.filterers.dropboxignore import DropboxIgnoreMatchFilterer

        cmd = IgnoreCommand(path=self.path, filterer=DropboxIgnoreMatchFilterer)
        cmd.run()

    def generate(self):
        """Generate .dropboxignore files based on existing .gitignore files."""
        from dropboxignore.commands.generate import GenerateCommand
        from dropboxignore.filterers.gitignore import GitIgnoreFilterer

        cmd = GenerateCommand(path=self.path, filterer=GitIgnoreFilterer)
        cmd.run()

    def list(self, path: str = ".", v: int = 1):
        """List ignored files and folders under the given path."""
        pass

    def delete(self):
        """Delete specific .dropboxignore file or every .dropboxignore file under the given path."""
        from dropboxignore.commands.delete import DeleteCommand
        from dropboxignore.filterers.dropboxignore import DropboxIgnoreFilterer

        cmd = DeleteCommand(path=self.path, filterer=DropboxIgnoreFilterer)
        cmd.run()

    def update(self):
        """Update existing .dropboxignore files if at least one .gitignore file has been changed."""
        from dropboxignore.commands.update import UpdateCommand
        from dropboxignore.filterers.bothignore import BothIgnoreFilterer

        cmd = UpdateCommand(path=self.path, filterer=BothIgnoreFilterer)
        cmd.run()

    def genupi(self, path: str = ".", v: int = 1):
        """Generate, update & ignore using one shortcut command."""
        pass

    def revert(self, path: str = ".", v: int = 1):
        """Revert ignored file or folder under the given path."""
        pass


cli_partial: partial = partial(fire.Fire, Cli, name=NAME)

if __name__ == "__main__":
    cli_partial()
