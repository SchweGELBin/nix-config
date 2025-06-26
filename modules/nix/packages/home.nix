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
        enable = cfg.home.hypr.enable;
        xwayland.enable = true;
      };
      hyprlock.enable = cfg.home.hypr.enable;
      niri.enable = cfg.home.niri.enable;
      ssh = {
        enableAskPassword = false;
        startAgent = cfg.home.hypr.enable;
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
