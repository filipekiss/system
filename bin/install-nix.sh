#! /usr/bin/env zsh

NIX_INSTALLER_URL=https://nixos.org/nix/install

if [[ $(uname -s) == 'Darwin' ]]; then
https://nixos.org/manual/nix/stable/#sect-macos-installation
  sh <(curl -L $NIX_INSTALLER_URL) --daemon --darwin-use-unencrypted-nix-store-volume
fi
