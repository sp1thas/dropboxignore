from pathlib import Path

from dropboxignore.enums import IgnoreFile
from dropboxignore.filterers.dropboxignore import (
    DropboxIgnoreFilterer,
    DropboxIgnoreMatchFilterer,
)


def test_dropboxignore_filterer(tmp_path: Path) -> None:
    di_1 = tmp_path / IgnoreFile.DROPBOXIGNORE.value
    di_1.touch()

    di_2 = tmp_path / "foo" / IgnoreFile.DROPBOXIGNORE.value

    di_2.parent.mkdir()
    di_2.touch()

    filterer = DropboxIgnoreFilterer(path=tmp_path)
    matches = set(filterer)

    assert len(matches) == 2
    assert matches == {di_2, di_1}


def test_dropboxignore_match_filterer(tmp_path: Path) -> None:
    di = tmp_path / IgnoreFile.DROPBOXIGNORE.value
    di.touch()
    di.write_text(f"*.txt\nfoo/*.json\n")

    txt_file = tmp_path / "random.txt"
    txt_file.touch()

    json_file = tmp_path / "foo" / "random.json"

    json_file.parent.mkdir()
    json_file.touch()

    filterer = DropboxIgnoreMatchFilterer(path=tmp_path)
    matches = set(filterer)

    assert len(matches) == 2
    assert matches == {txt_file, json_file}
