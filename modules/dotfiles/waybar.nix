{config, pkgs, ...}:
{
  home.file.".config/waybar/config" = {
    source = ./waybar/config;
  };
  home.file.".config/waybar/style.css" = {
    source = ./waybar/style.css;
  };
  home.file.".config/waybar/modules.json" = {
    source = ./waybar/modules.json;
  };

  home.file.".config/waybar/colors.css" = {
    text = ''
      @define-color text #${config.colorScheme.palette.base05};
      @define-color text2 #${config.colorScheme.palette.base05};
      @define-color bg transparent;
      @define-color bg2 transparent;
    '';
  };
}
