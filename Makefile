DESTDIR=/usr/local

# run tests
# bats should be in PATH
test :
	bats tests

# install dropboxignore
install :
	cp src/bin/dropboxignore.sh ${DESTDIR}/bin/dropboxignore
	chmod +x ${DESTDIR}/bin/dropboxignore
	mkdir -p ${DESTDIR}/lib/dropboxignore
	cp -r src/lib/commands ${DESTDIR}/lib/dropboxignore/.
	cp -r src/lib/modules ${DESTDIR}/lib/dropboxignore/.
	echo "\e[32mdropboxignore has been installed!"

# uninstall dropboxignore
uninstall :
	rm -rf "${DESTDIR}/bin/dropboxignore" "${DESTDIR}/lib/dropboxignore"
	echo "\e[32mdropboxignore has been uninstalled."

# create snap
build-snap :
	snapcraft --debug

# upload snap
publish-snap :
	snapcraft upload $(SNAP_FILE)
