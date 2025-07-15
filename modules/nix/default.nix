{ lib, ... }:
let
  vars = import ../vars.nix;
in
{
  imports = [
    ./boot.nix
    ./catppuccin.nix
    ./environment.nix
    ./fonts.nix
    ./greeter.nix
    ./hardware.nix
    ./home-manager.nix
    ./locale.nix
    ./minecraft.nix
    ./networking.nix
    ./nginx
    ./nix.nix
    ./packages
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
      timeout = lib.mkDefault 0;
    };
    catppuccin.enable = lib.mkDefault true;
    environment.enable = lib.mkDefault true;
    fonts.enable = lib.mkDefault true;
    greeter.enable = lib.mkDefault true;
    hardware.enable = lib.mkDefault true;
    home-manager.enable = lib.mkDefault true;
    locale.enable = lib.mkDefault true;
    minecraft = {
      enable = lib.mkDefault false;
      bot.enable = lib.mkDefault true;
      server = {
        enable = lib.mkDefault true;
        port = lib.mkDefault 25565;
      };
    };
    networking = {
      enable = lib.mkDefault true;
      gateway.enable = lib.mkDefault true;
      hostName = lib.mkDefault vars.user.hostname.home;
    };
    nginx = {
      enable = lib.mkDefault false;
      domain = lib.mkDefault vars.my.domain;
      element = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "element.${vars.my.domain}";
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
        whatsapp = {
          enable = lib.mkDefault true;
          port = lib.mkDefault 29318;
        };
      };
      nextcloud = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "cloud.${vars.my.domain}";
      };
      peertube = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "pt.${vars.my.domain}";
        mail = lib.mkDefault "peertube@${vars.my.domain}";
        port = lib.mkDefault 9000;
      };
      searx = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "searx.${vars.my.domain}";
        port = lib.mkDefault 8888;
      };
      turn = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "turn.${vars.my.domain}";
        port = lib.mkDefault 5349;
        port-alt = lib.mkDefault 5350;
        relay-max = lib.mkDefault 50000;
        relay-min = lib.mkDefault 49500;
      };
      uptime = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "uptime.${vars.my.domain}";
        port = lib.mkDefault 3001;
      };
      wastebin = {
        enable = lib.mkDefault true;
        fqdn = lib.mkDefault "bin.${vars.my.domain}";
        port = lib.mkDefault 8899;
      };
    };
    nix = {
      enable = lib.mkDefault true;
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
    security.enable = lib.mkDefault true;
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
      enable = lib.mkDefault false;
      port = lib.mkDefault 1096;
    };
  };
}
