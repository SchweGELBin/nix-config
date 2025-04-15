{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
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
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
        xwayland.enable = true;
      };
      hyprlock = {
        enable = true;
        package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
      };
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

    services.hypridle.package = inputs.hypridle.packages.${pkgs.system}.hypridle;

    xdg.portal.enable = true;
  };
}
