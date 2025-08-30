# Install Home Configuration

## Before
- Download the minimal NixOS [ISO image](https://channels.nixos.org/nixos-25.05/latest-nixos-minimal-x86_64-linux.iso)
- Flash this ISO image onto a USB flash drive (via: cp / dd / balena-etcher)
- Boot from your bootable USB flash drive
- Choose the standard live option

## Install
- Install necessary packages with `sudo nix-shell -p git nixVersions.latest`
- Get these config files with `git clone https://github.com/SchweGELBin/nix-config --depth 1`
- Change the device name to the one in `lsblk` in the disko config `nano nix-config/modules/nix/disko/config.nix`
- Format your drive with `nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko nix-config/modules/nix/disko/config.nix`
- Create the necessary directories with `sudo mkdir -p /mnt/etc`
- Copy these configs to the drive with `mv nix-config /mnt/etc/nixos`

<br>

- Install NixOS with `NIXOS_INSTALL_BOOTLOADER=1 nixos-install --root /mnt --flake /mnt/etc/nixos#home`
- (Some errors can be fixed by rerunning the last command)
- Type in your preferred root password (twice)

## After
- Check if you didn't make any mistakes and didn't get any errors
- Reboot to your system with `reboot`
- Remove your USB flash drive at reboot
- Login with default credentials: "michi - 1234"
- Change the initial password with `passwd`
- Clone the repo to the right spot `sudo rm -r /etc/nixos && cd ~ && git clone git@github.com:SchweGELBin/nix-config`
