from pathlib import Path

from pytest import CaptureFixture

from dropboxignore.cli import cli_partial as cli
from dropboxignore.enums import IgnoreFile
import os


def test_delete_success(tmp_path: Path, capfd: CaptureFixture) -> None:
    di = tmp_path / IgnoreFile.DROPBOXIGNORE.value
    di.touch()

    print(f">>>>>>>>>>>> {tmp_path}")
    print(f">>>>>>>>>>>>> {di}")
    print(f">>>>>>>>>>>>>> --path {tmp_path.absolute()} delete")

    cli(command=f"--path {tmp_path.absolute()} delete")

    out, err = capfd.readouterr()
    print(f">>>>>>>>>>>>>>> {err}")
    assert f"Number of deleted files: 1{os.linesep}" in out
    assert err == ""
