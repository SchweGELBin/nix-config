# Install Server Configuration

## Prerequisites
- Create a Cloud Server or VPS
- Choose any distro (recommended: Latest Debian)
- Update all packages `sudo apt update && sudo apt upgrade -y` and `reboot`
- Setup OpenSSH

## Install
- Replace your drive with `sudo curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-23.05 bash -x`
- Set your root password
- `reboot`

## Apply Dotfiles

- Move your generated files `mv /etc/nixos/{hardware-configuration.nix,networking.nix} ~/`
- Delete the default configuration `rm /etc/nixos/configuration.nix`
- Start `nix-shell -p git` to be able to use git
- Get these config files with `git clone https://github.com/SchweGELBin/nix-config --depth 1 /etc/nixos`
- Move back the generated files `mv ~/{hardware-configuration.nix,networking.nix} /etc/nixos/hosts/server`
- Rebuild NixOS with `nixos-rebuild switch --flake /etc/nixos/#server`
- `exit` the nix-shell
- `reboot` just to be safe
