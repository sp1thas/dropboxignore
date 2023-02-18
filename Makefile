DESTSCRIPTNAME=dropboxignore
DESTBINDIR=/usr/local/bin
DESTLIBDIR=/usr/local/lib/dropboxignore

# run shell tests
# bats should be in PATH
shell-tests :
	git submodule update --init
	bats tests

# run python tests
python-tests :
	poetry run pytest --cov=src tests/

test : shell-tests python-tests

# install dropboxignore
install :
	$(info installing dropboxignore in $(DESTDIR))
	mkdir -p "${DESTBINDIR}" "${DESTLIBDIR}"
	cp src/bin/cli.sh "${DESTBINDIR}/${DESTSCRIPTNAME}"
	chmod +x "${DESTBINDIR}/${DESTSCRIPTNAME}"
	cp -r src/lib/commands "${DESTLIBDIR}"
	cp -r src/lib/modules "${DESTLIBDIR}"
	$(info dropboxignore has been installed)

# uninstall dropboxignore
uninstall :
	rm -rf "${DESTBINDIR}/${DESTSCRIPTNAME}" "${DESTLIBDIR}"
	$(info dropboxignore has been uninstalled)

# create snap
build-snap :
	snapcraft --debug

# upload snap
publish-snap :
	snapcraft upload $(SNAP_FILE)
