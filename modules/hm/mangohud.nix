{ config, lib, ... }:
let
  cfg = config.mangohud;
in
{
  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = cfg.autoEnable;
      settingsPerApplication = {
        ".easyeffects-wrapped".no_display = true;
        mpv.no_display = true;
        ".pavucontrol-wrapped".no_display = true;
      };
    };
  };

  options = {
    mangohud = {
      enable = lib.mkEnableOption "Enable MangoHud";
      autoEnable = lib.mkEnableOption "Enable MangoHud on all supported windows";
    };
  };
}
