{ lib, ... }:
let
  vars = import ./vars.nix;
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
    ./mail.nix
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
    mail.enable = lib.mkDefault false;
    minecraft = {
      enable = lib.mkDefault false;
      port = lib.mkDefault 25565;
    };
    networking = {
      enable = lib.mkDefault true;
      gateway.enable = lib.mkDefault true;
      hostName = lib.mkDefault vars.user.hostname.home;
    };
    nginx = {
      enable = lib.mkDefault false;
      element.enable = lib.mkDefault true;
      jellyfin = {
        enable = lib.mkDefault true;
        port = lib.mkDefault 8096;
      };
      matrix = {
        enable = lib.mkDefault true;
        port = lib.mkDefault 6167;
        whatsapp = {
          enable = lib.mkDefault true;
          port = lib.mkDefault 29318;
        };
      };
      turn = {
        enable = lib.mkDefault true;
        port = lib.mkDefault 5349;
        port-alt = lib.mkDefault 5350;
        relay-max = lib.mkDefault 50000;
        relay-min = lib.mkDefault 49500;
      };
    };
    nix = {
      enable = lib.mkDefault true;
      gc.enable = lib.mkDefault false;
    };
    pkgs = {
      enable = lib.mkDefault true;
      home.enable = lib.mkDefault false;
      server.enable = lib.mkDefault false;
    };
    security.enable = lib.mkDefault true;
    smoos = {
      enable = lib.mkDefault false;
      port = lib.mkDefault 1027;
    };
    sound.enable = lib.mkDefault true;
    users.enable = lib.mkDefault true;
    wireguard = {
      enable = lib.mkDefault false;
      port = lib.mkDefault 1096;
    };
  };
}
