from dropboxignore.cli import _cli_partial as cli
from pathlib import Path


def test_generate_success(tmp_path: Path) -> None:
    cli(command=f"generate {tmp_path.absolute()}")
