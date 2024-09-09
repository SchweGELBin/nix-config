{ config, lib, ... }:
{
  config = lib.mkIf config.mako.enable {
    services.mako = {
      enable = true;
      borderRadius = 5;
      borderSize = 2;
      defaultTimeout = 2000;
      layer = "overlay";
    };
  };

  options = {
    mako.enable = lib.mkEnableOption "Enable Mako";
  };
}
