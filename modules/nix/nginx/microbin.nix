{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.microbin;
  vars = import ../../vars.nix;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      microbin = {
        enable = true;
        passwordFile = secrets.microbin_env.path;
        settings = {
          MICROBIN_ADMIN_USERNAME = vars.user.name;
          MICROBIN_DISABLE_TELEMETRY = true;
          MICROBIN_ENABLE_BURN_AFTER = true;
          MICROBIN_ENABLE_READONLY = true;
          MICROBIN_HASH_IDS = true;
          MICROBIN_HIDE_FOOTER = true;
          MICROBIN_PORT = cfg.port;
          MICROBIN_PRIVATE = true;
          MICROBIN_PUBLIC_PATH = "https://${cfg.fqdn}";
          MICROBIN_QR = true;
          MICROBIN_WIDE = true;
        };
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };
    sops.secrets.microbin_env.owner = "root";
  };

  options = {
    sys.nginx.microbin = {
      enable = lib.mkEnableOption "Enable MicroBin";
      fqdn = lib.mkOption {
        default = "mic.${nginx.domain}";
        description = "MicroBin Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 3167;
        description = "MicroBin Port";
        type = lib.types.port;
      };
    };
  };
}
