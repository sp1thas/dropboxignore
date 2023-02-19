import datetime
from pathlib import Path

DEFAULT_HEADER = (
    "# ----\n" "# Automatically Generated .dropboxignore file at {date}\n" "# ----\n"
)


def copy_content(gi: Path, di: Path) -> None:
    di.write_text(
        DEFAULT_HEADER.format(date=datetime.date.today().strftime("%Y-%m-%d"))
        + gi.read_text()
    )
