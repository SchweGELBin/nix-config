{ config, lib, ... }:
{
  config = lib.mkIf config.sys-pkgs.home.enable {
    environment.systemPackages = [ ];
  };

  options = {
    sys-pkgs = {
      home.enable = lib.mkEnableOption "Enable Home Packages";
    };
  };
}
