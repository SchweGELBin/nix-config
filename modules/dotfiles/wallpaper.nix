{config, lib, pkgs, ...}:
{
  home.file."Pictures/Wallpapers/wallpaper.png".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Gingeh/wallpapers/main/waves/cat-waves.png";
    hash = "sha256-aiG7debgjOCWRBp2xUOMOVGvIDWtd4NirsktxL19De4=";
 };
}
