from dropboxignore.cli import _cli_partial as cli
from pathlib import Path
from dropboxignore.enums import IgnoreFile


def test_delete_success(tmp_path: Path) -> None:
    di = tmp_path / IgnoreFile.DROPBOXIGNORE.value
    di.touch()

    assert di.exists()

    a = cli(command=f"delete {tmp_path.absolute()}")

    print(a)
    assert not di.exists()
