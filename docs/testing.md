# Testing

Tests of dropboxignore are written using [bats](https://github.com/bats-core/bats-core) and they live inside the `tests` folder. You can run them using the `Makefile`:

!!! info
    Make sure that bats is installed in your system and also in you `PATH` (use your package manager [[1](https://formulae.brew.sh/formula/bats-core), [2](https://packages.debian.org/buster/bats), [3](https://archlinux.org/packages/community/any/bash-bats/) ] or install it from [source](https://github.com/bats-core/bats-core)).

```shell
$ make test
```

If you are planning to implement a new feature, make sure that the necessary test cases have been added.