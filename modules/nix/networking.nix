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
    v6 = if (cfg.static.mode == "hetzner") then "fe80::1" else "";
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
      stevenblack.enable = true;
      useDHCP = lib.mkDefault true;
    }
    // lib.optionalAttrs cfg.dns.enable {
      nameservers =
        lib.optionals cfg.dns.cloudflare.enable [
          "1.1.1.${toString cfg.dns.cloudflare.flavor}"
          "1.0.0.${toString cfg.dns.cloudflare.flavor}"
        ]
        ++ lib.optionals cfg.dns.google.enable [
          "8.8.8.8"
          "8.4.4.8"
        ]
        ++ lib.optionals cfg.dns.quad9.enable [
          "9.9.9.9"
          "149.112.112.112"
        ];
    }
    // lib.optionalAttrs cfg.static.enable {
      defaultGateway = gateway.v4;
      defaultGateway6 = lib.mkIf (gateway.v6 != "") {
        address = gateway.v6;
        interface = cfg.interface;
      };
      interfaces.${cfg.interface} = {
        ipv4 = {
          addresses = lib.mkIf cfg.static.v4.enable [
            {
              address = cfg.static.v4.ip;
              prefixLength = 24;
            }
          ];
          routes = [
            {
              address = gateway.v4;
              prefixLength = 32;
            }
          ];
        };
        ipv6 = {
          addresses = lib.mkIf cfg.static.v6.enable [
            {
              address = cfg.static.v6.ip;
              prefixLength = 64;
            }
          ];
          routes = [
            {
              address = gateway.v6;
              prefixLength = 128;
            }
          ];
        };
      };
    };
  };

  options = {
    sys.networking = {
      enable = lib.mkEnableOption "Enable Networking";
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
