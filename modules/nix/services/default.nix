{ lib, ... }:
{
  imports = [
    ./greeter.nix
    ./hardware.nix
    ./minecraft.nix
    ./nginx
    ./smoos.nix
    ./sound.nix
    ./wireguard.nix
  ];

  sys.services = {
    greeter.enable = lib.mkDefault true;
    hardware.enable = lib.mkDefault true;
    minecraft = {
      enable = lib.mkDefault false;
      port = lib.mkDefault 25565;
    };
    smoos = {
      enable = lib.mkDefault false;
      port = lib.mkDefault 1027;
    };
    sound.enable = lib.mkDefault true;
    wireguard = {
      enable = lib.mkDefault false;
      port = lib.mkDefault 1096;
    };
  };
}
