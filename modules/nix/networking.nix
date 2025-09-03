{ config, lib, ... }:
let
  cfg = config.sys.networking;
in
{
  config = lib.mkIf cfg.enable {
    networking = {
      firewall.enable = true;
      hostName = cfg.hostName;
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      networkmanager.enable = true;
      stevenblack.enable = true;
      useDHCP = lib.mkDefault true;
    }
    // lib.optionalAttrs cfg.static.enable {
      defaultGateway = if (cfg.static.mode == "hetzner") then "172.31.1.1" else "192.168.0.1";
      defaultGateway6 = lib.mkIf (cfg.static.mode == "hetzner") {
        address = "fe80::1";
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
      };
    };
  };

  options = {
    sys.networking = {
      enable = lib.mkEnableOption "Enable Networking";
      hostName = lib.mkOption {
        description = "Networking Host Name";
        type = lib.types.str;
      };
      interface = lib.mkOption {
        description = "Networking Interface";
        type = lib.types.str;
      };
      static = {
        enable = lib.mkEnableOption "Enable Static IPs";
        mode = lib.mkOption {
          description = "Static Mode to use";
          type = lib.types.enum [
            "default"
            "hetzner"
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
