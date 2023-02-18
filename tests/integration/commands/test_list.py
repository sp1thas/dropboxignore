from dropboxignore.cli import _cli_partial as cli
from pathlib import Path


def test_list_success(tmp_path: Path) -> None:
    cli(command=f"list {tmp_path.absolute()}")
