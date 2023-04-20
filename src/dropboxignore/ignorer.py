import subprocess
import sys
from abc import ABC, abstractmethod
from pathlib import Path
from typing import Type

import xattr


class IgnorerBase(ABC):
    @abstractmethod
    def _ignore_cmd(self, path: Path) -> None:
        pass

    @abstractmethod
    def _revert_cmd(self, path: Path) -> None:
        pass

    def ignore(self, path: Path):
        pass

    def revert(self, path: Path):
        pass


class WindowsIgnorer(IgnorerBase):
    def _ignore_cmd(self, path: Path) -> None:
        cmd = [
            "Set-Content",
            "-Path",
            f"'{path.absolute()}'",
            "-Stream",
            "com.dropbox.ignored",
            "-Value",
            "1",
        ]
        subprocess.check_call(cmd)

    def _revert_cmd(self, path: Path) -> None:
        cmd = [
            "Clear-Content",
            "-Path",
            f"'{path.absolute()}'",
            "-Stream",
            "com.dropbox.ignored",
        ]
        subprocess.check_call(cmd)


class UnixIgnorer(IgnorerBase):
    def _ignore_cmd(self, path: Path) -> None:
        xattr.setxattr(path, "com.dropbox.ignored", "1")

    def _revert_cmd(self, path: Path) -> None:
        xattr.removexattr(path, "com.dropbox.ignored")


def _get_ignorer() -> Type[IgnorerBase]:
    platform = sys.platform
    if platform in ("linux", "darwin"):
        return UnixIgnorer
    elif platform in ("windows", "win32"):
        return WindowsIgnorer
    else:
        raise RuntimeError(f"Unknown platform: {platform}")
