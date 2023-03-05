import os
from pathlib import Path

from pytest import CaptureFixture

from dropboxignore.cli import cli_partial as cli
from dropboxignore.enums import IgnoreFile
from dropboxignore.utils.filesystem.common import write_text


def test_update_success(tmp_path: Path, capfd: CaptureFixture) -> None:
    gi = tmp_path / IgnoreFile.GITIGNORE.value
    gi.touch()
    write_text(gi, "*.txt")
    di = tmp_path / IgnoreFile.DROPBOXIGNORE.value
    di.touch()

    cli(command=f"--path {tmp_path.absolute()} update")

    out, err = capfd.readouterr()
    assert out == f"Number of updated files: 1{os.linesep}"
    assert err == ""
