from pathlib import Path
from typing import Iterator

from dropboxignore.enums import IgnoreFile
from dropboxignore.filterers.base import BaseFilterer


class DropboxIgnoreFilterer(BaseFilterer):
    def __iter__(self):
        yield from self.path.glob(f"**/*{IgnoreFile.DROPBOXIGNORE.value}")


def _parse_ignore_file(path: Path) -> Iterator[str]:
    for l in path.open().readlines():
        line = l.strip()
        if line.startswith("#"):
            continue
        if line.startswith("!"):
            continue
        yield line


class DropboxIgnoreMatchFilterer(BaseFilterer):
    def __iter__(self):
        matches = set()
        for di in self.path.glob(f"**/*{IgnoreFile.DROPBOXIGNORE.value}"):
            folder = di.parent
            for pattern in _parse_ignore_file(di):
                print(pattern)
                for item in folder.glob(pattern):
                    if (abs_path_str := str(item.absolute())) in matches:
                        continue
                    matches.add(abs_path_str)
                    yield item
