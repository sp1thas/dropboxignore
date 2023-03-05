from pathlib import Path

from dropboxignore.enums import IgnoreFile


def check_ignore_file(path: Path, ignore_file_type: IgnoreFile) -> None:
    if not path.name == ignore_file_type.value:
        raise ValueError(f"{path} is not a gitignore file")
    if not path.exists():
        raise ValueError(f"{path} does not exists")
    if not path.is_file():
        raise ValueError(f"{path} is not a file")
