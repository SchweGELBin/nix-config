# Install Home Configuration

## Before
- Download the minimal NixOS [ISO image](https://channels.nixos.org/nixos-24.05/latest-nixos-minimal-x86_64-linux.iso)
- Flash this ISO image onto a USB flash drive (via: cp / dd / balena-etcher)
- Boot from your bootable USB flash drive
- Choose the standard live option

## After
- Check if you didn't make any mistakes and didn't get any errors
- Exit nix-shell with `exit`
- Reboot to your system with `reboot`
- Remove your USB flash drive at reboot
- Login with default password: 1234

## Install
- Mount your drive `lsblk` && `sudo mount /dev/device_name /mnt`
- Create the necessary directories with `sudo mkdir -p /mnt/etc`
- Start `sudo nix-shell -p git` to be able to use git
- Get these config files with `git clone https://github.com/SchweGELBin/nix-config --depth 1 /mnt/etc/nixos`

<br>

- Install NixOS with `nixos-install --root /mnt --flake /mnt/etc/nixos#home`
- (If you get an out of space error, rerun last command)
- Type in your preferred root password (twice)
