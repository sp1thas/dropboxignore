from pathlib import Path

import pytest

from dropboxignore.enums import IgnoreFile
from dropboxignore.utils.filesystem.ignorefiles import check_ignore_file


def test_check_ignore_file_success(tmp_path: Path) -> None:
    gi = tmp_path / IgnoreFile.GITIGNORE.value

    gi.touch()

    assert check_ignore_file(gi, IgnoreFile.GITIGNORE) is None


def test_check_ignore_file_failure(tmp_path: Path) -> None:
    gi = tmp_path / IgnoreFile.GITIGNORE.value

    assert not gi.exists()
    with pytest.raises(ValueError, match=f"{gi.name} does not exists$"):
        check_ignore_file(gi, IgnoreFile.GITIGNORE)

    gi.mkdir()
    assert gi.exists()
    assert gi.is_dir()

    with pytest.raises(ValueError, match=f"{gi.name} is not a file$"):
        check_ignore_file(gi, IgnoreFile.GITIGNORE)

    foo = tmp_path / "foo"
    foo.touch()

    assert foo.exists()
    assert foo.is_file()

    with pytest.raises(ValueError, match=f"{foo.name} is not a gitignore file$"):
        check_ignore_file(foo, IgnoreFile.GITIGNORE)
