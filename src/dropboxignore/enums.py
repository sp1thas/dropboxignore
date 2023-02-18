from enum import Enum


class OperatingSystem(str, Enum):
    LINUX = "Linux"
    WINDOWS = "Windows"
    MACOS = "Darwin"


class IgnoreFile(str, Enum):
    GITIGNORE = ".gitignore"
    DROPBOXIGNORE = ".dropboxignore"
