from enum import Enum


class OperatingSystems(str, Enum):
    LINUX = "Linux"
    WINDOWS = "Windows"
    MACOS = "Darwin"


class IgnoreFiles(str, Enum):
    GITIGNORE = ".gitignore"
    DROPBOXIGNORE = ".dropboxignore"
