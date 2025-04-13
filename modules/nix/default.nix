{ lib, ... }:
let
  vars = import ./vars.nix;
in
{
  imports = [
    ./boot.nix
    ./catppuccin.nix
    ./config.nix
    ./home-manager.nix
    ./networking.nix
    ./nix.nix
    ./packages
    ./users.nix
  ];

  sys = {
    boot = {
      enable = lib.mkDefault true;
      configs = lib.mkDefault 2;
    };
    catppuccin.enable = lib.mkDefault true;
    home-manager.enable = lib.mkDefault true;
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
