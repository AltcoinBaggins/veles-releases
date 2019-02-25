SRC_DIR=/home/baggins/veles
UPLOAD_DIR=/home/baggins/upload
OLD_PWD=$$(pwd)

deploy-linux:
	make deploy-linux-amd64

deploy-linux-amd64:
	make update-src
	make clean
	make configure-linux-amd64
	make build-linux-amd64
	make copy-linux-amd64-build
	make package-linux-amd64-build
	make package-debian-build
	make upload-linux-amd64-build

redeploy-linux:
	make redeploy-linux-amd64

redeploy-linux-amd64:
	make update-src
	make build-linux-amd64
	make copy-linux-amd64-build
	make package-linux-amd64-build
	make package-debian-build
	make upload-linux-amd64-build

update-src:
	cd $(SRC_DIR) && git pull

clean:
	cd $(SRC_DIR) && make clean

configure-linux-amd64:
	cd $(SRC_DIR) && ./autogen.sh
	cd $(SRC_DIR)/depends && make HOST=x86_64-unknown-linux -j 8
	cd $(SRC_DIR) && ./configure --with-gui --enable-glibc-back-compat --enable-static --prefix=$(SRC_DIR)/depends/x86_64-unknown-linux LDFLAGS="-static-libstdc++" --disable-tests

build-linux-amd64:
	cd $(SRC_DIR) && make -j8 || make -j8 || exit 1

