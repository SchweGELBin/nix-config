{ config, lib, ... }:
{
  config = lib.mkIf config.sys-pkgs.server.enable {
    environment.systemPackages = [ ];
  };

  options = {
    sys-pkgs = {
      server.enable = lib.mkEnableOption "Enable Server Packages";
    };
  };
}
