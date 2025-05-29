{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.nextcloud.enable;

  secrets = config.sops.secrets;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf enable {
    services = {
      nextcloud = {
        enable = true;
        config = {
          adminpassFile = secrets.nextcloud.path;
        };
        hostName = "nextcloud.${vars.my.domain}";
        https = true;
        settings = {
          default_phone_region = "DE";
          overwriteprotocol = "https";
        };
      };
    };
  };
  sops.secrets.nextcloud.owner = "immich";
}
