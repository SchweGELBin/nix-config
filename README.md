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
- Format you drive with ```sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ~/disko.nix --arg device '"/dev/nvme0n1"'```
### Step 2
- Create the necessary directories with ```sudo mkdir -p /mnt/etc```
- Download the shell.nix file with ```curl -fs https://raw.githubusercontent.com/SchweGELBin/nix-config/master/shell.nix >> ~/shell.nix```
- Start ```sudo nix-shell``` to be able to use git
- Get these config files with ```git clone https://github.com/SchweGELBin/nix-config --depth 1 /mnt/etc/nixos```
### Step 3
- Install NixOS with ```nixos-install --root /mnt --flake /mnt/etc/nixos#default```
- If you jet an out of space error, rerun last command
### Step 4
- Check if you didn't make any mistakes and didn't pet any errors
- Exit nix-shell with ```exit```
- Reboot to your system ```reboot```
- Remove your USB flash drive at reboot

## Tips
- To sync the config with a newer version run ```sudo git pull``` inside of /etc/nixos
- Feel free to contribute to make these configs better
- Run ```sudo rebuild``` to rebuild the system
- Run ```sudo rebuild``` in /etc/nixos to update and rebuild your system
- You may want to edit the user's initialPassword at configuration.nis (default 1234)
- Edit the disk device name at flake.nix

## Credits
- Thank you **[vimjoyer](https://github.com/vimjoyer)** for your help!
- Please check out his [Youtube Channel](https://youtube.com/@vimjoyer)
- Previously used repo: [HyprNix](https://github.com/SchweGELBin/HyprNix)
