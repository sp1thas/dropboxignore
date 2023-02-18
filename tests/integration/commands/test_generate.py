from pathlib import Path

from pytest import CaptureFixture

from dropboxignore.cli import _cli_partial as cli
from dropboxignore.enums import IgnoreFile


def test_generate_success(tmp_path: Path, capfd: CaptureFixture) -> None:
    gi = tmp_path / IgnoreFile.GITIGNORE.value
    gi.touch()

    cli(command=f"generate {tmp_path.absolute()}")

    out, err = capfd.readouterr()
    assert out == "Number of generated files: 1\n"
    assert err == ""
