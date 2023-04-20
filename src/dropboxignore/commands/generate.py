from pathlib import Path

from dropboxignore.commands import BaseCommand
from dropboxignore.enums import IgnoreFile
from dropboxignore.utils.filesystem.common import copy_content
from dropboxignore.utils.filesystem.ignorefiles import check_ignore_file


class GenerateCommand(BaseCommand):
    def run_on_item_path(self, item_path: Path) -> None:
        check_ignore_file(item_path, IgnoreFile.GITIGNORE)

        di = item_path.parent.joinpath(IgnoreFile.DROPBOXIGNORE.value)

        if di.exists():
            raise ValueError(f"{di} already exists")

        copy_content(item_path, di)
        self.c.generated += 1

    def run_report(self) -> str:
        return f"Number of generated files: {self.c.generated}"
