{ lib, ... }:
{
  imports = [
    ./greeter.nix
    ./hardware.nix
    ./sound.nix
  ];

  sys.services = {
    greeter.enable = lib.mkDefault true;
    hardware.enable = lib.mkDefault true;
    sound.enable = lib.mkDefault true;
  };
}
