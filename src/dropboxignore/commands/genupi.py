from pathlib import Path

from dropboxignore.commands.base import BaseCommand


class GenUpICommand(BaseCommand):
    def run_on_item_path(self, item_path: Path) -> None:
        pass

    def run_report(self) -> str:
        return (
            f"Number of generate files: {self.c.deleted}\n"
            f"Number of updated files: {self.c.deleted}\n"
            f"Number of ignored files: {self.c.deleted}\n"
        )
