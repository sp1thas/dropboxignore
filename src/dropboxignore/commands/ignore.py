from pathlib import Path
from typing import Union, Type

from dropboxignore.commands.base import BaseCommand
from dropboxignore.filterers.base import BaseFilterer
from dropboxignore.ignorer import _get_ignorer


class IgnoreCommand(BaseCommand):
    def __init__(
        self, path: Union[str, Path], filterer: Type[BaseFilterer] = BaseFilterer
    ) -> None:
        super().__init__(path=path, filterer=filterer)
        self.ignorer = _get_ignorer()()

    def run_on_item_path(self, item_path: Path) -> None:
        self.ignorer.ignore(path=item_path)
        self.c.ignored += 1

    def run_report(self) -> str:
        return f"Number of ignored files: {self.c.ignored}"
