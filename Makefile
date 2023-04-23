pre-setup:
	./pre-setup.sh
terminal: pre-setup
	./setup-terminal.sh
dev: pre-setup
	./setup-dev.sh
