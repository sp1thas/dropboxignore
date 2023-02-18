from dropboxignore.filterers.base import BaseFilterer
from dropboxignore.enums import IgnoreFile


class BothIgnoreFilterer(BaseFilterer):
    def __iter__(self):
        for gi_path in self.path.glob(f"**/*{IgnoreFile.GITIGNORE.value}"):
            folder_path = gi_path.parent
            if (folder_path / IgnoreFile.DROPBOXIGNORE.value).exists():
                yield folder_path
