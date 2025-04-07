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
- Rebuild NixOS with `TMPDIR="/tmp" nixos-rebuild switch --flake ./#server`
- Check if you didn't make any mistakes and didn't get any errors
- Exit nix-shell with `exit`
- Reboot to your system with `reboot`

## After
Now you have to options:

1. Clone the repo to the right spot `sudo rm -r /etc/nixos && cd ~ && git clone https://github.com/SchweGELBin/nix-config`
2. Change vars.user.config in "/etc/nixos/modules/nix/vars.nix" to "/etc/nixos"
