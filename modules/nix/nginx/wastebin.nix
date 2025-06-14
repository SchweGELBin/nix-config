{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.wastebin.enable;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      wastebin = {
        enable = true;
        secretFile = secrets.wastebin_env.path;
        settings = {
          WASTEBIN_ADDRESS_PORT = "127.0.0.1:${toString cfg.wastebin.port}";
          WASTEBIN_BASE_URL = "https://${cfg.wastebin.fqdn}";
          WASTEBIN_MAX_BODY_SIZE = 1048576;
          WASTEBIN_THEME = "catppuccin";
        };
      };
      nginx.virtualHosts.${cfg.wastebin.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.wastebin.port}";
      };
    };
    sops.secrets.wastebin_env.owner = "root";
    systemd.services.wastebin.preStart = "${config.services.wastebin.package}/bin/wastebin-ctl purge --database ${config.services.wastebin.settings.WASTEBIN_DATABASE_PATH}";
  };
}
