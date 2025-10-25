{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.radicale.enable;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      radicale = {
        enable = true;
        settings = {
          auth = {
            htpasswd_filename = secrets.radicale.path;
            type = "htpasswd";
          };
          server.hosts = [ "0.0.0.0:${toString cfg.radicale.port}" ];
        };
      };
      nginx.virtualHosts.${cfg.radicale.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.radicale.port}";
      };
    };
    sops.secrets.radicale.owner = "radicale";
  };
}
