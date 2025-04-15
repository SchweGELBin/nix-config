{ config, lib, ... }:
let
  cfg = config.sys.pkgs;
  enable = cfg.enable && cfg.server.enable;
in
{
  config = lib.mkIf enable {
    environment.systemPackages = [ ];
    programs = {
      nix-ld.enable = true;
    };
  };
}
