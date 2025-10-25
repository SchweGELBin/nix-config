{ lib, ... }:
let
  vars = import ../vars.nix;
in
{
  imports = [
    ./boot.nix
    ./catppuccin.nix
    ./disko
    ./environment.nix
    ./fonts.nix
    ./gickup.nix
    ./greeter.nix
    ./hardware.nix
    ./home-manager.nix
    ./impermanence.nix
    ./locale
    ./minecraft.nix
    ./networking.nix
    ./nginx
    ./nix.nix
    ./packages.nix
    ./security.nix
    ./smoos.nix
    ./sound.nix
    ./users.nix
    ./wireguard.nix
  ];

  sys = {
    boot = {
      enable = lib.mkDefault true;
      configs = lib.mkDefault 2;
      modules = {
        ntsync.enable = lib.mkDefault false;
        v4l2loopback.enable = lib.mkDefault false;
      };
      timeout = lib.mkDefault 0;
    };
    catppuccin.enable = lib.mkDefault true;
    disko = {
      enable = lib.mkDefault true;
      device = lib.mkDefault "/dev/sda";
    };
    environment.enable = lib.mkDefault true;
    fonts.enable = lib.mkDefault true;
    gickup = {
      enable = lib.mkDefault false;
      cron.enable = lib.mkDefault false;
      forks.enable = lib.mkDefault false;
      issues.enable = lib.mkDefault false;
      starred.enable = lib.mkDefault false;
    };
    greeter.enable = lib.mkDefault true;
    hardware = {
      enable = lib.mkDefault true;
      nvidia.enable = lib.mkDefault true;
      printing.enable = lib.mkDefault false;
    };
    home-manager.enable = lib.mkDefault true;
    impermanence.enable = lib.mkDefault false;
    locale.enable = lib.mkDefault true;
    minecraft = {
      enable = lib.mkDefault false;
      bot.enable = lib.mkDefault false;
      server = {
        enable = lib.mkDefault true;
        port = lib.mkDefault 25565;
        whitelist.enable = lib.mkDefault true;
      };
    };
    networking = {
      enable = lib.mkDefault true;
      hostName = lib.mkDefault vars.user.hostname.home;
      interface = lib.mkDefault "eth0";
      nat.enable = lib.mkDefault false;
      static = {
        enable = lib.mkDefault false;
        mode = lib.mkDefault "default";
        v4 = {
          enable = lib.mkDefault false;
          ip = lib.mkDefault "w.x.y.z";
        };
        v6 = {
          enable = lib.mkDefault false;
          ip = lib.mkDefault "wxyz::1";
        };
      };
    };
    nginx = {
      enable = lib.mkDefault false;
      domain = lib.mkDefault vars.my.domain;
      collabora = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "cool.${vars.my.domain}";
        port = lib.mkDefault 9980;
      };
      coturn = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "turn.${vars.my.domain}";
        port = lib.mkDefault 5349;
        port-alt = lib.mkDefault 5350;
        relay-max = lib.mkDefault 50000;
        relay-min = lib.mkDefault 49500;
      };
      element = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "element.${vars.my.domain}";
      };
      filebrowser = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "files.${vars.my.domain}";
        port = lib.mkDefault 8181;
      };
      forgejo = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "git.${vars.my.domain}";
        mail = lib.mkDefault "forgejo@${vars.my.domain}";
        port = lib.mkDefault 3000;
        username = lib.mkDefault vars.user.name;
      };
      immich = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "immich.${vars.my.domain}";
        port = lib.mkDefault 2283;
      };
      invidious = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "iv.${vars.my.domain}";
        port = lib.mkDefault 3500;
      };
      jellyfin = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "jelly.${vars.my.domain}";
        port = lib.mkDefault 8096;
      };
      mail = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "mail.${vars.my.domain}";
      };
      matrix = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "matrix.${vars.my.domain}";
        port = lib.mkDefault 6167;
        signal = {
          enable = lib.mkDefault true;
          port = lib.mkDefault 29328;
        };
        whatsapp = {
          enable = lib.mkDefault true;
          port = lib.mkDefault 29318;
        };
      };
      nextcloud = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "next.${vars.my.domain}";
      };
      ollama = {
        enable = lib.mkDefault true;
        port = lib.mkDefault 11434;
        web = {
          enable = lib.mkDefault true;
          fqdn = lib.mkDefault "ai.${vars.my.domain}";
          port = lib.mkDefault 11435;
        };
      };
      onlyoffice = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "office.${vars.my.domain}";
        port = lib.mkDefault 8000;
      };
      opencloud = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "cloud.${vars.my.domain}";
        port = lib.mkDefault 9200;
      };
      peertube = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "pt.${vars.my.domain}";
        mail = lib.mkDefault "peertube@${vars.my.domain}";
        port = lib.mkDefault 9000;
      };
      radicale = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "dav.${vars.my.domain}";
        port = lib.mkDefault 5232;
      };
      searxng = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "searx.${vars.my.domain}";
        port = lib.mkDefault 8888;
      };
      thelounge = {
        enable = lib.mkDefault true;
        ergo = {
          enable = lib.mkDefault true;
          port = lib.mkDefault 6667;
        };
        fqdn = lib.mkDefault "irc.${vars.my.domain}";
        port = lib.mkDefault 6789;
      };
      uptimekuma = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "uptime.${vars.my.domain}";
        port = lib.mkDefault 3001;
      };
      vaultwarden = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "vault.${vars.my.domain}";
        mail = lib.mkDefault "vault@${vars.my.domain}";
        port = lib.mkDefault 8222;
      };
      wastebin = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "bin.${vars.my.domain}";
        port = lib.mkDefault 8899;
      };
      website.enable = lib.mkDefault true;
      zipline = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "zip.${vars.my.domain}";
        port = lib.mkDefault 3002;
      };
    };
    nix = {
      enable = lib.mkDefault true;
      cuda.enable = lib.mkDefault false;
      gc.enable = lib.mkDefault false;
    };
    pkgs = {
      enable = lib.mkDefault true;
      home = {
        enable = lib.mkDefault false;
        wm = lib.mkDefault "hyprland";
      };
      server.enable = lib.mkDefault false;
    };
    security = {
      enable = lib.mkDefault true;
      acme.enable = lib.mkDefault false;
      ssh.enable = lib.mkDefault false;
    };
    smoos = {
      enable = lib.mkDefault false;
      bot = {
        enable = lib.mkDefault true;
        port = lib.mkDefault 1027;
      };
      cs = {
        enable = lib.mkDefault true;
        port = lib.mkDefault 1027;
      };
    };
    sound.enable = lib.mkDefault true;
    users.enable = lib.mkDefault true;
    wireguard = {
      enable = lib.mkDefault true;
      autostart.enable = lib.mkDefault false;
      mode = lib.mkDefault "client";
      port = lib.mkDefault 1096;
    };
  };
}
