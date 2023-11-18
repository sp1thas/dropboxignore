# Testing

Tests of dropboxignore are written using [bats,](https://github.com/bats-core/bats-core) and they live inside the
`tests` folder. You can run them using the `Makefile` (docker and docker-compose should be installed):

!!! info
    Make sure that Docker and docker-compose are installed.

```shell
$ make test
```

If you are planning to implement a new feature, make sure that the necessary test cases have been added.
