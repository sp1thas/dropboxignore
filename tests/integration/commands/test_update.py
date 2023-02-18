from pathlib import Path

from pytest import CaptureFixture

from dropboxignore.cli import _cli_partial as cli
from dropboxignore.enums import IgnoreFile


def test_update_success(tmp_path: Path, capfd: CaptureFixture) -> None:
    gi = tmp_path / IgnoreFile.GITIGNORE.value
    gi.touch()
    gi.write_text("*.txt")
    di = tmp_path / IgnoreFile.DROPBOXIGNORE.value
    di.touch()

    cli(command=f"update {tmp_path.absolute()}")

    out, err = capfd.readouterr()
    assert out == "Number of updated files: 1\n"
    assert err == ""
