from pathlib import Path

from pytest import CaptureFixture

from dropboxignore.cli import _cli_partial as cli
from dropboxignore.enums import IgnoreFile


def test_delete_success(tmp_path: Path, capfd: CaptureFixture) -> None:
    di = tmp_path / IgnoreFile.DROPBOXIGNORE.value
    di.touch()

    cli(command=f"delete {tmp_path.absolute()}")

    out, err = capfd.readouterr()
    assert out == "Number of deleted files: 1\n"
    assert err == ""
