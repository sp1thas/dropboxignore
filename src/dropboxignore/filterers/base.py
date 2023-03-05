from abc import abstractmethod
from pathlib import Path


class BaseFilterer:
    def __init__(self, path: Path):
        self.path = path

    @abstractmethod
    def __iter__(self):
        pass
