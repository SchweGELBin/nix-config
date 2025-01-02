{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hm-pkgs.server.enable {
    home.packages = with pkgs; [
      wireguard-tools
    ];

    programs = {
      htop.enable = true;
    };
  };

  options = {
    hm-pkgs = {
      server.enable = lib.mkEnableOption "Enable Server Packages";
    };
  };
}
