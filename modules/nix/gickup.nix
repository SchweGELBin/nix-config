{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.gickup;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    systemd = {
      services.gickup = {
        enable = true;
        script =
          let
            configFile = (pkgs.formats.yaml { }).generate "gickup.yml" {
              source.github = {
                filter.excludeforks = false;
                starred = false;
                user = "SchweGELBin";
              };
              destination.gitea = {
                force = true;
                lfs = true;
                mirror.enabled = true;
                token = secrets.codeberg.path;
                url = "https://codeberg.org/";
                visibility = {
                  organizations = "public";
                  repositories = "public";
                };
              };
            };
          in
          "${lib.getExe pkgs.gickup} ${configFile}";
        wantedBy = [ "multi-user.target" ];
      };
      timers.gickup.timerConfig = {
        OnCalendar = "Mon 04:00:00";
        Unit = "gickup.service";
      };
    };

    sops.secrets.codeberg.owner = "root";
  };

  options = {
    sys.gickup.enable = lib.mkEnableOption "Enable Gickup";
  };
}
