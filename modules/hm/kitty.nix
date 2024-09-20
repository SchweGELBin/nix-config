{ config, lib, ... }:
{
  config = lib.mkIf config.kitty.enable {
    home.file = {
      ".config/kitty/cavabg.sh".text = "sleep 1 && cava";
      ".config/kitty/kittybg.conf".text = "background_opacity 0";
    };

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
