{ config, lib, ... }:
{
  config = lib.mkIf config.sys-pkgs.server.enable {
    environment.systemPackages = [ ];
    programs = {
      nix-ld.enable = true;
    };
  };

  options = {
    sys-pkgs.server.enable = lib.mkEnableOption "Enable Server Packages";
  };
}
