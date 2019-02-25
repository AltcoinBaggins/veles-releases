install:
	@./veles-cli -version | sed 's/RPC client/installator/g' || echo -e "\nError: Some files are missing, please extract the archive again\n"
	@make install-cli
	@make install-gui

install-cli:
	@echo -n 'Installing Veles Core daemon and console client ... '
	@test -d /usr/local/bin || (echo -e "failed\n\nErro: Path /usr/local/bin not found, please install manually.\n"; exit 1)
	@cp velesd /usr/local/bin || (echo -e "failed\n\nError: Failed to copy files, do you have write privileges to /usr/local/bin?\n"; exit 1)
	@cp veles-cli /usr/local/bin || (echo -e "failed\n\nError: Failed to copy veles-cli to /usr/local/bin\n"; exit 1)
	@cp veles-tx /usr/local/bin || (echo -e "failed\n\nError: Failed to copy veles-tx to /usr/local/bin\n"; exit 1)
	@echo "ok"
	@echo -n 'Installing manual pages ... '
	@test -d /usr/local/share/man/man1 || echo "no, man directory not found"
	@test -d /usr/local/share/man/man1 && cp share/velesd.1 /usr/local/share/man/man1/
	@test -d /usr/local/share/man/man1 && cp share/veles-cli.1 /usr/local/share/man/man1/
	@test -d /usr/local/share/man/man1 && cp share/veles-tx.1 /usr/local/share/man/man1/
	@echo "ok"

install-gui:
	@echo -n 'Installing Veles Core GUI client ... '
	@test -d /usr/local/bin || (echo -e "failed\n\nErro: Path /usr/local/bin not found, please install manually.\n"; exit 1)
	@cp veles-qt /usr/local/bin || (echo -e "failed\n\nError: Failed to copy files, do you have write privileges to /usr/local/bin?\n"; exit 1)
	@echo "ok"
	@echo -n 'Installing GUI manual pages ... '
	@test -d /usr/local/share/man/man1 || echo "no, man directory not found"
	@test -d /usr/local/share/man/man1 && cp share/veles-qt.1 /usr/local/share/man/man1/
	@echo "ok"
	@echo -n 'Integrating with desktop environment ... '
	@test -d /usr/share/pixmaps && cp share/*.png /usr/share/pixmaps/ && cp share/*.xpm /usr/share/pixmaps/ && test -d /usr/share/applications && cp share/*.desktop /usr/share/applications/ && echo 'ok' || echo "no, GUI not found"
	@echo -n 'Integrating with KDE4 ... '
	@test -d /usr/share/kde4/services && cp share/*.protocol /usr/share/kde4/services/ && echo 'ok' || echo "no, KDE4 not found"

