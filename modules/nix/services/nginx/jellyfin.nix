{
  config,
  lib,
  ...
}:
let
  vars = import ../../vars.nix;
in
{
  config = lib.mkIf config.sys.services.nginx.jellyfin.enable {
    services = {
      jellyfin.enable = true;
      nginx.virtualHosts."jelly.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${config.sys.services.nginx.jellyfin.port}";
      };
    };
  };

  options = {
    sys.services.nginx.jellyfin = {
      enable = lib.mkEnableOption "Enable Jellyfin";
      port = lib.mkOption {
        description = "Jellyfin Port";
        type = lib.types.int;
      };
    };
  };
}
