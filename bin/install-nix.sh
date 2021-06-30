#! /usr/bin/env zsh

NIX_INSTALLER_URL=https://nixos.org/nix/install
NIX_DARWIN_URL=https://github.com/LnL7/nix-darwin/archive/master.tar.gz

# TODO: Better condition handling and friendly error messages
if [[ $(uname -s) == 'Darwin' ]]; then
	# Check if nix needs to be installed
	if [[ $+commands[nix-build] -lt 1 ]]; then
		echo "Installing nix..."
		# See https://nixos.org/manual/nix/stable/#sect-macos-installation
		sh <(curl -s -L $NIX_INSTALLER_URL) --daemon --darwin-use-unencrypted-nix-store-volume
	fi
	# Try to load nix into shell and also acts as validation that nix has been properly installed
	if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
		source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
	else
		echo "Failed to initiate nix daemon. Please, install nix and try again."
	fi
	# Install nix-darwin
	if [[ $+commands[darwin-rebuild] -lt 1 ]]; then
		echo "Installing nix-darwin..."
		nix-build $NIX_DARWIN_URL -A installer
		./result/bin/darwin-installer
		# make just installed `darwin-rebuild` command available in current script
		[ -f /etc/static/bashrc ] && source /etc/static/bashrc
	fi
	# Install home-manager
	# TODO: find a way to validate if home manager is installed
	if [[ $+commands[nix-channel] ]]; then
		nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
		nix-channel --update
		NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH nix-shell '<home-manager>' -A install
	fi
fi
