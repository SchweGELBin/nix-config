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
  vars = import ../vars.nix;

  wg = {
    v4 = "10.0.0";
    v6 = "fdc9:281f:04d7:9ee9";
  };
  interface = "wg";
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    networking = {
      firewall.allowedUDPPorts = [
        53
        cfg.port
      ];
      nat.internalInterfaces = [ interface ];
      wg-quick.interfaces.${interface} =
        lib.optionalAttrs (cfg.mode == "client") {
          address = [
            "${wg.v4}.2/24"
            "${wg.v6}::2/64"
          ];
          autostart = cfg.autostart.enable;
          dns = [
            "${wg.v4}.1"
            "${wg.v6}::1"
          ];
          listenPort = cfg.port;
          peers = [
            {
              allowedIPs = [
                "0.0.0.0/0"
                "::/0"
              ];
              endpoint = "${vars.my.domain}:${toString cfg.port}";
              persistentKeepalive = 25;
              publicKey = vars.keys.wgs;
            }
          ];
          privateKeyFile = secrets.wgc.path;
        }
        // lib.optionalAttrs (cfg.mode == "server") {
          address = [
            "${wg.v4}.1/24"
            "${wg.v6}::1/64"
          ];
          autostart = cfg.autostart.enable;
          listenPort = cfg.port;
          peers = [
            {
              allowedIPs = [
                "${wg.v4}.2/24"
                "${wg.v6}::2/64"
              ];
              publicKey = vars.keys.wgc;
            }
          ];
          postUp = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i mix -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -A FORWARD -i mix -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${wg.v4}.1/24 -o eth0 -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s ${wg.v6}::1/64 -o eth0 -j MASQUERADE
          '';
          preDown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i mix -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -D FORWARD -i mix -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${wg.v4}.1/24 -o eth0 -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s ${wg.v6}::1/64 -o eth0 -j MASQUERADE
          '';
          privateKeyFile = secrets.wgs.path;
        };
    };

    services.dnsmasq = {
      enable = true;
      settings.interface = interface;
    };

    sops.secrets = {
      wgc.owner = lib.mkIf (cfg.mode == "client") "root";
      wgs.owner = lib.mkIf (cfg.mode == "server") "root";
    };
  };

  options = {
    sys.wireguard = {
      enable = lib.mkEnableOption "Enable Wireguard";
      autostart.enable = lib.mkEnableOption "Start Wireguard automatically";
      mode = lib.mkOption {
        description = "Wireguard Mode";
        type = lib.types.enum [
          "client"
          "server"
        ];
      };
      port = lib.mkOption {
        description = "Wireguard Port";
        type = lib.types.int;
      };
    };
  };
}
