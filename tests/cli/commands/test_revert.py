from dropboxignore.cli import _cli_partial as cli
from pathlib import Path


def test_revert_success(tmp_path: Path) -> None:
    cli(command=f"revert {tmp_path.absolute()}")
