{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.nextcloud;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      nextcloud = {
        enable = true;
        config = {
          adminpassFile = secrets.nextcloud.path;
          dbtype = "pgsql";
        };
        database.createLocally = true;
        hostName = cfg.fqdn;
        https = true;
        package = pkgs.nextcloud31;
        settings = {
          default_phone_region = "DE";
          overwriteprotocol = "https";
        };
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
      };
    };
    sops.secrets.nextcloud.owner = "nextcloud";
  };

  options = {
    sys.nginx.nextcloud = {
      enable = lib.mkEnableOption "Enable Nextcloud";
      fqdn = lib.mkOption {
        default = "next.${nginx.domain}";
        description = "Nextcloud Domain";
        type = lib.types.str;
      };
    };
  };
}
