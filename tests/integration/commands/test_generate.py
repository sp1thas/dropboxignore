from dropboxignore.cli import _cli_partial as cli
from pathlib import Path
from dropboxignore.enums import IgnoreFile


def test_delete_success(tmp_path: Path) -> None:
    gi = tmp_path / IgnoreFile.GITIGNORE.value
    di = tmp_path / IgnoreFile.DROPBOXIGNORE.value
    gi.touch()
    gi.write_text("*.txt\n")

    assert gi.exists()
    assert not di.exists()

    cli(command=f"generate {tmp_path.absolute()}")

    assert di.exists()
