import datetime
from pathlib import Path
import os

DEFAULT_HEADER = (
    f"# ----{os.linesep}"
    f"# Automatically Generated .dropboxignore file at {{date}}{os.linesep}"
    f"# ----{os.linesep}"
)


def copy_content(gi: Path, di: Path) -> None:
    di.write_text(
        DEFAULT_HEADER.format(date=datetime.date.today().strftime("%Y-%m-%d"))
        + gi.read_bytes().decode("utf-8")
    )
