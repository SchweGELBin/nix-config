{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.wireguard;
  secrets = config.sops.secrets;
  vars = import ./vars.nix;

  wg = {
    v4 = "10.0.0";
    v6 = "fdc9:281f:04d7:9ee9";
  };
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = lib.mkIf cfg.enable {
    networking = {
      firewall.allowedUDPPorts = [
        53
        cfg.port
      ];
      nat = {
        enable = true;
        externalInterface = "eth0";
        internalInterfaces = [ "mix" ];
      };
      wireguard = {
        enable = true;
        interfaces.mix = {
          ips = [
            "${wg.v4}.1/24"
            "${wg.v6}::1/64"
          ];
          listenPort = cfg.port;
          peers = [
            {
              allowedIPs = [
                "${wg.v4}.2/32"
                "${wg.v6}::2/128"
              ];
              publicKey = vars.keys.wg0;
            }
            {
              allowedIPs = [
                "${wg.v4}.3/32"
                "${wg.v6}::3/128"
              ];
              publicKey = vars.keys.wg1;
            }
            {
              allowedIPs = [
                "${wg.v4}.4/32"
                "${wg.v6}::4/128"
              ];
              publicKey = vars.keys.wg2;
            }
          ];
          postSetup = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i mix -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -A FORWARD -i mix -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${wg.v4}.1/24 -o eth0 -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s ${wg.v6}::1/64 -o eth0 -j MASQUERADE
          '';
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i mix -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -D FORWARD -i mix -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${wg.v4}.1/24 -o eth0 -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s ${wg.v6}::1/64 -o eth0 -j MASQUERADE
          '';
          privateKeyFile = secrets.wg.path;
        };
      };
    };

    services.dnsmasq = {
      enable = true;
      settings = {
        interface = "mix";
      };
    };

    sops.secrets.wg = { };
  };

  options = {
    sys.wireguard = {
      enable = lib.mkEnableOption "Enable Wireguard";
      port = lib.mkOption {
        description = "Wireguard Port";
        type = lib.types.int;
      };
    };
  };
}
