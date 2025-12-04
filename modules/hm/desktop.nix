{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop;
  icons = "${pkgs.papirus-icon-theme}/share/icons/Papirus/16x16";
in
{
  config = lib.mkIf cfg.enable {
    xdg.desktopEntries = {
      rocketleague = {
        actions."Update".exec = "legendary update Sugar -y";
        categories = [ "Game" ];
        exec = "DISPLAY= legendary launch Sugar";
        icon = "${icons}/apps/rocket-league.svg";
        name = "Rocket League";
      };
      sm64coopdx = {
        categories = [ "Game" ];
        exec = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p sm64coopdx --run \"sm64coopdx\"";
        icon = "${icons}/apps/sm64ex.svg";
        name = "sm64coopdx";
      };
    };
  };

  options = {
    desktop.enable = lib.mkEnableOption "Enable Desktop Entries";
  };
}
