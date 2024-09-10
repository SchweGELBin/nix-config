# Install Server Configuration

## Prerequisites
- Create a Cloud Server or VPS
- Choose any distro (recommended: Latest Debian)
- Update all packages `sudo apt update && sudo apt upgrade -y` and `reboot`

## Install
- Replace your drive with `sudo curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-23.05 bash -x`

## Apply Dotfiles
- Go to config dir `cd /etc/nixos`
- Regenerate the hardware config file `rm hardware-configuration.nix && nixos-generate-config`
- Move the important files `mkdir ~/bak && mv ./{hardware-configuration.nix,networking.nix} ~/bak`
- Remove the other generated files `rm ./*`
- Start `nix-shell -p git` to be able to use git
- Get these config files with `git clone https://github.com/SchweGELBin/nix-config --depth 1 /etc/nixos`
- Move back the networking file `cp ~/bak/{hardware-configuration.nix,networking.nix} ./hosts/server/`
- Sync config with `git add .`
- Rebuild NixOS with `nixos-rebuild switch --flake ./#server`
- `exit` the nix-shell
- `reboot` to take full effect
