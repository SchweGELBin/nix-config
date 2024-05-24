{config, lib, pkgs, ...}:
{
  home.file."Pictures/Wallpapers/wallpaper.jpg".source = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/3l/wallhaven-3l828y.jpg";
    hash = "sha256-hLlEBpwcjKQ6l846hU4OJFIa6uEeH2Zf5ouiZg8rn8A=";
  };
}
