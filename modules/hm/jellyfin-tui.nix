{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jellyfin-tui;
  secrets = config.sops.secrets;
  vars = import ../vars.nix;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.default ];

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ jellyfin-tui ];
    sops.secrets.jellyfin = { };
    xdg.configFile."jellyfin-tui/config.yaml".source =
      (pkgs.formats.yaml { }).generate "jellyfin-tui.yaml"
        {
          servers = [
            {
              name = vars.user.hostname.server;
              password_file = secrets.jellyfin.path;
              url = "https://jelly.${vars.my.domain}";
              username = "jelly";
            }
          ];
        };
  };

  options = {
    jellyfin-tui.enable = lib.mkEnableOption "Enable jellyfin-tui";
  };
}
