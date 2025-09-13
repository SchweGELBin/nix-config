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
  vars = import ../vars.nix;
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
              cron = "0 4 * * 1";
              destination.gitea = [
                {
                  createorg = true;
                  force = true;
                  lfs = true;
                  mirror.enabled = true;
                  token_file = secrets.codeberg.path;
                  url = "https://codeberg.org/";
                  user = vars.git.name;
                  visibility = {
                    organizations = "public";
                    repositories = "public";
                  };
                }
              ];
              source.github = [
                {
                  exclude = [ "kernel_milk_davinci" ];
                  filter.excludeforks = true;
                  issues = true;
                  starred = false;
                  user = vars.git.name;
                }
              ];
            };
          in
          "${lib.getExe pkgs.gickup} ${configFile}";
        wantedBy = [ "multi-user.target" ];
      };
    };
    sops.secrets.codeberg.owner = "root";
  };

  options = {
    sys.gickup.enable = lib.mkEnableOption "Enable Gickup";
  };
}
