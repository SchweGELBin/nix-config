{ lib, ... }:
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
    ./ryuldn.nix
    ./security.nix
    ./smoos.nix
    ./sound.nix
    ./users.nix
    ./wireguard.nix
    ./wsl.nix
  ];

  sys = {
    boot.enable = lib.mkDefault true;
    catppuccin.enable = lib.mkDefault true;
    disko.enable = lib.mkDefault true;
    environment.enable = lib.mkDefault true;
    fonts.enable = lib.mkDefault true;
    greeter.enable = lib.mkDefault true;
    hardware.enable = lib.mkDefault true;
    home-manager.enable = lib.mkDefault true;
    locale.enable = lib.mkDefault true;
    networking.enable = lib.mkDefault true;
    nix.enable = lib.mkDefault true;
    pkgs.enable = lib.mkDefault true;
    security.enable = lib.mkDefault true;
    sound.enable = lib.mkDefault true;
    users.enable = lib.mkDefault true;
    wireguard.enable = lib.mkDefault true;
  };
}
