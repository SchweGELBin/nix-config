{
  inputs,
  pkgs,
  ...
}:

let
  vars = import ../../modules/nix/vars.nix;
in

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ../../modules/nix/default.nix
    inputs.arion.nixosModules.arion
  ];

  boot = {
    loader.grub.configurationLimit = 2;
  };

  home-manager = {
    users = {
      ${vars.user.name} = import ./home.nix;
    };
  };

  networking = {
    firewall.enable = false;
    nat = {
      enable = true;
      externalInterface = "eth0";
      internalInterfaces = [ "mix" ];
    };
    wireguard = {
      enable = true;
      interfaces.mix = {
        generatePrivateKeyFile = true;
        ips = [ "10.0.0.1/24" ];
        listenPort = 1096;
        peers = [
          {
            allowedIPs = [ "10.0.0.2/32" ];
            publicKey = vars.keys.wg0;
          }
          {
            allowedIPs = [ "10.0.0.3/32" ];
            publicKey = vars.keys.wg1;
          }
          {
            allowedIPs = [ "10.0.0.4/32" ];
            publicKey = vars.keys.wg2;
          }
        ];
        postSetup = "${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE";
        postShutdown = "${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE";
        privateKeyFile = "/root/wg/mix";
      };
    };
  };

  services = {
    minecraft-server = {
      enable = true;
      dataDir = "/var/lib/minecraft";
      declarative = true;
      eula = true;
      jvmOpts = "-Xms2G -Xmx2G";
      openFirewall = false;
      package = pkgs.minecraft-server;
      serverProperties = {
        difficulty = "hard";
        enable-command-block = false;
        enforce-whitelist = true;
        force-gamemode = true;
        max-players = 7;
        motd = "MiX MC";
        op-permission-level = 2;
        simulation-distance = 6;
        view-distance = 8;
        white-list = false;
      };
      whitelist = {
        schwegelbin = "bc3a1c45-03cb-43c6-b860-1def6fddcdb9";
      };
    };
    nginx = {
      enable = true;
      virtualHosts.mix = {
        default = true;
        root = "/var/www/mix";
      };
    };
  };

  users = {
    users.${vars.user.name} = {
      openssh.authorizedKeys.keys = [ vars.keys.ssh ];
    };
  };

  virtualisation = {
    arion = {
      backend = "docker";
      projects = {
        smoo = {
          settings = {
            services.server.service = {
              image = "ghcr.io/sanae6/smo-online-server";
              ports = [ "1027:1027" ];
              restart = "unless-stopped";
              volumes = [ "data:/var/lib/smoo" ];
            };
            docker-compose.volumes = {
              data = { };
            };
          };
        };
      };
    };
  };

  zramSwap = {
    enable = true;
  };
}
