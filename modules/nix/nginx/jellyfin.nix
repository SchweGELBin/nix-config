{
  config,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.jellyfin.enable;

  vars = import ../vars.nix;
in
{
  config = lib.mkIf enable {
    services = {
      jellyfin.enable = true;
      nginx.virtualHosts."jelly.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.jellyfin.port}";
      };
    };
  };
}
