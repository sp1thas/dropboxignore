from dropboxignore.cli import _cli_partial as cli
from pathlib import Path


def test_genupi_success(tmp_path: Path) -> None:
    cli(command=f"genupi {tmp_path.absolute()}")
