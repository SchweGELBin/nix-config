{ config, lib, ... }:
let
  cfg = config.retroarch;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    programs.retroarch = {
      enable = true;
      cores = {
        bsnes-hd.enable = true;
        dolphin.enable = true;
        melonds.enable = true;
        mesen.enable = true;
        mgba.enable = true;
        mupen64plus.enable = true;
      };
      settings = {
        netplay_nickname = vars.user.name;
        ozone_menu_color_theme = toString 7;
        pause_nonactive = lib.boolToString false;
        video_driver = "vulkan";
        video_vsync = lib.boolToString false;
        video_windowed_fullscreen = lib.boolToString false;
      };
    };
  };

  options = {
    retroarch.enable = lib.mkEnableOption "Enable RetroArch";
  };
}
