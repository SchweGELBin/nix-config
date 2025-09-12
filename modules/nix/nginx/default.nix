{ config, lib, ... }:
let
  cfg = config.sys.nginx;
in
{
  imports = [
    ./coturn.nix
    ./element.nix
    ./forgejo.nix
    ./immich.nix
    ./invidious.nix
    ./jellyfin.nix
    ./mail.nix
    ./matrix.nix
    ./nextcloud.nix
    ./onlyoffice.nix
    ./opencloud.nix
    ./peertube.nix
    ./searxng.nix
    ./thelounge.nix
    ./uptimekuma.nix
    ./wastebin.nix
    ./www.nix
    ./zipline.nix
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
    };
  };

  options = {
    sys.nginx = {
      enable = lib.mkEnableOption "Enable Nginx";
      domain = lib.mkOption {
        description = "Nginx Domain";
        type = lib.types.str;
      };
      coturn = {
        enable = lib.mkEnableOption "Enable Turn";
        fqdn = lib.mkOption {
          description = "Turn Domain";
          type = lib.types.str;
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
      element = {
        enable = lib.mkEnableOption "Enable Element";
        fqdn = lib.mkOption {
          description = "Element Domain";
          type = lib.types.str;
        };
      };
      forgejo = {
        enable = lib.mkEnableOption "Enable Forgejo";
        fqdn = lib.mkOption {
          description = "Forgejo Domain";
          type = lib.types.str;
        };
        mail = lib.mkOption {
          description = "Forgejo Mail";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "Forgejo Port";
          type = lib.types.int;
        };
        username = lib.mkOption {
          description = "Forgejo Admin Username";
          type = lib.types.str;
        };
      };
      immich = {
        enable = lib.mkEnableOption "Enable Immich";
        fqdn = lib.mkOption {
          description = "Immich Domain";
          type = lib.types.str;
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
          type = lib.types.str;
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
          type = lib.types.str;
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
          type = lib.types.str;
        };
      };
      matrix = {
        enable = lib.mkEnableOption "Enable Matrix";
        fqdn = lib.mkOption {
          description = "Matrix Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "Matrix Port";
          type = lib.types.int;
        };
        signal = {
          enable = lib.mkEnableOption "Enable Signal Bridge";
          port = lib.mkOption {
            description = "Signal Bridge Port";
            type = lib.types.int;
          };
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
          type = lib.types.str;
        };
      };
      onlyoffice = {
        enable = lib.mkEnableOption "Enable OnlyOffice";
        fqdn = lib.mkOption {
          description = "OnlyOffice Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "OnlyOffice Port";
          type = lib.types.int;
        };
      };
      opencloud = {
        enable = lib.mkEnableOption "Enable OpenCloud";
        fqdn = lib.mkOption {
          description = "OpenCloud Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "OpenCloud Port";
          type = lib.types.int;
        };
      };
      peertube = {
        enable = lib.mkEnableOption "Enable PeerTube";
        fqdn = lib.mkOption {
          description = "Peertube Domain";
          type = lib.types.str;
        };
        mail = lib.mkOption {
          description = "Peertube Mail";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "PeerTube Port";
          type = lib.types.int;
        };
      };
      searxng = {
        enable = lib.mkEnableOption "Enable SearXNG";
        fqdn = lib.mkOption {
          description = "SearXNG Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "SearXNG Port";
          type = lib.types.int;
        };
      };
      thelounge = {
        enable = lib.mkEnableOption "Enable The Lounge";
        ergo = {
          enable = lib.mkEnableOption "Enable Ergo";
          port = lib.mkOption {
            description = "Ergo Port";
            type = lib.types.int;
          };
        };
        fqdn = lib.mkOption {
          description = "The Lounge Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "The Lounge Port";
          type = lib.types.int;
        };
      };
      uptimekuma = {
        enable = lib.mkEnableOption "Enable Uptime Kuma";
        fqdn = lib.mkOption {
          description = "Uptime Kuma Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "Uptime Kuma Port";
          type = lib.types.int;
        };
      };
      wastebin = {
        enable = lib.mkEnableOption "Enable wastebin";
        fqdn = lib.mkOption {
          description = "wastebin Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "wastebin Port";
          type = lib.types.int;
        };
      };
      website.enable = lib.mkEnableOption "Enable Website";
      zipline = {
        enable = lib.mkEnableOption "Enable Zipline";
        fqdn = lib.mkOption {
          description = "Zipline Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "Zipline Port";
          type = lib.types.int;
        };
      };
    };
  };
}
