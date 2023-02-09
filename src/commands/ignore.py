from pathlib import Path

from src.commands.base import BaseCommand


class Ignorer:
    def __init__(self):
        pass


class IgnoreCommand(BaseCommand):
    def run_on_item_path(self, item_path: Path) -> None:
        pass

    def run_report(self) -> str:
        return f"Number of ignored files: {self.c.ignored}"
