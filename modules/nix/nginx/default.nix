{ config, lib, ... }:
let
  cfg = config.sys.nginx;
in
{
  imports = [
    ./collabora.nix
    ./coturn.nix
    ./element.nix
    ./filebrowser.nix
    ./forgejo.nix
    ./immich.nix
    ./invidious.nix
    ./jellyfin.nix
    ./mail.nix
    ./matrix.nix
    ./nextcloud.nix
    ./ollama.nix
    ./onlyoffice.nix
    ./opencloud.nix
    ./peertube.nix
    ./piped.nix
    ./radicale.nix
    ./searxng.nix
    ./thelounge.nix
    ./uptimekuma.nix
    ./vaultwarden.nix
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
      collabora = {
        enable = lib.mkEnableOption "Enable Collabora Online";
        fqdn = lib.mkOption {
          description = "Collabora Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "Collabora Port";
          type = lib.types.int;
        };
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
      filebrowser = {
        enable = lib.mkEnableOption "Enable FileBrowser";
        fqdn = lib.mkOption {
          description = "FileBrowser Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "FileBrowser Port";
          type = lib.types.int;
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
      ollama = {
        enable = lib.mkEnableOption "Enable Ollama";
        port = lib.mkOption {
          description = "Ollama Port";
          type = lib.types.int;
        };
        web = {
          enable = lib.mkEnableOption "Enable Ollama Web";
          mode = lib.mkOption {
            description = "Ollama Web Service";
            type = lib.types.enum [
              "librechat"
              "nextjs-ollama-llm-ui"
              "open-webui"
            ];
          };
          fqdn = lib.mkOption {
            description = "Ollama Web Domain";
            type = lib.types.str;
          };
          port = lib.mkOption {
            description = "Ollama Web Port";
            type = lib.types.int;
          };
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
      piped = {
        enable = lib.mkEnableOption "Enable Piped";
        fqdn = lib.mkOption {
          description = "Piped Domain";
          type = lib.types.str;
        };
      };
      radicale = {
        enable = lib.mkEnableOption "Enable Radicale";
        fqdn = lib.mkOption {
          description = "Radicale Domain";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "Radicale Port";
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
      vaultwarden = {
        enable = lib.mkEnableOption "Enable Vaultwarden";
        fqdn = lib.mkOption {
          description = "Vaultwarden Domain";
          type = lib.types.str;
        };
        mail = lib.mkOption {
          description = "Vaultwarden Mail";
          type = lib.types.str;
        };
        port = lib.mkOption {
          description = "Vaultwarden Port";
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
