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
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      nat = lib.mkIf cfg.nat.enable {
        enable = true;
        enableIPv6 = true;
        externalInterface = cfg.interface;
      };
      networkmanager.enable = true;
      stevenblack.enable = true;
      useDHCP = lib.mkDefault true;
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
