{
  config,
  lib,
  ...
}:
let
  vars = import ../../vars.nix;
in
{
  config = lib.mkIf config.sys.services.nginx.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.nginx = {
      enable = true;
      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedZstdSettings = true;
      virtualHosts.${vars.my.domain} = {
        default = true;
        enableACME = true;
        forceSSL = true;
        root = "/var/www";
      };
    };
  };

  options = {
    sys.services.nginx.enable = lib.mkEnableOption "Enable Nginx";
  };
}
