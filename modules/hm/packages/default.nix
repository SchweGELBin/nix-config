{ lib, ... }:
{
  imports = [
    ./all.nix
    ./home.nix
    ./server.nix
  ];

  hm-pkgs = {
    home.enable = lib.mkDefault false;
    server.enable = lib.mkDefault false;
  };
}
