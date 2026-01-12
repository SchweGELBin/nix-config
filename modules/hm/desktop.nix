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
      keybinds = {
        categories = [ "Education" ];
        exec = "kitty --hold binds";
        icon = "${icons}/devices/keyboard.svg";
        name = "Keybinds";
      };
      rocketleague = {
        actions.update = {
          exec = "legendary update Sugar -y";
          icon = "${icons}/apps/rocket-league.svg";
          name = "Update Rocket League";
        };
        categories = [ "Game" ];
        exec = "legendary launch Sugar";
        icon = "${icons}/apps/rocket-league.svg";
        name = "Rocket League";
      };
      sm64coopdx = {
        categories = [ "Game" ];
        exec = "env NIXPKGS_ALLOW_UNFREE=1 nix-shell -p sm64coopdx --run sm64coopdx";
        icon = "${icons}/apps/sm64ex.svg";
        name = "sm64coopdx";
      };
    };
  };

  options = {
    desktop.enable = lib.mkEnableOption "Enable Desktop Entries";
  };
}
