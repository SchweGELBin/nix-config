{ config, lib, ... }:
let
  cfg = config.sys.networking;
  gateway = {
    v4 =
      if (cfg.static.mode == "hetzner") then
        "172.31.1.1"
      else if (cfg.static.mode == "oracle") then
        "10.0.0.1"
      else
        "192.168.0.1";
    v6 = "fe80::1";
  };
in
{
  config = lib.mkIf cfg.enable {
    networking = {
      firewall.enable = true;
      hostName = cfg.hostName;
      nat = lib.mkIf cfg.nat.enable {
        enable = true;
        enableIPv6 = true;
        externalInterface = cfg.interface;
      };
      networkmanager.enable = true;
      stevenblack.enable = cfg.adblock.enable;
    }
    // lib.optionalAttrs cfg.dns.enable {
      nameservers =
        lib.optionals cfg.dns.cloudflare.enable [
          "1.1.1.${toString cfg.dns.cloudflare.flavor}"
          "1.0.0.${toString cfg.dns.cloudflare.flavor}"
          "2606:4700:4700::111${toString cfg.dns.cloudflare.flavor}"
          "2606:4700:4700::100${toString cfg.dns.cloudflare.flavor}"
        ]
        ++ lib.optionals cfg.dns.google.enable [
          "8.8.8.8"
          "8.4.4.8"
          "2001:4860:4860::8888"
          "2001:4860:4860::8448"
        ]
        ++ lib.optionals cfg.dns.quad9.enable [
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::9"
          "2620:fe::fe"
        ];
    }
    // lib.optionalAttrs cfg.static.enable {
      defaultGateway = lib.mkIf (gateway.v4 != "") {
        address = gateway.v4;
        interface = cfg.interface;
      };
      defaultGateway6 = lib.mkIf (gateway.v6 != "") {
        address = gateway.v6;
        interface = cfg.interface;
      };
      interfaces.${cfg.interface} = {
        ipv4.addresses = lib.mkIf cfg.static.v4.enable [
          {
            address = cfg.static.v4.ip;
            prefixLength = 24;
          }
        ];
        ipv6.addresses = lib.mkIf cfg.static.v6.enable [
          {
            address = cfg.static.v6.ip;
            prefixLength = 64;
          }
        ];
        useDHCP = cfg.static.dhcp.enable;
      };
    };
  };

  options = {
    sys.networking = {
      enable = lib.mkEnableOption "Enable Networking";
      adblock.enable = lib.mkEnableOption "Enable Ad Blocking";
      dns = {
        enable = lib.mkEnableOption "Enable Custom DNS";
        cloudflare = {
          enable = lib.mkEnableOption "Enable Cloudflare DNS";
          flavor = lib.mkOption {
            description = "Cloudflare DNS Flavor";
            type = (lib.types.ints.between 1 3);
          };
        };
        google.enable = lib.mkEnableOption "Enable Google DNS";
        quad9.enable = lib.mkEnableOption "Enable Quad9 DNS";
      };
      hostName = lib.mkOption {
        description = "Networking Host Name";
        type = lib.types.str;
      };
      interface = lib.mkOption {
        description = "Networking Interface";
        type = lib.types.str;
      };
      nat.enable = lib.mkEnableOption "Enable NAT";
      static = {
        enable = lib.mkEnableOption "Enable Static IPs";
        dhcp.enable = lib.mkEnableOption "Enable DHCP";
        mode = lib.mkOption {
          description = "Static Mode to use";
          type = lib.types.enum [
            "default"
            "hetzner"
            "oracle"
          ];
        };
        v4 = {
          enable = lib.mkEnableOption "Enable Static IPv4";
          ip = lib.mkOption {
            description = "Global IPv4 address";
            type = lib.types.str;
          };
        };
        v6 = {
          enable = lib.mkEnableOption "Enable Static IPv6";
          ip = lib.mkOption {
            description = "Global IPv6 address";
            type = lib.types.str;
          };
        };
      };
    };
  };
}
