# Install Home Configuration

## Preparation
### Boot the ISO
- Download the minimal NixOS [ISO image](https://channels.nixos.org/nixos-25.05/latest-nixos-minimal-x86_64-linux.iso)
- Flash this ISO image onto a USB flash drive (via: cat, cp, dd, pv, tee or balena-etcher, rufus, ventoy)
- Boot from your bootable USB flash drive
- Choose the standard live option

## Installation
### Format the Disk
- Install necessary packages with `sudo nix-shell -p git nixVersions.latest`
- Get these config files with `git clone https://github.com/SchweGELBin/nix-config --depth 1`
- Change the device name to the one in `lsblk` in the disko config `nano nix-config/modules/nix/disko/config.nix`
- Format your drive with `nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko nix-config/modules/nix/disko/config.nix`

### Optional: Change some variables
- Take a look at the variables: `nano nix-config/modules/vars.nix`
- Take a look at the hosts: `ls nix-config/hosts`
- Save the changes with `cd nix-config && git add -A && cd ..`

### Install NixOS
- Create the necessary directories with `mkdir /mnt/etc`
- Copy these configs to the drive with `mv nix-config /mnt/etc/nixos`
- Install NixOS `NIXOS_INSTALL_BOOTLOADER=1 nixos-install --root /mnt --flake /mnt/etc/nixos#host`\
Replace "host" with the actual hostname
- (Some errors can be fixed by rerunning the last command)
- Type in your preferred root password (twice)

## Completion
### Boot into the OS
- Check if you didn't make any mistakes and didn't get any errors
- Reboot to your system with `reboot`
- Remove your USB flash drive at reboot
- Login with default credentials: "michi - 1234"

### First important steps
- Change the initial password with `passwd`
- Add your ssh keys
- Setup sops/age
- Clone the repo to the right spot
  1. Using ssh: `sudo config-reset git`
  2. Using https: `sudo config-reset`
