{
  config,
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
    inputs.sops-nix.nixosModules.sops
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
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i mix -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i mix -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
        '';
        privateKeyFile = config.sops.secrets.wg.path;
      };
    };
  };

  programs = {
    nix-ld.enable = true;
  };

  services = {
    dnsmasq = {
      enable = true;
      settings = {
        interface = "mix";
      };
    };
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

  sops = {
    defaultSopsFile = ../../secrets/mix.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      dcbot.owner = "smoo";
      dcch1.owner = "smoo";
      dcch2.owner = "smoo";
      wg = { };
    };
  };

  users = {
    groups = {
      systemd = { };
    };
    users = {
      ${vars.user.name} = {
        openssh.authorizedKeys.keys = [ vars.keys.ssh ];
      };
      smoo = {
        createHome = true;
        group = "systemd";
        home = "/var/lib/smoo";
        isSystemUser = true;
      };
    };
  };

  systemd.services = {
    smoo = {
      enable = true;
      preStart = ''
        if [[ -f settings.json ]]; then
          rm settings.json
        fi
        if [[ ! -d SmoOnlineServer ]]; then
          ${pkgs.git}/bin/git clone https://github.com/Sanae6/SmoOnlineServer.git
          sed -i -e "s/net6.0/net8.0/g" ./SmoOnlineServer/Server/Server.csproj
          sed -i -e "s/Prefix { get; set; } = \"\$\";/Prefix { get; set; } = \".\";/g" ./SmoOnlineServer/Server/Settings.cs
          sed -i -e "s/Token { get; set; }/Token { get; set; } = \"$(cat ${config.sops.secrets.dcbot.path})\";/g" ./SmoOnlineServer/Server/Settings.cs
          sed -i -e "s/LogChannel { get; set; }/LogChannel { get; set; } = \"$(cat ${config.sops.secrets.dcch1.path})\";/g" ./SmoOnlineServer/Server/Settings.cs
          sed -i -e "s/CommandChannel { get; set; }/CommandChannel { get; set; } = \"$(cat ${config.sops.secrets.dcch2.path})\";/g" ./SmoOnlineServer/Server/Settings.cs
        fi
      '';
      script = ''
        ${pkgs.dotnet-sdk_8}/bin/dotnet run --project ./SmoOnlineServer/Server/Server.csproj -c Release
      '';
      serviceConfig = {
        User = "smoo";
        WorkingDirectory = "/var/lib/smoo";
      };
    };
  };

  zramSwap = {
    enable = true;
  };
}
