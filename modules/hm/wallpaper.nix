{ pkgs, ... }:
{
  home.file."Pictures/Wallpapers/wallpaper.png".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish-dark-gray.png";
    hash = "sha256-nhIUtCy/Hb8UbuxXeL3l3FMausjQrnjTVi1B3GkL9B8=";
  };
}
