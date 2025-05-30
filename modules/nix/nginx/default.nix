{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  vars = import ../vars.nix;
in
{
  imports = [
    ./element.nix
    ./immich.nix
    ./invidious.nix
    ./jellyfin.nix
    ./mail.nix
    ./matrix.nix
    ./nextcloud.nix
    ./peertube.nix
    ./searx.nix
    ./turn.nix
    ./wastebin.nix
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
      immich = {
        enable = lib.mkEnableOption "Enable Immich";
        port = lib.mkOption {
          description = "Immich Port";
          type = lib.types.int;
        };
      };
      invidious = {
        enable = lib.mkEnableOption "Enable Invidious";
        port = lib.mkOption {
          description = "Invidious Port";
          type = lib.types.int;
        };
      };
      jellyfin = {
        enable = lib.mkEnableOption "Enable Jellyfin";
        port = lib.mkOption {
          description = "Jellyfin Port";
          type = lib.types.int;
        };
      };
      mail.enable = lib.mkEnableOption "Enable Mail Server";
      matrix = {
        enable = lib.mkEnableOption "Enable Matrix";
        port = lib.mkOption {
          description = "Matrix Port";
          type = lib.types.int;
        };
        whatsapp = {
          enable = lib.mkEnableOption "Enable WhatsApp Bridge";
          port = lib.mkOption {
            description = "WhatsApp Bridge Port";
            type = lib.types.int;
          };
        };
      };
      nextcloud.enable = lib.mkEnableOption "Enable Nextcloud";
      peertube = {
        enable = lib.mkEnableOption "Enable PeerTube";
        port = lib.mkOption {
          description = "PeerTube Port";
          type = lib.types.int;
        };
      };
      searx = {
        enable = lib.mkEnableOption "Enable SearXNG";
        port = lib.mkOption {
          description = "SearXNG Port";
          type = lib.types.int;
        };
      };
      turn = {
        enable = lib.mkEnableOption "Enable Turn";
        port = lib.mkOption {
          description = "Turn Port";
          type = lib.types.int;
        };
        port-alt = lib.mkOption {
          description = "Turn Alternative Port";
          type = lib.types.int;
        };
        relay-max = lib.mkOption {
          description = "Turn Relay Range Max";
          type = lib.types.int;
        };
        relay-min = lib.mkOption {
          description = "Turn Relay Range Min";
          type = lib.types.int;
        };
      };
      wastebin = {
        enable = lib.mkEnableOption "Enable wastebin";
        port = lib.mkOption {
          description = "wastebin Port";
          type = lib.types.int;
        };
      };
    };
  };
}
