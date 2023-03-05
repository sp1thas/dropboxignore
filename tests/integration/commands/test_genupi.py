from pathlib import Path

from dropboxignore.cli import cli_partial as cli


def test_genupi_success(tmp_path: Path) -> None:
    cli(command=f"--path '{tmp_path}' genupi")
