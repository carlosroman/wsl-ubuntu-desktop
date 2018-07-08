## carlosroman/wsl-ubuntu-desktop - https://github.com/carlosroman/wsl-ubuntu-desktop
## 10-keychain.sh
## This file sets up keychain environment for the shell

# start keychain if not started
if [[ -x $(command -v keychain) ]]; then
	eval $(keychain --eval)
fi
