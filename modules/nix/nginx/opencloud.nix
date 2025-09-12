{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.opencloud.enable;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts.${cfg.opencloud.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.opencloud.port}";
      };
      opencloud = {
        enable = true;
        environment.PROXY_TLS = "false";
        environmentFile = secrets.opencloud_env.path;
        port = cfg.opencloud.port;
        url = "https://${cfg.opencloud.fqdn}";
      };
    };
    sops.secrets.opencloud_env.owner = "opencloud";
  };
}
