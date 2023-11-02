from pathlib import Path

from dropboxignore.cli import cli_partial as cli
import pytest


def test_list_success(tmp_path: Path) -> None:
    with pytest.raises(NotImplementedError):
        cli(command=f"--path '{tmp_path}' list")
