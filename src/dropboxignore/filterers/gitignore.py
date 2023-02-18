from dropboxignore.filterers.base import BaseFilterer
from dropboxignore.enums import IgnoreFile


class GitIgnoreFilterer(BaseFilterer):
    def __iter__(self):
        yield from self.path.glob(f"**/*{IgnoreFile.GITIGNORE.value}")
