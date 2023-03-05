from pathlib import Path

from dropboxignore.cli import cli_partial as cli


def test_list_success(tmp_path: Path) -> None:
    cli(command=f"--path '{tmp_path}' list")
