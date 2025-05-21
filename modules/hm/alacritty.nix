{ config, lib, ... }:
let
  cfg = config.alacritty;
in
{
  config = lib.mkIf cfg.enable {
    programs.alacritty.enable = true;

    xdg.configFile."alacritty/cava.toml".text = ''
      [window]
      opacity = 0.0
    '';
  };

  options = {
    alacritty.enable = lib.mkEnableOption "Enable Alacritty";
  };
}
