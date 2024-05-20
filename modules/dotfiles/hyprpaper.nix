{config, lib, pkgs, ...}:
with config.lib.stylix.colors.withHashtag;
{
  home.file.".config/hypr/hyprpaper.conf" = {
    text = ''
      preload = ~/Pictures/Wallpapers/wallpaper.png
      wallpaper = ,~/Pictures/Wallpapers/wallpaper.png
    '';
  };
}
