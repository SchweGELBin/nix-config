{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.wastebin;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      wastebin = {
        enable = true;
        secretFile = secrets.wastebin_env.path;
        settings = {
          WASTEBIN_ADDRESS_PORT = "127.0.0.1:${toString cfg.port}";
          WASTEBIN_BASE_URL = "https://${cfg.fqdn}";
          WASTEBIN_MAX_BODY_SIZE = 1048576;
          WASTEBIN_THEME = lib.mkIf config.sys.catppuccin.enable "catppuccin";
        };
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };
    sops.secrets.wastebin_env.owner = "root";
    systemd.services.wastebin.preStart = "${config.services.wastebin.package}/bin/wastebin-ctl purge --database ${config.services.wastebin.settings.WASTEBIN_DATABASE_PATH}";
  };

  options = {
    sys.nginx.wastebin = {
      enable = lib.mkEnableOption "Enable wastebin";
      fqdn = lib.mkOption {
        default = "bin.${nginx.domain}";
        description = "wastebin Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 8899;
        description = "wastebin Port";
        type = lib.types.port;
      };
    };
  };
}
