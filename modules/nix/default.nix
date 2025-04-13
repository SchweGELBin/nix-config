{ lib, ... }:
let
  vars = import ./vars.nix;
in
{
  imports = [
    ./boot.nix
    ./catppuccin.nix
    ./config.nix
    ./networking.nix
    ./packages
  ];

  sys = {
    boot = {
      enable = lib.mkDefault true;
      configs = lib.mkDefault 2;
    };
    catppuccin.enable = lib.mkDefault true;
    networking = {
      enable = lib.mkDefault true;
      gateway.enable = lib.mkDefault true;
      hostName = lib.mkDefault vars.user.hostname.home;
    };
  };
}
