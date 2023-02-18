import datetime
import pathlib
from pathlib import Path

from dropboxignore.commands.base import BaseCommand
from dropboxignore.enums import IgnoreFile
from dropboxignore.utils.filesystem.ignorefiles import check_ignore_file

HEADER = (
    "# ----\n" "# Automatically Generated .dropboxignore file at {date}\n" "# ----\n"
)


def _copy_content(gi: pathlib.Path, di: pathlib.Path) -> None:
    di.write_text(
        HEADER.format(date=datetime.date.today().strftime("%Y-%m-%d")) + gi.read_text()
    )


class GenerateCommand(BaseCommand):
    def run_on_item_path(self, item_path: Path) -> None:
        check_ignore_file(item_path, IgnoreFile.GITIGNORE)

        di = item_path.parent / IgnoreFile.DROPBOXIGNORE.value

        if di.exists():
            raise ValueError(f"{di} already exists")

        _copy_content(item_path, di)
        self.c.generated += 1

    def run_report(self) -> str:
        return f"Number of generated files: {self.c.generated}"
