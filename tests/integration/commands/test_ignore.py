from dropboxignore.cli import cli_partial as cli
from pathlib import Path


def test_ignore_success(tmp_path: Path) -> None:
    cli(command=f"--path {tmp_path.absolute()} ignore")
