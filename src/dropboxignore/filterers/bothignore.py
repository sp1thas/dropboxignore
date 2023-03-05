from dropboxignore.enums import IgnoreFile
from dropboxignore.filterers.base import BaseFilterer


class BothIgnoreFilterer(BaseFilterer):
    def __iter__(self):
        for gi_path in self.path.rglob(IgnoreFile.GITIGNORE.value):
            folder_path = gi_path.parent
            if (folder_path / IgnoreFile.DROPBOXIGNORE.value).exists():
                yield folder_path
