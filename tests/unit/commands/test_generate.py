import datetime
from pathlib import Path

import pytest

from dropboxignore.commands.generate import GenerateCommand
from dropboxignore.enums import IgnoreFiles


def test_generate_successful(tmp_path: Path):
    gi = tmp_path / IgnoreFiles.GITIGNORE.value

    gi.write_text("*.txt")

    di = tmp_path / IgnoreFiles.DROPBOXIGNORE.value

    assert not di.exists()

    cmd = GenerateCommand(path=tmp_path)
    cmd.run_on_item_path(gi)

    assert di.exists()
    assert di.read_text() == (
        "# ----\n"
        "# Automatically Generated .dropboxignore file at {date}\n"
        "# ----\n"
        "*.txt"
    ).format(date=datetime.date.today().strftime("%Y-%m-%d"))
    assert cmd.c.generated == 1


def test_generate_not_gitignore_file_input(tmp_path: Path):
    gi = tmp_path / "foo"

    cmd = GenerateCommand(path=tmp_path)
    with pytest.raises(ValueError, match=f"^{gi} is not a gitignore file$"):
        cmd.run_on_item_path(gi)

    assert cmd.c.generated == 0


def test_generate_gitignore_file_not_exists(tmp_path: Path):
    gi = tmp_path / IgnoreFiles.GITIGNORE.value

    assert not gi.exists()

    cmd = GenerateCommand(path=tmp_path)
    with pytest.raises(ValueError, match=f"^{gi} does not exists$"):
        cmd.run_on_item_path(gi)

    assert cmd.c.generated == 0


def test_generate_gitignore_file_not_file(tmp_path: Path):
    gi = tmp_path / IgnoreFiles.GITIGNORE.value

    gi.mkdir()

    assert gi.is_dir()

    cmd = GenerateCommand(path=tmp_path)
    with pytest.raises(ValueError, match=f"^{gi} is not a file$"):
        cmd.run_on_item_path(gi)

    assert cmd.c.generated == 0


def test_generate_dropboxignore_file_already_exists(tmp_path: Path):
    gi = tmp_path / IgnoreFiles.GITIGNORE.value
    di = tmp_path / IgnoreFiles.DROPBOXIGNORE.value

    gi.touch()
    di.touch()

    assert gi.is_file()
    assert di.is_file()

    cmd = GenerateCommand(path=tmp_path)
    with pytest.raises(ValueError, match=f"^{di} already exists$"):
        cmd.run_on_item_path(gi)

    assert cmd.c.generated == 0
