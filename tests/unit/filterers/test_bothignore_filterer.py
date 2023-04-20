from pathlib import Path

from dropboxignore.enums import IgnoreFile
from dropboxignore.filterers import BothIgnoreFilterer


def test_bothignore_filterer(tmp_path: Path) -> None:
    gi_1 = tmp_path.joinpath(IgnoreFile.GITIGNORE.value)
    di_1 = tmp_path.joinpath(IgnoreFile.DROPBOXIGNORE.value)
    gi_1.touch()
    di_1.touch()

    gi_2 = tmp_path.joinpath("foo", IgnoreFile.GITIGNORE.value)
    di_2 = tmp_path.joinpath("foo", IgnoreFile.DROPBOXIGNORE.value)

    gi_2.parent.mkdir()
    gi_2.touch()
    di_2.touch()

    filterer = BothIgnoreFilterer(path=tmp_path)
    matches = set(filterer)

    assert len(matches) == 2
    assert matches == {tmp_path, gi_2.parent}
