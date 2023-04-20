from pathlib import Path

from dropboxignore.enums import IgnoreFile
from dropboxignore.filterers import GitIgnoreFilterer


def test_gitignore_filterer(tmp_path: Path) -> None:
    gi_1 = tmp_path.joinpath(IgnoreFile.GITIGNORE.value)
    gi_1.touch()

    gi_2 = tmp_path.joinpath("foo", IgnoreFile.GITIGNORE.value)

    gi_2.parent.mkdir()
    gi_2.touch()

    filterer = GitIgnoreFilterer(path=tmp_path)
    matches = set(filterer)

    assert len(matches) == 2
    assert matches == {gi_2, gi_1}
