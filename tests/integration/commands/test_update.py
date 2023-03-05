from pathlib import Path

from pytest import CaptureFixture

from dropboxignore.cli import cli_partial as cli
from dropboxignore.enums import IgnoreFile


def test_update_success(tmp_path: Path, capfd: CaptureFixture) -> None:
    gi = tmp_path.joinpath(IgnoreFile.GITIGNORE.value)
    gi.touch()
    gi.write_text("*.txt")
    di = tmp_path.joinpath(IgnoreFile.DROPBOXIGNORE.value)
    di.touch()

    cli(command=f"--path {tmp_path} update")

    out, err = capfd.readouterr()
    assert out == f"Number of updated files: 1\n"
    assert err == ""
