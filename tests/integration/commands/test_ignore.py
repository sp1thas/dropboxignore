from dropboxignore.cli import _cli_partial as cli
from pathlib import Path


def test_ignore_success(tmp_path: Path) -> None:
    cli(command=f"ignore {tmp_path.absolute()}")
