# Testing

Tests of dropboxignore are written using [bats](https://github.com/bats-core/bats-core) and they live inside the `tests` folder. You can run them using the `Makefile`:

!!! info
    Make sure that bats is installed in your system and also in you `PATH` (use your package manager or install it from source).

```shell
$ make test
```

If you are planning to implement a new feature, make sure that the necessary test cases have been added.