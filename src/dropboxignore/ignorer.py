import subprocess
import sys
from abc import ABC, abstractmethod
from pathlib import Path
from typing import List, Type


class IgnorerBase(ABC):
    @abstractmethod
    def _ignore_cmd(self, path: Path) -> List[str]:
        return []

    @abstractmethod
    def _revert_cmd(self, path: Path) -> List[str]:
        return []

    def ignore(self, path: Path):
        subprocess.check_call(self._ignore_cmd(path=path))

    def revert(self, path: Path):
        subprocess.check_call(self._revert_cmd(path=path))


class WindowsIgnorer(IgnorerBase):
    def _ignore_cmd(self, path: Path) -> List[str]:
        return [
            "Set-Content",
            "-Path",
            f"'{path.absolute()}'",
            "-Stream",
            "com.dropbox.ignored",
            "-Value",
            "1",
        ]

    def _revert_cmd(self, path: Path) -> List[str]:
        return [
            "Clear-Content",
            "-Path",
            f"'{path.absolute()}'",
            "-Stream",
            "com.dropbox.ignored",
        ]


class LinuxIgnorer(IgnorerBase):
    def _ignore_cmd(self, path: Path) -> List[str]:
        return ["attr", "-s", "com.dropbox.ignored", "-V", "1", f"{path.absolute()}"]

    def _revert_cmd(self, path: Path) -> List[str]:
        return ["attr", "-r", "com.dropbox.ignored", f"{path.absolute()}"]


class MacIgnorer(IgnorerBase):
    def _ignore_cmd(self, path: Path) -> List[str]:
        return ["xattr", "-w", "com.dropbox.ignored", "1", f"{path.absolute()}"]

    def _revert_cmd(self, path: Path) -> List[str]:
        return ["xattr", "-d", "com.dropbox.ignored", f"{path.absolute()}"]


def _get_ignorer() -> Type[IgnorerBase]:
    platform = sys.platform
    if platform == "linux":
        return LinuxIgnorer
    elif platform == "darwin":
        return MacIgnorer
    elif platform in ("windows", "win32"):
        return WindowsIgnorer
    else:
        raise RuntimeError(f"Unknown platform: {platform}")
