{ config, lib, ... }:
{
  config = lib.mkIf config.alacritty.enable {
    home.file.".config/alacritty/cava.toml".text = ''
      [window]
      opacity = 0.0
    '';

    programs.alacritty = {
      enable = true;
    };
  };

  options = {
    alacritty.enable = lib.mkEnableOption "Enable Alacritty";
  };
}
