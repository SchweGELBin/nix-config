{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.searx.enable;

  secrets = config.sops.secrets;
  vars = import ../vars.nix;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      searx = {
        enable = true;
        environmentFile = secrets.searx.path;
        redisCreateLocally = true;
        settings.server = {
          bind_address = "0.0.0.0";
          general.debug = false;
          port = cfg.searx.port;
        };
      };
      nginx.virtualHosts."searx.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.searx.port}";
      };
    };
    sops.secrets.searx.owner = "searx";
  };
}
