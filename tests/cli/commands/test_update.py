from dropboxignore.cli import _cli_partial as cli
from pathlib import Path


def test_update_success(tmp_path: Path) -> None:
    cli(command=f"update {tmp_path.absolute()}")
