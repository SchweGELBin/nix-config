{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.piped.enable;
in
{
  config = lib.mkIf enable {
    services.nginx.virtualHosts.${cfg.piped.fqdn} = {
      enableACME = true;
      forceSSL = true;
      root = pkgs.piped;
    };
  };
}
