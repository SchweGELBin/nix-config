{ config, lib, ... }:
let
  cfg = config.sys.networking;
in
{
  config = lib.mkIf cfg.enable {
    networking = {
      defaultGateway = lib.mkIf cfg.gateway.enable "192.168.0.1";
      firewall.enable = true;
      hostName = cfg.hostName;
      interfaces.eth0.ipv4.addresses = [
        {
          address = "192.168.0.123";
          prefixLength = 24;
        }
      ];
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      networkmanager.enable = true;
      stevenblack.enable = true;
    };
  };

  options = {
    sys.networking = {
      enable = lib.mkEnableOption "Enable Networking";
      gateway.enable = lib.mkEnableOption "Enable Networking Gateway";
      hostName = lib.mkOption {
        description = "Networking Host Name";
        type = lib.types.str;
      };
    };
  };
}
