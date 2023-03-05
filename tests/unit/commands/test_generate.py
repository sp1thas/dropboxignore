import datetime
from pathlib import Path
import os
import pytest
import re

from dropboxignore.commands.generate import GenerateCommand
from dropboxignore.enums import IgnoreFile
from dropboxignore.utils.filesystem.common import write_text, read_text


def test_generate_successful(tmp_path: Path):
    gi = tmp_path / IgnoreFile.GITIGNORE.value

    write_text(gi, "*.txt")

    di = tmp_path / IgnoreFile.DROPBOXIGNORE.value

    assert not di.exists()

    cmd = GenerateCommand(path=tmp_path)
    cmd.run_on_item_path(gi)

    assert di.exists()
    assert read_text(di) == (
        f"# ----{os.linesep}"
        f"# Automatically Generated .dropboxignore file at {{date}}{os.linesep}"
        f"# ----{os.linesep}"
        f"*.txt"
    ).format(date=datetime.date.today().strftime("%Y-%m-%d"))
    assert cmd.c.generated == 1


def test_generate_not_gitignore_file_input(tmp_path: Path):
    gi = tmp_path / "foo"

    cmd = GenerateCommand(path=tmp_path)
    with pytest.raises(ValueError, match=f"{gi.name} is not a gitignore file$"):
        cmd.run_on_item_path(gi)

    assert cmd.c.generated == 0


def test_generate_gitignore_file_not_exists(tmp_path: Path):
    gi = tmp_path / IgnoreFile.GITIGNORE.value

    assert not gi.exists()

    cmd = GenerateCommand(path=tmp_path)
    with pytest.raises(ValueError, match=f"{gi.name} does not exists$"):
        cmd.run_on_item_path(gi)

    assert cmd.c.generated == 0


def test_generate_gitignore_file_not_file(tmp_path: Path):
    gi = tmp_path / IgnoreFile.GITIGNORE.value

    gi.mkdir()

    assert gi.is_dir()

    cmd = GenerateCommand(path=tmp_path)
    with pytest.raises(ValueError, match=f"{gi.name} is not a file$"):
        cmd.run_on_item_path(gi)

    assert cmd.c.generated == 0


def test_generate_dropboxignore_file_already_exists(tmp_path: Path):
    gi = tmp_path / IgnoreFile.GITIGNORE.value
    di = tmp_path / IgnoreFile.DROPBOXIGNORE.value

    gi.touch()
    di.touch()

    assert gi.is_file()
    assert di.is_file()

    cmd = GenerateCommand(path=tmp_path)
    with pytest.raises(ValueError, match=f"{di.name} already exists$"):
        cmd.run_on_item_path(gi)

    assert cmd.c.generated == 0
