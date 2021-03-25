DESTDIR=/usr/local

# run tests
# bats should be in PATH
test :
	bats tests

# install dropboxignore
install :
	cp bin/dropboxignore.sh ${DESTDIR}/bin/dropboxignore
	chmod +x ${DESTDIR}/bin/dropboxignore
	dropboxignore version

# uninstall dropboxignore
uninstall :
	rm -rf "${DESTDIR}/bin/dropboxignore"
	echo "\e[32mdropboxignore has been uninstalled."

# create snap
snap :
	snapcraft --debug

# upload snap
publish-snap :
	snapcraft upload $(SNAP_FILE)
