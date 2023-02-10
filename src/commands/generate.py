from pathlib import Path

from src.commands.base import BaseCommand
from src.enums import IgnoreFiles


class GenerateCommand(BaseCommand):
    def run_on_item_path(self, item_path: Path) -> None:
        if not item_path.name == IgnoreFiles.DROPBOXIGNORE.value:
            raise ValueError(f"{item_path} is not a dropbox ignore file")
        try:
            item_path.touch(exist_ok=False)
            self.c.generated += 1
        except FileExistsError:
            pass

    def run_report(self) -> str:
        return f"Number of generated files: {self.c.generated}"
