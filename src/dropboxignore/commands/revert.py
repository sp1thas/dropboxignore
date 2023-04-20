from pathlib import Path
from typing import Type, Union

from dropboxignore.commands import BaseCommand
from dropboxignore.filterers import BaseFilterer
from dropboxignore.ignorer import _get_ignorer


class RevertCommand(BaseCommand):
    def __init__(
        self, path: Union[str, Path], filterer: Type[BaseFilterer] = BaseFilterer
    ) -> None:
        super().__init__(path=path, filterer=filterer)
        self.ignorer = _get_ignorer()()

    def run_on_item_path(self, item_path: Path) -> None:
        self.ignorer.revert(path=item_path)
        self.c.reverted += 1

    def run_report(self) -> str:
        return f"Number of ignored files: {self.c.reverted}"
