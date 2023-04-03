from pathlib import Path

from dropboxignore.commands.base import BaseCommand
from dropboxignore.ignorer import _get_ignorer


class RevertCommand(BaseCommand):
    def __init__(self, path: str):
        super().__init__(path=path)
        self.ignorer = _get_ignorer()()

    def run_on_item_path(self, item_path: Path) -> None:
        self.ignorer.revert(path=item_path)
        self.c.reverted += 1

    def run_report(self) -> str:
        return f"Number of ignored files: {self.c.reverted}"
