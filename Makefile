DESTDIR=/usr/local
VERSION=`cat VERSION.txt`

# run tests
test:
	bats tests.sh

# install dropboxignore
install:
	cp dropboxignore.sh ${DESTDIR}/bin/dropboxignore
	chmod +x ${DESTDIR}/bin/dropboxignore
	mkdir -p "${DESTDIR}/share/dropboxignore"
	cp VERSION.txt "${DESTDIR}/share/dropboxignore"
	echo "dropboxignore $(VERSION) has been installed."

# uninstall dropbox ignore
uninstall:
	rm -rf "${DESTDIR}/bin/dropboxignore"
	rm -rf "${DESTDIR}/share/dropboxignore/"
	echo "dropboxignore $(VERSION) has been uninstalled."