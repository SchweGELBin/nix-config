{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.file."Pictures/Wallpapers/wallpaper.jpg".source = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/2y/wallhaven-2yx5og.jpg";
    hash = "sha256-BfxglbS7JoJyvtvwFETLWo9mcDjylLmcMpk0vW1AdKI=";
  };
}
