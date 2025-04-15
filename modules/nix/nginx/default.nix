{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  vars = import ../vars.nix;
in
{
  imports = [
    ./element.nix
    ./jellyfin.nix
    ./matrix.nix
  ];

  config = lib.mkIf cfg.enable {
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
    sys.nginx = {
      enable = lib.mkEnableOption "Enable Nginx";
      element.enable = lib.mkEnableOption "Enable Element";
      jellyfin = {
        enable = lib.mkEnableOption "Enable Jellyfin";
        port = lib.mkOption {
          description = "Jellyfin Port";
          type = lib.types.int;
        };
      };
      matrix = {
        enable = lib.mkEnableOption "Enable Matrix";
        port = lib.mkOption {
          description = "Matrix Port";
          type = lib.types.int;
        };
      };
    };
  };
}
