DESTDIR=/usr/local

# run tests
# bats should be in PATH
test :
	bats tests

# install dropboxignore
install :
	$(info installing dropboxignore in $(DESTDIR))
	cp src/bin/cli.sh ${DESTDIR}/bin/dropboxignore
	chmod +x ${DESTDIR}/bin/dropboxignore
	mkdir -p ${DESTDIR}/lib/dropboxignore
	cp -r src/lib/commands ${DESTDIR}/lib/dropboxignore/.
	cp -r src/lib/modules ${DESTDIR}/lib/dropboxignore/.
	$(info dropboxignore has been installed)

# uninstall dropboxignore
uninstall :
	rm -rf "${DESTBINDIR}/dropboxignore" "${DESTLIBDIR}/dropboxignore"
	$(info dropboxignore has been uninstalled)

# create snap
build-snap :
	snapcraft --debug

# upload snap
publish-snap :
	snapcraft upload $(SNAP_FILE)
