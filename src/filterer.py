import os

from enums import IgnoreFiles
import pathlib
from abc import ABC, abstractmethod
from itertools import chain
from typing import Iterator, Tuple


class BaseFilterer(ABC):
    def __init__(self, base_path: pathlib.Path):
        self.base_path = base_path

    @abstractmethod
    def filter(self) -> Iterator[pathlib.Path]:
        for _ in []:
            yield pathlib.Path(".")


class IgnoreFileMatchingFilterer(BaseFilterer):
    def __init__(self, base_path: pathlib.Path, ignore_file_name: IgnoreFiles):
        super().__init__(base_path=base_path)
        self.ignore_file_name = ignore_file_name

    def filter(self) -> Iterator[pathlib.Path]:
        for ignore_file in self.base_path.glob(self.ignore_file_name.value):
            current_folder = ignore_file.parent
            for pattern in self._parse_ignore_file(ignore_file):
                for file_path in current_folder.glob(pattern):
                    yield file_path

    @staticmethod
    def _parse_ignore_file(ignore_file: pathlib.Path) -> Iterator[str]:
        for l in ignore_file.read_text().split(os.linesep):
            line = l.strip()
            if not line:
                continue
            if line.startswith("#"):
                continue
            if line.startswith("!"):
                continue
            yield line
