{config, lib, pkgs, ...}:
with config.lib.stylix.colors.withHashtag;
{
  home.file.".config/waybar/config" = {
    source = ./config;
  };
  home.file.".config/waybar/style.css" = {
    source = ./style.css;
  };
  home.file.".config/waybar/modules.json" = {
    source = ./modules.json;
  };

  home.file.".config/waybar/colors.css" = {
    text = ''
      @define-color text ${base07};
      @define-color text2 ${base07};
      @define-color bg transparent;
      @define-color bg2 transparent;
    '';
  };
}
