DESTDIR=/usr/local/bin

# run tests
test:
	bats tests.sh

# install dropboxignore
install:
	cp dropboxignore.sh ${DESTDIR}/dropboxignore
	chmod +x ${DESTDIR}/dropboxignore
	echo "dropboxignore has been installed."

# uninstall dropbox ignore
uninstall:
	rm -rf ${DESTDIR}/dropboxignore
	echo "dropboxignore has been uninstalled."