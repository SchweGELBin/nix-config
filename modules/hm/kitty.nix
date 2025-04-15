{ config, lib, ... }:
let
  cfg = config.kitty;
in
{
  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      settings = {
        font_size = "13.0";
      };
    };
  };

  options = {
    kitty.enable = lib.mkEnableOption "Enable Kitty";
  };
}
