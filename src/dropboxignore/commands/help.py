from pathlib import Path

from dropboxignore.commands.base import BaseCommand


class HelpCommand(BaseCommand):
    def run_on_item_path(self, item_path: Path) -> None:
        pass

    def run_report(self) -> str:
        return f"Help message"
