{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.ergo.enable;
  secrets = config.sops.secrets;
  vars = import ../../vars.nix;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      ergochat = {
        enable = true;
        settings = {
          network.name = "MiX";
          server = {
            name = vars.my.domain;
            listeners = {
              "127.0.0.1:${toString cfg.ergo.port}" = { };
              "[::1]:${toString cfg.ergo.port}" = { };
              ":${toString cfg.ergo.port}" = {
                tls = {
                  cert = "/var/lib/acme/${cfg.thelounge.fqdn}/cert.pem";
                  key = "/var/lib/acme/${cfg.thelounge.fqdn}/key.pem";
                };
              };
            };
            opers.password = secrets.ergo.path;
          };
        };
      };
      security.acme.certs.${cfg.thelounge.fqdn} = {
        group = "root";
        postRun = "systemctl reload nginx.service; systemctl restart ergochat.service";
      };
    };

    sops.secrets.ergo.owner = "root";
  };
}
