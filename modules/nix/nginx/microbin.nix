{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.microbin.enable;

  secrets = config.sops.secrets;
  vars = import ../vars.nix;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      microbin = {
        enable = true;
        settings = {
          MICROBIN_ADMIN_PASSWORD = secrets.microbin.path;
          MICROBIN_PORT = cfg.microbin.port;
        };
      };
      nginx.virtualHosts."microbin.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.microbin.port}";
      };
    };
    sops.secrets.microbin.owner = "root";
  };
}
