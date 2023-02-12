import typer
import os

# from src.commands.delete import DeleteCommand


app = typer.Typer(help="Awesome CLI user manager.")

default_path = os.getcwd()


@app.command()
def ignore(path: str = "."):
    pass


@app.command()
def generate(path: str = "."):
    pass


@app.command()
def list(path: str = "."):
    pass


@app.command()
def delete(path: str):
    from dropboxignore.commands.delete import DeleteCommand

    cmd = DeleteCommand(path)
    cmd.run()
    cmd.run_report()


@app.command()
def update(path: str = "."):
    pass


@app.command()
def genupi(path: str = "."):
    pass


@app.command()
def revert(path: str = "."):
    pass


if __name__ == "__main__":
    app()
