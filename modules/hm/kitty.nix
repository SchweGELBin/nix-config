{ config, lib, ... }:
{
  config = lib.mkIf config.kitty.enable {
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
