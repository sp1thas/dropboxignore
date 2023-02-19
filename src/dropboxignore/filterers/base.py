from abc import abstractmethod
from pathlib import Path
from typing import Union


class BaseFilterer:
    def __init__(self, path: Union[str, Path]):
        self.path = Path(path) if isinstance(path, str) else path

    @abstractmethod
    def __iter__(self):
        pass
