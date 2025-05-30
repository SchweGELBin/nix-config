{ config, lib, ... }:
let
  cfg = config.sys.nginx;
in
{
  imports = [
    ./element.nix
    ./forgejo.nix
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
      virtualHosts.${cfg.domain} = {
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
      domain = lib.mkOption {
        description = "Nginx Domain";
        type = lib.types.string;
      };
      element = {
        enable = lib.mkEnableOption "Enable Element";
        fqdn = lib.mkOption {
          description = "Element Domain";
          type = lib.types.string;
        };
      };
      forgejo = {
        enable = lib.mkEnableOption "Enable Forgejo";
        fqdn = lib.mkOption {
          description = "Forgejo Domain";
          type = lib.types.string;
        };
        port = lib.mkOption {
          description = "Forgejo Port";
          type = lib.types.int;
        };
      };
      immich = {
        enable = lib.mkEnableOption "Enable Immich";
        fqdn = lib.mkOption {
          description = "Immich Domain";
          type = lib.types.string;
        };
        port = lib.mkOption {
          description = "Immich Port";
          type = lib.types.int;
        };
      };
      invidious = {
        enable = lib.mkEnableOption "Enable Invidious";
        fqdn = lib.mkOption {
          description = "Invidious Domain";
          type = lib.types.string;
        };
        port = lib.mkOption {
          description = "Invidious Port";
          type = lib.types.int;
        };
      };
      jellyfin = {
        enable = lib.mkEnableOption "Enable Jellyfin";
        fqdn = lib.mkOption {
          description = "Jellyfin Domain";
          type = lib.types.string;
        };
        port = lib.mkOption {
          description = "Jellyfin Port";
          type = lib.types.int;
        };
      };
      mail = {
        enable = lib.mkEnableOption "Enable Mail Server";
        fqdn = lib.mkOption {
          description = "Mail Server Domain";
          type = lib.types.string;
        };
      };
      matrix = {
        enable = lib.mkEnableOption "Enable Matrix";
        fqdn = lib.mkOption {
          description = "Matrix Domain";
          type = lib.types.string;
        };
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
      nextcloud = {
        enable = lib.mkEnableOption "Enable Nextcloud";
        fqdn = lib.mkOption {
          description = "Nextcloud Domain";
          type = lib.types.string;
        };
      };
      peertube = {
        enable = lib.mkEnableOption "Enable PeerTube";
        fqdn = lib.mkOption {
          description = "Peertube Domain";
          type = lib.types.string;
        };
        mail = lib.mkOption {
          description = "Peertube Mail";
          type = lib.types.string;
        };
        port = lib.mkOption {
          description = "PeerTube Port";
          type = lib.types.int;
        };
      };
      searx = {
        enable = lib.mkEnableOption "Enable SearXNG";
        fqdn = lib.mkOption {
          description = "SearXNG Domain";
          type = lib.types.string;
        };
        port = lib.mkOption {
          description = "SearXNG Port";
          type = lib.types.int;
        };
      };
      turn = {
        enable = lib.mkEnableOption "Enable Turn";
        fqdn = lib.mkOption {
          description = "Turn Domain";
          type = lib.types.string;
        };
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
        fqdn = lib.mkOption {
          description = "wastebin Domain";
          type = lib.types.string;
        };
        port = lib.mkOption {
          description = "wastebin Port";
          type = lib.types.int;
        };
      };
    };
  };
}
