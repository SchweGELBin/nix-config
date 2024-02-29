# nix-config
My Nix configs

## Configuration
```
Window Manager       - HyprLand
Terminal             - Kitty
Browser              - FireFox
Application Launcher - Rofi
Bar                  - Waybar
Wallpaper Engine     - SWWW
Audio                - Pipewire
Boot Manager         - Grub
Editor               - Neovim
Theme                - Catppuccin Machiatto (Mauve)
```

## Apply
### Step 0
- Download the minimal NixOS [ISO image](https://nixos.org/download) (NixOS -> ISO image -> Minimal ISO image -> Download (64-bit Intel/AMD)
- Flash this ISO image onto a USB flash drive (via: cp / dd / balena-etcher)
- Boot from your bootable USB flash drive
- Choose the standard live option
### Step 1
- Download the disko.nix file with ```curl -fs https://raw.githubusercontent.com/SchweGELBin/nix-config/master/disko.nix >> ~/disko.nix```
- Find out your disk device name with ```lsblk``` (The first volume, not any subvolumes)
- Replace "/dev/nvme0n1" with "/dev/yourdevicename" in the next command
- Format you drive with ```sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/nvme0n1"'```
### Step 3
- Create the necessary directories with ```sudo mkdir -p /mnt/etc/nixos```
- Temporarily download git with ```sudo nix-shell -p git"```
- Get these config files with ```sudo git clone https://github.com/SchweGELBin/nix-config --depth 1 /mnt/etc/nixos```
### Step 4
- Install NixOS with ```sudo nixos-install --root /mnt --flake /mnt/etc/nixos#default```

## Tips
- To sync the config with a newer version run ``sudo git pull``` inside of /etc/nixos
- Feel free to contribute to make these configs better
- Run ```sudo rebuild``` to rebuild the system
- Run ```sudo rebuild``` in /etc/nixos to update and rebuild your system

## Credits
- Thank you **[vimjoyer](https://github.com/vimjoyer)** for your help!
- Please check out his [Youtube Channel](https://youtube.com/@vimjoyer)
- Previously used repo: [HyprNix](https://github.com/SchweGELBin/HyprNix)
