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
        enable = (cfg.home.wm == "hyprland");
        xwayland.enable = true;
      };
      hyprlock.enable = (cfg.home.wm == "hyprland");
      niri.enable = (cfg.home.wm == "niri");
      ssh = {
        enableAskPassword = false;
        startAgent = (cfg.home.wm == "hyprland");
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
