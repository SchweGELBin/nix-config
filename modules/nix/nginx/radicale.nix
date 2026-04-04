{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.radicale;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      radicale = {
        enable = true;
        settings = {
          auth = {
            htpasswd_filename = secrets.radicale.path;
            type = "htpasswd";
          };
          server.hosts = [ "0.0.0.0:${toString cfg.port}" ];
        };
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };
    sops.secrets.radicale.owner = "radicale";
  };

  options = {
    sys.nginx.radicale = {
      enable = lib.mkEnableOption "Enable Radicale";
      fqdn = lib.mkOption {
        default = "dav.${nginx.domain}";
        description = "Radicale Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 5232;
        description = "Radicale Port";
        type = lib.types.port;
      };
    };
  };
}
