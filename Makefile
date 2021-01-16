DESTDIR=/usr/local/bin

# run tests
test:
	bats --tap tests.sh

# install dropboxignore
install:
	cp dropboxignore.sh ${DESTDIR}/dropboxignore
	chmod +x ${DESTDIR}/dropboxignore

# uninstall dropbox ignore
uninstall:
	rm -rf ${DESTDIR}/dropboxignore