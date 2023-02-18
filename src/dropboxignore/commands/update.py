from pathlib import Path

from dropboxignore.commands.base import BaseCommand
from dropboxignore.commands.generate import _copy_content
from dropboxignore.enums import IgnoreFile
from dropboxignore.utils.filesystem.ignorefiles import check_ignore_file


class UpdateCommand(BaseCommand):
    def run_on_item_path(self, item_path: Path) -> None:
        gi = item_path / IgnoreFile.GITIGNORE.value
        di = item_path / IgnoreFile.DROPBOXIGNORE.value

        check_ignore_file(gi, IgnoreFile.GITIGNORE)
        check_ignore_file(di, IgnoreFile.DROPBOXIGNORE)

        _copy_content(gi, di)
        self.c.updated += 1

    def run_report(self) -> str:
        return f"Number of updated files: {self.c.updated}"
