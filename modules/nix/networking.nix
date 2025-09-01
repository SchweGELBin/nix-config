{ config, lib, ... }:
let
  cfg = config.sys.networking;
in
{
  config = lib.mkIf cfg.enable {
    networking = {
      defaultGateway = if cfg.hetzner.enable then "172.31.1.1" else "192.168.0.1";
      defaultGateway6 = lib.mkIf cfg.hetzner.enable {
        address = "fe80::1";
        interface = cfg.interface;
      };
      firewall.enable = true;
      hostName = cfg.hostName;
      interfaces.${cfg.interface} = {
        ipv4 = {
          addresses =
            [ ]
            ++ lib.optionals cfg.hetzner.enable [
              {
                address = "78.47.17.130";
                prefixLength = 32;
              }
            ]
            ++ lib.optionals cfg.static.enable [
              {
                address = "192.168.0.123";
                prefixLength = 24;
              }
            ];
          routes =
            [ ]
            ++ lib.optionals cfg.hetzner.enable [
              {
                address = "172.31.1.1";
                prefixLength = 32;
              }
            ];
        };
        ipv6 = {
          addresses =
            [ ]
            ++ lib.optionals cfg.hetzner.enable [
              {
                address = "2a01:4f8:1c1c:7645::1";
                prefixLength = 64;
              }
              {
                address = "fe80::9400:4ff:fe27:fd2a";
                prefixLength = 64;
              }
            ];
        };
        routes =
          [ ]
          ++ lib.optionals cfg.hetzner.enable [
            {
              address = "fe80::1";
              prefixLength = 128;
            }
          ];
      };
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      networkmanager.enable = true;
      stevenblack.enable = true;
      useDHCP = true;
    };
  };

  options = {
    sys.networking = {
      enable = lib.mkEnableOption "Enable Networking";
      hetzner.enable = lib.mkEnableOption "Enable Hetzner specific Networking";
      hostName = lib.mkOption {
        description = "Networking Host Name";
        type = lib.types.str;
      };
      interface = lib.mkOption {
        description = "Networking Interface";
        type = lib.types.str;
      };
      static.enable = lib.mkEnableOption "Enable Static IPv4";
    };
  };
}
