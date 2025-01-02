{ lib, ... }:
{
  imports = [
    ./all.nix
    ./home.nix
    ./server.nix
  ];

  sys-pkgs = {
    home.enable = lib.mkDefault false;
    server.enable = lib.mkDefault false;
  };
}
