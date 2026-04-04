{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.opencloud;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
      opencloud = {
        enable = true;
        environment.PROXY_TLS = "false";
        environmentFile = secrets.opencloud_env.path;
        port = cfg.port;
        url = "https://${cfg.fqdn}";
      };
    };
    sops.secrets.opencloud_env.owner = "opencloud";
  };

  options = {
    sys.nginx.opencloud = {
      enable = lib.mkEnableOption "Enable OpenCloud";
      fqdn = lib.mkOption {
        default = "cloud.${nginx.domain}";
        description = "OpenCloud Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 9200;
        description = "OpenCloud Port";
        type = lib.types.port;
      };
    };
  };
}
