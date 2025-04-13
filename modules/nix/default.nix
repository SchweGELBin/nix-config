{ lib, ... }:
{
  imports = [
    ./boot.nix
    ./config.nix
    ./packages
  ];

  sys.boot = {
    enable = lib.mkDefault true;
    configs = lib.mkDefault 2;
  };
}
