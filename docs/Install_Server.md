# Install Server Configuration

## Prerequisites
- Create a Cloud Server or VPS
- Choose any distro (recommended: Latest Debian)
- Update all packages `sudo apt update && sudo apt upgrade -y` and `reboot`

## Install
- Replace your drive with `sudo curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-23.05 bash -x`

## Apply Dotfiles
- Move the networking file `mv /etc/nixos/networking.nix ~/`
- Remove the other generated files `rm /etc/nixos/*`
- Start `nix-shell -p git` to be able to use git
- Get these config files with `git clone https://github.com/SchweGELBin/nix-config --depth 1 /etc/nixos`
- Move back the networking file `mv ~/networking.nix /etc/nixos/hosts/server/`
- Sync config with `cd /etc/nixos && git add .`
- Rebuild NixOS with `nixos-rebuild switch --flake /etc/nixos/#server`
- `exit` the nix-shell
- `reboot` to take full effect
