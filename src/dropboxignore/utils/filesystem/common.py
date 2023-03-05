import datetime
from pathlib import Path
import os
from typing import List

DEFAULT_HEADER = (
    f"# ----{os.linesep}"
    f"# Automatically Generated .dropboxignore file at {{date}}{os.linesep}"
    f"# ----{os.linesep}"
)


def write_text(path: Path, text: str) -> None:
    with open(path, "w", newline=os.linesep) as f:
        f.write(text)


def read_text(path: Path) -> List[str]:
    with open(path, "r", newline=os.linesep) as f:
        return f.readlines()


def copy_content(gi: Path, di: Path) -> None:
    write_text(
        di,
        DEFAULT_HEADER.format(date=datetime.date.today().strftime("%Y-%m-%d"))
        + os.linesep.join(read_text(gi)),
    )
