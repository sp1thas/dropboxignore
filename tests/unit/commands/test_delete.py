from pathlib import Path

from dropboxignore.commands.delete import DeleteCommand
from dropboxignore.enums import IgnoreFiles


def test_delete_successful(tmp_path: Path):
    di = tmp_path / IgnoreFiles.DROPBOXIGNORE.value
    di.touch()

    assert di.exists()

    cmd = DeleteCommand(path=tmp_path)
    cmd.run_on_item_path(di)

    assert not di.exists()
    assert cmd.c.deleted == 1


def test_delete_not_exists(tmp_path: Path):
    di = tmp_path / IgnoreFiles.DROPBOXIGNORE.value

    assert not di.exists()

    cmd = DeleteCommand(path=tmp_path)
    cmd.run_on_item_path(di)

    assert not di.exists()
    assert cmd.c.deleted == 0
