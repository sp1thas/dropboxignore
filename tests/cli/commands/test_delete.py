from dropboxignore.cli import _cli_partial as cli
from pathlib import Path


def test_delete_success(tmp_path: Path) -> None:
    cli(command=f"delete {tmp_path.absolute()}")
