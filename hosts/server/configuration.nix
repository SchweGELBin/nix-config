{
  config,
  inputs,
  pkgs,
  ...
}:

let
  vars = import ../../modules/nix/vars.nix;
  wg = {
    v4 = "10.0.0";
    v6 = "fdc9:281f:04d7:9ee9";
  };
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
    firewall = {
      allowedTCPPorts = [
        80
        443
        1027
        1436
        25565
      ];
      allowedUDPPorts = [
        53
        1096
      ];
    };
    hostName = vars.user.hostname.server;
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
        listenPort = 1096;
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
        privateKeyFile = config.sops.secrets.wg.path;
      };
    };
  };

  nix = {
    gc.automatic = true;
  };

  programs = {
    nix-ld.enable = true;
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "acme@${vars.my.domain}";
    };
  };

  services = {
    dnsmasq = {
      enable = true;
      settings = {
        interface = "mix";
      };
    };
    fail2ban.enable = true;
    jellyfin.enable = true;
    matrix-conduit = {
      enable = true;
      settings.global = {
        allow_registration = true;
        database_backend = "rocksdb";
        enable_lightning_bolt = false;
        server_name = "${vars.my.domain}";
        well_known_client = "https://matrix.${vars.my.domain}";
        well_known_server = "matrix.${vars.my.domain}";
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
      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedZstdSettings = true;
      virtualHosts = {
        ${vars.my.domain} = {
          default = true;
          enableACME = true;
          forceSSL = true;
          root = "/var/www";
        };
        "element.${vars.my.domain}" = {
          enableACME = true;
          forceSSL = true;
          root = pkgs.element-web.override {
            conf = {
              default_server_config."m.homeserver" = {
                base_url = "https://matrix.${vars.my.domain}";
                server_name = "${vars.my.domain}";
              };
              default_theme = "dark";
              disable_custom_urls = true;
            };
          };
        };
        "jelly.${vars.my.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://localhost:8096";
        };
        "matrix.${vars.my.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://localhost:6167";
        };
      };
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/mix.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      dcid.owner = "smoo";
      dctoken.owner = "smoo";
      smtoken1.owner = "smoo";
      smtoken2.owner = "smoo";
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
    smoos = {
      enable = true;
      preStart = ''
        repo="SMOOS-CS"
        if [[ ! -d ./$repo ]]; then
          ${pkgs.git}/bin/git clone https://github.com/SchweGELBin/$repo.git
          cp ./$repo/settings.json .
          sed -i '/JsonApi/{n;s/false/true/}' ./settings.json
          sed -i -e "s/\"SECRET_TOKEN_1\"/\"$(cat ${config.sops.secrets.smtoken1.path})\"/g" ./settings.json
          sed -i -e "s/\"SECRET_TOKEN_2\"/\"$(cat ${config.sops.secrets.smtoken2.path})\"/g" ./settings.json
        fi
      '';
      script = ''
        ${pkgs.dotnet-sdk_8}/bin/dotnet run --project ./SMOOS-CS/Server/Server.csproj -c Release
      '';
      serviceConfig = {
        User = "smoo";
        WorkingDirectory = "/var/lib/smoo";
      };
      wantedBy = [ "multi-user.target" ];
    };
    smoos-bot = {
      enable = true;
      preStart = ''
        repo="SMOOS-Bot"
        if [[ ! -d ./$repo ]]; then
          ${pkgs.git}/bin/git clone https://github.com/SchweGELBin/$repo.git
        fi
      '';
      script = ''
        export DISCORD_TOKEN="$(cat ${config.sops.secrets.dctoken.path})"
        export DISCORD_ID="$(cat ${config.sops.secrets.dcid.path})"
        export API_TOKEN="$(cat ${config.sops.secrets.smtoken2.path})"
        export CC="${pkgs.gcc}/bin/gcc"
        export AR="${pkgs.gcc}/bin/ar"
        export RUSTFLAGS="-C linker=$CC"
        export RUSTC="${pkgs.fenix.minimal.rustc}/bin/rustc"
        cd SMOOS-Bot
        ${pkgs.fenix.minimal.cargo}/bin/cargo run -r
      '';
      serviceConfig = {
        User = "smoo";
        WorkingDirectory = "/var/lib/smoo";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  zramSwap = {
    enable = true;
  };

  # Custom modules
  sys-pkgs.server.enable = true;
}
