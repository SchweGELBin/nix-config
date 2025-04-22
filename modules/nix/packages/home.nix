{ config, lib, ... }:
let
  cfg = config.sys.pkgs;
  enable = cfg.enable && cfg.home.enable;
in
{
  config = lib.mkIf enable {
    environment.systemPackages = [ ];

    programs = {
      gamemode.enable = true;
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      hyprlock.enable = true;
      ssh = {
        enableAskPassword = false;
        startAgent = true;
      };
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      ydotool.enable = true;
    };

    xdg.portal.enable = true;
  };
}
