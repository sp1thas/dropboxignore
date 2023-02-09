from pathlib import Path

from src.commands.base import BaseCommand


class RevertCommand(BaseCommand):
    def run_on_item_path(self, item_path: Path) -> None:
        pass

    def run_report(self) -> str:
        return f"Number of reverted files: {self.c.reverted}"
