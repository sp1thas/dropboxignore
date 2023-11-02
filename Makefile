# run python tests
test :
	poetry run pytest --cov=src tests/

# create snap
build-snap :
	snapcraft --debug

# upload snap
publish-snap :
	snapcraft upload $(SNAP_FILE)