copy-linux-amd64-build:
	test -d $(UPLOAD_DIR)/veles-linux-amd64 || mkdir $(UPLOAD_DIR)/veles-linux-amd64
	cp $(SRC_DIR)/src/velesd $(UPLOAD_DIR)/veles-linux-amd64
	cp $(SRC_DIR)/src/veles-cli $(UPLOAD_DIR)/veles-linux-amd64
	cp $(SRC_DIR)/src/veles-tx $(UPLOAD_DIR)/veles-linux-amd64
	cp $(SRC_DIR)/src/qt/veles-qt $(UPLOAD_DIR)/veles-linux-amd64
	cp $(SRC_DIR)/doc/release-notes.md $(UPLOAD_DIR)/veles-linux-amd64
	cp $(SRC_DIR)/COPYING $(UPLOAD_DIR)/veles-linux-amd64
	test -d $(UPLOAD_DIR)/veles-linux-amd64/share || mkdir -p $(UPLOAD_DIR)/veles-linux-amd64/share
	cp $(SRC_DIR)/doc/man/*.1 $(UPLOAD_DIR)/veles-linux-amd64/share/
	cp $(SRC_DIR)/share/pixmaps/veles32.xpm $(UPLOAD_DIR)/veles-linux-amd64/share
	cp $(SRC_DIR)/share/pixmaps/veles64.xpm $(UPLOAD_DIR)/veles-linux-amd64/share
	cp $(SRC_DIR)/share/pixmaps/veles128.png $(UPLOAD_DIR)/veles-linux-amd64/share
	strip $(UPLOAD_DIR)/veles-linux-amd64/velesd
	strip $(UPLOAD_DIR)/veles-linux-amd64/veles-cli
	strip $(UPLOAD_DIR)/veles-linux-amd64/veles-tx
	strip $(UPLOAD_DIR)/veles-linux-amd64/veles-qt

package-linux-amd64-build:
	cd $(UPLOAD_DIR) && tar -vczf $(UPLOAD_DIR)/releases/veles-linux-amd64.tar.gz veles-linux-amd64

upload-linux-amd64-build:
	cd $(UPLOAD_DIR) && git add releases
	cd $(UPLOAD_DIR) && git commit -a -m '$(shell $(UPLOAD_DIR)/veles-linux-amd64/velesd -version | grep version | sed "s/Veles Core Daemon version /veles-linux-amd64 build /g")'
	cd $(UPLOAD_DIR) && git push origin master

package-debian-build:
	echo "Preparing for Debian build ..."
	test -f $(UPLOAD_DIR)/veles-linux-amd64/veles-cli
	$(UPLOAD_DIR)/veles-linux-amd64/veles-cli -version | grep client || (echo 'Corrupted veles-linux-amd64/veles-cli, stopping debian build'; exit 1)
	echo "Packing veles.deb"
	grep -v Version $(UPLOAD_DIR)/debian/amd64/veles/DEBIAN/control >$(UPLOAD_DIR)/debian/amd64/veles/DEBIAN/control.tmp && mv $(UPLOAD_DIR)/debian/amd64/veles/DEBIAN/control.tmp $(UPLOAD_DIR)/debian/amd64/veles/DEBIAN/control
	echo "Version: $(shell $(UPLOAD_DIR)/veles-linux-amd64/veles-cli -version | grep client | awk '{print $$6}' | sed 's/-/ /g' | awk '{print $$1}' | sed 's/v//g')" >> $(UPLOAD_DIR)/debian/amd64/veles/DEBIAN/control
	cd $(UPLOAD_DIR)/debian/amd64 && dpkg-deb -b veles
	mv $(UPLOAD_DIR)/debian/amd64/veles.deb $(UPLOAD_DIR)/releases
	echo "Packing velesd.deb"
	cp $(UPLOAD_DIR)/veles-linux-amd64/velesd $(UPLOAD_DIR)/debian/amd64/velesd/usr/local/bin/
	cp $(UPLOAD_DIR)/veles-linux-amd64/veles-cli $(UPLOAD_DIR)/debian/amd64/velesd/usr/local/bin/
	cp $(UPLOAD_DIR)/veles-linux-amd64/share/velesd.1 $(UPLOAD_DIR)/debian/amd64/velesd/usr/local/share/man/man1/
	cp $(UPLOAD_DIR)/veles-linux-amd64/share/veles-cli.1 $(UPLOAD_DIR)/debian/amd64/velesd/usr/local/share/man/man1/
	grep -v Version $(UPLOAD_DIR)/debian/amd64/velesd/DEBIAN/control >$(UPLOAD_DIR)/debian/amd64/velesd/DEBIAN/control.tmp && mv $(UPLOAD_DIR)/debian/amd64/velesd/DEBIAN/control.tmp $(UPLOAD_DIR)/debian/amd64/velesd/DEBIAN/control
	echo "Version: $(shell $(UPLOAD_DIR)/veles-linux-amd64/veles-cli -version | grep client | awk '{print $$6}' | sed 's/-/ /g' | awk '{print $$1}' | sed 's/v//g')" >> $(UPLOAD_DIR)/debian/amd64/velesd/DEBIAN/control
	cd $(UPLOAD_DIR)/debian/amd64 && dpkg-deb -b velesd
	mv $(UPLOAD_DIR)/debian/amd64/velesd.deb $(UPLOAD_DIR)/releases/velesd-amd64.deb
	echo "Packing veles-qt.deb"
	cp $(UPLOAD_DIR)/veles-linux-amd64/veles-qt $(UPLOAD_DIR)/debian/amd64/veles-qt/usr/local/bin/
	cp $(UPLOAD_DIR)/veles-linux-amd64/share/veles-qt.1 $(UPLOAD_DIR)/debian/amd64/veles-qt/usr/local/share/man/man1/
	cp $(UPLOAD_DIR)/veles-linux-amd64/share/*.xpm $(UPLOAD_DIR)/debian/amd64/veles-qt/usr/share/pixmaps/
	cp $(UPLOAD_DIR)/veles-linux-amd64/share/*.png $(UPLOAD_DIR)/debian/amd64/veles-qt/usr/share/pixmaps/
	grep -v Version $(UPLOAD_DIR)/debian/amd64/veles-qt/DEBIAN/control >$(UPLOAD_DIR)/debian/amd64/veles-qt/DEBIAN/control.tmp && mv $(UPLOAD_DIR)/debian/amd64/veles-qt/DEBIAN/control.tmp $(UPLOAD_DIR)/debian/amd64/veles-qt/DEBIAN/control
	echo "Version: $(shell $(UPLOAD_DIR)/veles-linux-amd64/veles-cli -version | grep client | awk '{print $$6}' | sed 's/-/ /g' | awk '{print $$1}' | sed 's/v//g')" >> $(UPLOAD_DIR)/debian/amd64/veles-qt/DEBIAN/control
	cd $(UPLOAD_DIR)/debian/amd64 && dpkg-deb -b veles-qt
	mv $(UPLOAD_DIR)/debian/amd64/veles-qt.deb $(UPLOAD_DIR)/releases/veles-qt-amd64.deb
	echo "Packing veles-tx.deb"
	cp $(UPLOAD_DIR)/veles-linux-amd64/veles-tx $(UPLOAD_DIR)/debian/amd64/veles-tx/usr/local/bin/
	cp $(UPLOAD_DIR)/veles-linux-amd64/share/veles-tx.1 $(UPLOAD_DIR)/debian/amd64/veles-tx/usr/local/share/man/man1/
	grep -v Version $(UPLOAD_DIR)/debian/amd64/veles-tx/DEBIAN/control >$(UPLOAD_DIR)/debian/amd64/veles-tx/DEBIAN/control.tmp && mv $(UPLOAD_DIR)/debian/amd64/veles-tx/DEBIAN/control.tmp $(UPLOAD_DIR)/debian/amd64/veles-tx/DEBIAN/control
	echo "Version: $(shell $(UPLOAD_DIR)/veles-linux-amd64/veles-cli -version | grep client | awk '{print $$6}' | sed 's/-/ /g' | awk '{print $$1}' | sed 's/v//g')" >> $(UPLOAD_DIR)/debian/amd64/veles-tx/DEBIAN/control
	cd $(UPLOAD_DIR)/debian/amd64 && dpkg-deb -b veles-tx
	mv $(UPLOAD_DIR)/debian/amd64/veles-tx.deb $(UPLOAD_DIR)/releases/veles-tx-amd64.deb
