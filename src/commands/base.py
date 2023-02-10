from abc import ABC, abstractmethod
from dataclasses import dataclass
from pathlib import Path

from filterer import BaseFilterer


@dataclass
class Counter:
    deleted: int = 0
    generated: int = 0
    ignored: int = 0
    reverted: int = 0
    listed: int = 0
    updated: int = 0


class BaseCommand(ABC):
    path: Path
    c: Counter

    def __init__(self, path: str) -> None:
        self.c = Counter()
        self.path = Path(path)
        self.filterer = BaseFilterer(self.path)

    @abstractmethod
    def run_report(self) -> str:
        pass

    @abstractmethod
    def run_on_item_path(self, item_path: Path) -> None:
        pass

    def run(self):
        for item_path in self.filterer.filter():
            self.run_on_item_path(item_path)
        print(self.run_report())
