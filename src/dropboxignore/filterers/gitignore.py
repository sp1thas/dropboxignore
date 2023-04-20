from dropboxignore.enums import IgnoreFile
from dropboxignore.filterers import BaseFilterer


class GitIgnoreFilterer(BaseFilterer):
    def __iter__(self):
        yield from self.path.rglob(IgnoreFile.GITIGNORE.value)
