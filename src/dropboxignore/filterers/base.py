import pathlib
from typing import Union


class BaseFilterer:
    def __init__(self, path: Union[str, pathlib.Path]):
        self.path = pathlib.Path(path) if isinstance(path, str) else path

    def __iter__(self):
        raise NotImplementedError
