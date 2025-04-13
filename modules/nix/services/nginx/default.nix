{ config, lib, ... }:
{
  imports = [
    ./element.nix
    ./jellyfin.nix
    ./matrix.nix
    ./nginx.nix
  ];

  sys.services.nginx = {
    enable = lib.mkDefault false;
    element.enable = lib.mkDefault config.sys.services.nginx.enable;
    jellyfin = {
      enable = lib.mkDefault config.sys.services.nginx.enable;
      port = 8096;
    };
    matrix = {
      enable = lib.mkDefault config.sys.services.nginx.enable;
      port = 6167;
    };
  };
}
