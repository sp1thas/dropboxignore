from functools import partial
from pathlib import Path

import fire

from dropboxignore import PACKAGE_NAME


class Cli:
    def __init__(self, path: str, verbose: bool = False, dryrun: bool = False):
        self.path = Path(path)
        self.verbose = verbose
        self.dryrun = dryrun

    def ignore(self):
        """Ignore file or folder from dropbox under the given path."""
        self.__run_cmd("Ignore", "DropboxIgnoreMatch")

    def generate(self):
        """Generate .dropboxignore files based on existing .gitignore files."""
        self.__run_cmd("Generate", "GitIgnore")

    def list(self):
        """List ignored files and folders under the given path."""
        pass

    def delete(self):
        """Delete specific .dropboxignore file or every .dropboxignore file under the given path."""
        self.__run_cmd("Delete", "DropboxIgnore")

    def update(self):
        """Update existing .dropboxignore files if at least one .gitignore file has been changed."""
        self.__run_cmd("Update", "BothIgnore")

    def genupi(self):
        """Generate, update & ignore using one shortcut command."""
        self.__run_cmd("GenUpI", "DropboxIgnoreMatch")

    def revert(self):
        """Revert ignored file or folder under the given path."""
        self.__run_cmd("Revert", "DropboxIgnoreMatch")

    def __run_cmd(self, command: str, filterer: str):
        import importlib

        commands_mod = importlib.import_module("dropboxignore.commands")
        filters_mod = importlib.import_module("dropboxignore.filterers")
        command_cls = getattr(commands_mod, f"{command}Command")
        filterer_cls = getattr(filters_mod, f"{filterer}Filterer")
        command_cls(path=self.path, filterer=filterer_cls).run()


cli_partial: partial = partial(fire.Fire, Cli, name=PACKAGE_NAME)

if __name__ == "__main__":
    cli_partial()
