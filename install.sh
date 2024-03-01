echo "nix-config by SchweGELBin"

cd ~
curl -fs https://raw.githubusercontent.com/SchweGELBin/nix-config/master/disko.nix >> ~/disko.nix
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ~/disko.nix --arg device '"/dev/$1"'

sudo mkdir -p /mnt/etc
curl -fs https://raw.githubusercontent.com/SchweGELBin/nix-config/master/shell.nix >> ~/shell.nix
sudo nix-shell
git clone https://github.com/SchweGELBin/nix-config --depth 1 /mnt/etc/nixos

nixos-install --root /mnt --flake /mnt/etc/nixos#default
