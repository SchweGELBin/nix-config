{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hm-pkgs;
  enable = cfg.enable && cfg.server.enable;
in
{
  config = lib.mkIf enable {
    home.packages = with pkgs; [
      wireguard-tools
    ];

    programs = {
      htop.enable = true;
    };
  };
}
