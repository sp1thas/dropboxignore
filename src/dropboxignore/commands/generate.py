from pathlib import Path

from dropboxignore.commands.base import BaseCommand
from dropboxignore.enums import IgnoreFile
import datetime

HEADER = (
    "# ----\n" "# Automatically Generated .dropboxignore file at {date}\n" "# ----\n"
)


class GenerateCommand(BaseCommand):
    def run_on_item_path(self, item_path: Path) -> None:
        if not item_path.name == IgnoreFile.GITIGNORE.value:
            raise ValueError(f"{item_path} is not a gitignore file")
        if not item_path.exists():
            raise ValueError(f"{item_path} does not exists")
        if not item_path.is_file():
            raise ValueError(f"{item_path} is not a file")

        di = item_path.parent / IgnoreFile.DROPBOXIGNORE.value

        if di.exists():
            raise ValueError(f"{di} already exists")

        di.write_text(
            HEADER.format(date=datetime.date.today().strftime("%Y-%m-%d"))
            + item_path.read_text()
        )
        self.c.generated += 1

    def run_report(self) -> str:
        return f"Number of generated files: {self.c.generated}"
