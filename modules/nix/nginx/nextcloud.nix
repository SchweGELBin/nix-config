{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.nextcloud.enable;

  secrets = config.sops.secrets;
  vars = import ../vars.nix;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      nextcloud = {
        enable = true;
        config = {
          adminpassFile = secrets.nextcloud.path;
          dbtype = "pgsql";
        };
        database.createLocally = true;
        hostName = "nextcloud.${vars.my.domain}";
        https = true;
        package = pkgs.nextcloud31;
        settings = {
          default_phone_region = "DE";
          overwriteprotocol = "https";
        };
      };
      nginx.virtualHosts."nextcloud.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
      };
    };
    sops.secrets.nextcloud.owner = "nextcloud";
  };
}
