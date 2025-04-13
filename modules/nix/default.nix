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
    ./home-manager.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./packages
    ./services
    ./users.nix
  ];

  sys = {
    boot = {
      enable = lib.mkDefault true;
      configs = lib.mkDefault 2;
    };
    catppuccin.enable = lib.mkDefault true;
    environment.enable = lib.mkDefault true;
    fonts.enable = lib.mkDefault true;
    home-manager.enable = lib.mkDefault true;
    locale = {
      enable = lib.mkDefault true;
      stateVersion = lib.mkForce vars.user.stateVersion;
    };
    networking = {
      enable = lib.mkDefault true;
      gateway.enable = lib.mkDefault true;
      hostName = lib.mkDefault vars.user.hostname.home;
    };
    nix.enable = lib.mkDefault true;
    users = {
      enable = lib.mkDefault true;
      name = lib.mkForce vars.user.name;
    };
  };
}
