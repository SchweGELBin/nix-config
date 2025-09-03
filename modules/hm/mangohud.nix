{ config, lib, ... }:
let
  cfg = config.mangohud;
in
{
  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settingsPerApplication = {
        mpv.no_display = true;
        ".pavucontrol-wrapped".no_display = true;
      };
    };
  };

  options = {
    mangohud.enable = lib.mkEnableOption "Enable MangoHud";
  };
}
