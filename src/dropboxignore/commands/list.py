from pathlib import Path

from dropboxignore.commands.base import BaseCommand


class ListCommand(BaseCommand):
    def run_on_item_path(self, item_path: Path) -> None:
        pass

    def run_report(self) -> str:
        return f"Number of listed files: {self.c.listed}"
